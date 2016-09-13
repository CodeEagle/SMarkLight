#if os(iOS)
    import UIKit
#elseif os(OSX)
    import Cocoa
#endif

public class SMarkParser {
    
    enum Event: String { case themeChange = "themeChange" }
    
//    private let sQueue = NSOperationQueue()
//    private let cQueue = dispatch_queue_create("com.SelftStudio.SMarkEditor.Light.CONCURRENT", DISPATCH_QUEUE_CONCURRENT)
    
    public var theme: SMarkStyle = SMarkStyle.List.tomorrow.value! {
        didSet{
            NSNotificationCenter.defaultCenter().postNotificationName(Event.themeChange.rawValue, object: nil)
        }
    }
    /**
     Quote indentation in points. Default 20.
     */
    public var quoteIndendation: CGFloat = 20
    
    
    // Transform the quote indentation in the `NSParagraphStyle` required to set
    // the attribute on the `NSAttributedString`.
    private var quoteIndendationStyle: NSParagraphStyle {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.headIndent = quoteIndendation
        return paragraphStyle
    }

    
    enum RegElement: String {
        case setext = "setext", atx = "atx", qouteLines = "qouteLines", qouteOpener = "qouteOpener", code = "code", codeBlock = "codeBlock", codeSpanInLine = "codeSpanInLine", listMaker = "listMaker", listLines = "listLines", imagePattern = "imagePattern", imageRef = "imageRef", refURL = "refURL", refNote = "refNote", bold = "bold", italic = "italic"
        
        func match(in storage: NSTextStorage, text markdown: String, offset: Int = 0) {
            guard let regex = SMarkParser.shared.regexMap[self] else { return }
            let range = NSMakeRange(0, markdown.characters.count)
            var op: [NSMatchingOptions] = []
            
            let results = regex.matchesInString(markdown, options: [], range: range)
            func enlight(r: NSRange) {
                let mainThread = NSThread.isMainThread()
                func doLight() { light(in: storage, range: r) }
                if mainThread { doLight() }
                else { dispatch_async(dispatch_get_main_queue(), { self.light(in: storage, range: r) }) }
            }
            var openCode = false
            var codeStart = 0
            for res in results {
                var r = res.range
                r.location += offset
                let s = (markdown as NSString).substringWithRange(res.range)
                if self == .qouteLines {
                    RegElement.qouteOpener.match(in: storage, text: s, offset: r.location)
                } else if self == .listLines {
                    RegElement.listMaker.match(in: storage, text: s, offset: r.location)
                } else if self == .codeBlock {
                    if s.hasPrefix("```") {
                        if openCode {
                            let length = NSMaxRange(r) - codeStart
                            let codeRange = NSMakeRange(codeStart, length)
                            enlight(codeRange)
                            openCode = false
                        } else {
                            codeStart = r.location
                            openCode = true
                        }
                    } else if s.hasPrefix("``") {
                        enlight(r)
                    } else if s.hasPrefix("`") {
                        RegElement.codeSpanInLine.match(in: storage, text: s, offset: r.location)
                    }
                } else {
                    enlight(r)
                }
            }
        }
        
        private func light(in storage: NSTextStorage, range: NSRange) {
            let theme = SMarkParser.shared.theme
            let themeFont = theme.font
            let codeFont = theme.items[.code]?.font ?? themeFont
            let quoteFont = theme.items[.blockquote]?.font ?? themeFont
            let titleFont = theme.items[.h1]?.font ?? themeFont
            let boldFont = theme.items[.strong]?.font ?? themeFont
            let italicFont = theme.items[.emph]?.font ?? themeFont
            let commentFont = theme.items[.comment]?.font ?? themeFont
            let linkFont = theme.items[.link]?.font ?? themeFont
            let refFont = theme.items[.reference]?.font ?? themeFont
            let noteFont = theme.items[.note]?.font ?? themeFont
            let imageFont = theme.items[.image]?.font ?? themeFont
            let deleteFont = commentFont
            
            let themeColor = theme.foregroundColor!
            let codeColor = theme.items[.code]?.foregroundColor ?? themeColor
            let quoteColor = theme.items[.blockquote]?.foregroundColor ?? themeColor
            let titleColor = theme.items[.h1]?.foregroundColor ?? themeColor
            let boldColor = theme.items[.strong]?.foregroundColor ?? themeColor
            let italicColor = theme.items[.emph]?.foregroundColor ?? themeColor
            let linkColor = theme.items[.link]?.foregroundColor ?? themeColor
            let refColor = theme.items[.reference]?.foregroundColor ?? themeColor
            let noteColor = theme.items[.note]?.foregroundColor ?? themeColor
            let imageColor = theme.items[.image]?.foregroundColor ?? themeColor
            let listColor = theme.items[.listBullet]?.foregroundColor ?? themeColor
            let commentColor = theme.items[.comment]?.foregroundColor ?? themeColor
            let deleteColor = commentColor
            
            func rangeWithoutQuote(of range: NSRange) -> NSRange {
                var range = range
                let a = storage.string as NSString
                var sub = a.substringWithRange(range)
                var newlineOffset = 0
                repeat {
                    if sub.hasPrefix("\n") {
                        newlineOffset += 1
                        sub = (sub as NSString).substringWithRange(NSMakeRange(1, sub.characters.count - 1))
                    }
                } while (sub.hasPrefix("\n"))
                if sub.hasPrefix(">") {
                    range.location += 1
                    range.length -= 1
                }
                range.location += newlineOffset
                range.length -= newlineOffset
                return range
            }
            
            func headerLightUpWithoutQuote(at range: NSRange) {
                let a = storage.string as NSString
                let raw = a.substringWithRange(range) as NSString
                let array = raw.componentsSeparatedByString(">")
                for sub in array {
                    var r = raw.rangeOfString(sub)
                    if r.location == NSNotFound { continue }
                    r.location += range.location
                    storage.addAttribute(NSFontAttributeName, value: titleFont, range: r)
                    storage.addAttribute(NSForegroundColorAttributeName, value: titleColor, range: r)
                }
            }
            
            func code(at range: NSRange) {
                var r = range
                storage.addAttribute(NSFontAttributeName, value: codeFont, range: r)
                storage.addAttribute(NSForegroundColorAttributeName, value: codeColor, range: r)
                var sub = (storage.string as NSString).substringWithRange(r)
                var newlineOffset = 0
                repeat {
                    if sub.hasPrefix("\n") {
                        newlineOffset += 1
                        sub = (sub as NSString).substringWithRange(NSMakeRange(1, sub.characters.count - 1))
                    }
                } while (sub.hasPrefix("\n"))
                r.location += newlineOffset
                r.length -= newlineOffset
                let triple = "```"
                let double = "``"
                var count = 1
                if sub.hasPrefix(triple) { count = 3 }
                else if sub.hasPrefix(double) { count = 2 }
                let prefixRange = NSMakeRange(r.location, count)
                let subfixRange = NSMakeRange(r.location + r.length - count, count)
                storage.addAttribute(NSForegroundColorAttributeName, value: italicColor, range: prefixRange)
                storage.addAttribute(NSForegroundColorAttributeName, value: italicColor, range: subfixRange)
            }
            
            func colorImage(at range: NSRange) {
                storage.addAttribute(NSFontAttributeName, value: imageFont, range: range)
                storage.addAttribute(NSForegroundColorAttributeName, value: imageColor, range: range)
            }
            func colorRef(at range: NSRange) {
                storage.addAttribute(NSFontAttributeName, value: refFont, range: range)
                storage.addAttribute(NSForegroundColorAttributeName, value: refColor, range: range)
            }
            func colorNote(at range: NSRange) {
                storage.addAttribute(NSFontAttributeName, value: linkFont, range: range)
                storage.addAttribute(NSForegroundColorAttributeName, value: linkColor, range: range)
            }
            func colorBold(at range: NSRange) {
                storage.addAttribute(NSFontAttributeName, value: boldFont, range: range)
                storage.addAttribute(NSForegroundColorAttributeName, value: boldColor, range: range)
            }
            func colorItalic(at range: NSRange) {
                storage.addAttribute(NSFontAttributeName, value: italicFont, range: range)
                storage.addAttribute(NSForegroundColorAttributeName, value: italicColor, range: range)
            }
            switch self{
            case .qouteOpener: storage.addAttribute(NSForegroundColorAttributeName, value: quoteColor, range: range)
            case .listMaker: storage.addAttribute(NSForegroundColorAttributeName, value: listColor, range: rangeWithoutQuote(of: range))
            case .setext, .atx: headerLightUpWithoutQuote(at: range)
            case .codeSpanInLine, .codeBlock: code(at: range)
            case .imagePattern, .imageRef: colorImage(at: range)
            case .refURL: colorRef(at: range)
            case .refNote: colorNote(at: range)
            case .bold: colorBold(at: range)
            case .italic: colorItalic(at: range)
            default: break
            }
        }
    }
    
    public static var shared = SMarkParser()
    private var setext: NSRegularExpression? { return regexMap[.setext] }
    private var atx: NSRegularExpression? { return regexMap[.atx] }
    private var qouteLines: NSRegularExpression? { return regexMap[.qouteLines] }
    private var qouteOpener: NSRegularExpression? { return regexMap[.qouteOpener] }
    private var code: NSRegularExpression? { return regexMap[.code] }
    private var regexMap: [RegElement : NSRegularExpression] = [:]
    private init() {
        guard let file = NSBundle(forClass:SMarkParser.self).pathForResource("Regex", ofType: "json") else { return }
        do {
            guard let data = NSData(contentsOfFile: file) else { return }
            guard let content = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments) as?  [String : String] else { return }
            content.keys.forEach({ if let value = RegElement(rawValue: $0) { regexMap[value] = content[$0]?.regex } })
        } catch { }
        
    }
    
    public func codeBlockRange(of text: String) -> [NSRange] {
        guard let regex = regexMap[.codeBlock] else { return [] }
        let range = NSMakeRange(0, text.characters.count)
        let results = regex.matchesInString(text, options: [], range: range).flatMap { $0.range }
        var openCode = false
        var codeStart = 0
        var ranges = [NSRange]()
        for range in results {
            let r = range
            let s = (text as NSString).substringWithRange(r)
            if s.hasPrefix("```") {
                if openCode {
                    let length = NSMaxRange(r) - codeStart
                    let codeRange = NSMakeRange(codeStart, length)
                    ranges.append(codeRange)
                    openCode = false
                } else {
                    codeStart = r.location
                    openCode = true
                }
            } else if s.hasPrefix("``") {
                ranges.append(r)
            } else if s.hasPrefix("`") {
                guard let codeRangeInLine = regexMap[.codeSpanInLine]?.matchesInString(s, options: [], range: NSMakeRange(0, s.characters.count)).flatMap({ $0.range }) else { continue }
                ranges.appendContentsOf(codeRangeInLine)
            }
        }
        return ranges
    }
    
    public func parse(within textStorage: NSTextStorage, in range: NSRange? = nil, async: Bool = true) {
        
        let markdown = textStorage.string
        let currentRange = range ?? NSMakeRange(0, markdown.characters.count)
        let currentText = (markdown as NSString).substringWithRange(currentRange)
        if currentText.isEmpty { return }
        textStorage.beginEditing()
//        print("😆：\(currentText)")
        let themeFont = theme.font
        let themeColor = theme.foregroundColor!
        textStorage.addAttribute(NSFontAttributeName, value: themeFont, range: currentRange)
        textStorage.addAttribute(NSForegroundColorAttributeName, value: themeColor, range: currentRange)
        let sequence: [RegElement] = [.qouteLines, .listLines, .setext, .atx, .bold, .italic, .codeBlock, .imagePattern, .imageRef, .refNote, .refURL]
        func go() {
            for type in sequence {
                type.match(in: textStorage, text: currentText, offset: currentRange.location)
            }
        }
        if async { dispatch_async(dispatch_get_main_queue(), { go() }) } else { go() }
       textStorage.endEditing()
    }
    
}
private func printSub(str text: String, of range: NSRange) {
    print((text as NSString).substringWithRange(range))
}

extension String {
    var regex: NSRegularExpression? {
        do { return try NSRegularExpression(pattern: self, options: []) } catch { return nil }
    }
}
extension NSRegularExpression {
    // MARK: - setextTitle
    func match(within markdown: String, offset: Int = 0, completion: (range: NSRange) -> Void){
            let r = NSMakeRange(0, markdown.characters.count)
            self.enumerateMatchesInString(markdown, options: [], range: r) { (resp) in
                if var r = resp.0?.range {
                    r.location += offset
                    completion(range: r)
                }
            }
    }
}