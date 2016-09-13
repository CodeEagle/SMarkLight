#if os(iOS)
    import UIKit
#elseif os(OSX)
    import Cocoa
#endif

public class SMarkParser {
    
    enum RegElement: String {
        case setext = "setext", atx = "atx", qouteLines = "qouteLines", qouteOpener = "qouteOpener"
    }
    
    public static var shared = SMarkParser()
    private var setext: NSRegularExpression? { return regexMap[.setext] }
    private var atx: NSRegularExpression? { return regexMap[.atx] }
    private var qouteLines: NSRegularExpression? { return regexMap[.qouteLines] }
    private var qouteOpener: NSRegularExpression? { return regexMap[.qouteOpener] }
    private var regexMap: [RegElement : NSRegularExpression] = [:]
    private init() {
        guard let file = NSBundle.mainBundle().pathForResource("Regex", ofType: "json") else { return }
        do {
            guard let data = NSData(contentsOfFile: file) else { return }
            guard let content = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments) as?  [String : String] else { return }
            content.keys.forEach({ if let value = RegElement(rawValue: $0) { regexMap[value] = content[$0]?.regex } })
        } catch { }
        
    }
    
    public func parse(within markdown: String, in range: NSRange? = nil) {
        
        let r = range ?? NSMakeRange(0, markdown.characters.count)
        let sub = (markdown as NSString).substringWithRange(r)
        
        qouteLines?.match(within: markdown, completion: {[weak self] (result) in
            let s = (markdown as NSString).substringWithRange(result)
            self?.qouteOpener?.match(within: s, completion: { (r2) in
                let ss = (s as NSString).substringWithRange(r2)
            })
        })
        setext?.match(within: markdown, completion: { (result) in
             printSub(str: markdown, of: result)
        })
        atx?.match(within: markdown, completion: { (result) in
            printSub(str: markdown, of: result)
        })
        
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
    func match(within markdown: String, completion: (result: NSRange) -> Void){
        let r = NSMakeRange(0, markdown.characters.count)
        enumerateMatchesInString(markdown, options: [], range: r) { (resp) in
            if let r = resp.0?.range { completion(result: r) }
        }
    }
}