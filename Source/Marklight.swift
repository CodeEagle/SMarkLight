// Marklight
//    Copyright (c) 2016 Matteo Gavagnin
//
import Foundation

#if os(iOS)
	import UIKit
#elseif os(OSX)
	import Cocoa
#endif

public struct Marklight {
    
    enum Event: String { case themeChange = "themeChange" }
    
    public static var theme: SMarkStyle = SMarkStyle.List.tomorrowPlus.value! {
        didSet{
            NSNotificationCenter.defaultCenter().postNotificationName(Event.themeChange.rawValue, object: nil)
        }
    }

	/**
    Quote indentation in points. Default 20.
     */
	public static var quoteIndendation: CGFloat = 20


	// Transform the quote indentation in the `NSParagraphStyle` required to set
	// the attribute on the `NSAttributedString`.
	private static var quoteIndendationStyle: NSParagraphStyle {
		let paragraphStyle = NSMutableParagraphStyle()
		paragraphStyle.headIndent = Marklight.quoteIndendation
		return paragraphStyle
	}

	// MARK: Processing

	/**
    This function should be called by the `-processEditing` method in your 
        `NSTextStorage` subclass and this is the function that is being called 
        for every change in the `UITextView`'s text.

    - parameter textStorage: your `NSTextStorage` subclass as the highlights
        will be applied to its attributed string through the `-addAttribute:value:range:` method.
    */
	public static func processEditing(textStorage: NSTextStorage, with range: NSRange? = nil) {
        textStorage.beginEditing()
		let wholeRange = range ?? NSMakeRange(0, (textStorage.string as NSString).length)
		let currentText = (textStorage.string as NSString).substringWithRange(wholeRange)
		let paragraphRange = (textStorage.string as NSString).paragraphRangeForRange(wholeRange)
		textStorage.removeAttribute(NSStrikethroughStyleAttributeName, range: wholeRange)
		let themeFont = theme.font
		let codeFont = theme.items[.code]?.font ?? themeFont
		let quoteFont = theme.items[.blockquote]?.font ?? themeFont
		let titleFont = theme.items[.h1]?.font ?? themeFont
		let boldFont = theme.items[.strong]?.font ?? themeFont
		let italicFont = theme.items[.emph]?.font ?? themeFont
		let commentFont = theme.items[.comment]?.font ?? themeFont
		let linkFont = theme.items[.link]?.font ?? themeFont
		let refFont = theme.items[.reference]?.font ?? themeFont
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
		let imageColor = theme.items[.image]?.foregroundColor ?? themeColor
		let listColor = theme.items[.listBullet]?.foregroundColor ?? themeColor
		let commentColor = theme.items[.comment]?.foregroundColor ?? themeColor
		let deleteColor = commentColor

		textStorage.addAttribute(NSFontAttributeName, value: themeFont, range: wholeRange)
		textStorage.addAttribute(NSForegroundColorAttributeName, value: themeColor, range: wholeRange)
		func rangeWithoutQuote(of range: NSRange) -> NSRange {
			var range = range
			let a = textStorage.string as NSString
			let sub = a.substringWithRange(range)
			if sub.hasPrefix(">") {
				range.location += 1
				range.length -= 1
			}
			return range
		}

		func headerLightUpWithoutQuote(at range: NSRange) {
			let a = textStorage.string as NSString
			let raw = a.substringWithRange(range) as NSString
			let array = raw.componentsSeparatedByString(">")
			for sub in array {
				var r = raw.rangeOfString(sub)
				if r.location == NSNotFound { continue }
				r.location += range.location
				textStorage.addAttribute(NSFontAttributeName, value: titleFont, range: r)
				textStorage.addAttribute(NSForegroundColorAttributeName, value: titleColor, range: r)
			}
		}

		// We detect and process quotes
		Marklight.blockQuoteRegex.matches(textStorage.string, range: wholeRange) { (result) -> Void in
			textStorage.addAttribute(NSFontAttributeName, value: quoteFont, range: result!.range)
			textStorage.addAttribute(NSParagraphStyleAttributeName, value: quoteIndendationStyle, range: result!.range)
			Marklight.blockQuoteOpeningRegex.matches(textStorage.string, range: paragraphRange) { (innerResult) -> Void in
				textStorage.addAttribute(NSForegroundColorAttributeName, value: quoteColor, range: innerResult!.range)
			}
		}
        
        // We detect and process underlined headers
        
        Marklight.headersSetexRegex.matches(textStorage.string, range: wholeRange) { (result) -> Void in
            headerLightUpWithoutQuote(at: result!.range)
            Marklight.headersSetexUnderlineRegex.matches(textStorage.string, range: paragraphRange) { (innerResult) -> Void in
                let realRange = rangeWithoutQuote(of: innerResult!.range)
                textStorage.addAttribute(NSForegroundColorAttributeName, value: titleColor, range: realRange)
            }
        }
        

        // We detect and process dashed headers
        if currentText.containsString("#") {
            let h: [SMarkStyleItemType] = [.h1,.h2,.h3,.h4,.h5,.h6]
            for i in 1...6 {
                let hTag = h[i-1]
                let item = theme.items[hTag]
                let font = item?.font ?? titleFont
                let color = item?.foregroundColor ?? titleColor
                let regex = headerAtxRegex(at: i)
                regex.matches(textStorage.string, range: paragraphRange) { (result) -> Void in
                    let realRange = rangeWithoutQuote(of: result!.range)
                    textStorage.addAttribute(NSFontAttributeName, value: font, range: realRange)
                    textStorage.addAttribute(NSForegroundColorAttributeName, value: color, range: realRange)
//                    print(realRange)
//                    regex.1.matches(textStorage.string, range: realRange) { (innerResult) -> Void in
//                        let realRange = rangeWithoutQuote(of: innerResult!.range)
//                        textStorage.addAttribute(NSForegroundColorAttributeName, value: color, range: realRange)
//                    }
//                    regex.2.matches(textStorage.string, range: realRange) { (innerResult) -> Void in
//                        let realRange = rangeWithoutQuote(of: innerResult!.range)
//                        textStorage.addAttribute(NSForegroundColorAttributeName, value: color, range: realRange)
//                    }
                }
            }
        }

		// We detect and process links
		Marklight.linkRegex.matches(textStorage.string, range: wholeRange) { (result) -> Void in
			textStorage.addAttribute(NSForegroundColorAttributeName, value: linkColor, range: result!.range)
		}
		// We detect and process reference links
		Marklight.referenceLinkRegex.matches(textStorage.string, range: wholeRange) { (result) -> Void in
			textStorage.addAttribute(NSFontAttributeName, value: refFont, range: result!.range)
			textStorage.addAttribute(NSForegroundColorAttributeName, value: refColor, range: result!.range)
		}

		// We detect and process lists
		Marklight.listRegex.matches(textStorage.string, range: wholeRange) { (result) -> Void in
            let sub = (textStorage.string as NSString).substringWithRange(result!.range)
            let subRange = NSMakeRange(result!.range.location, sub.characters.count)
			Marklight.listOpeningRegex.matches(textStorage.string, range: subRange) { (innerResult) -> Void in
//                let sb = (textStorage.string as NSString).substringWithRange(innerResult!.range)
				let r = rangeWithoutQuote(of: innerResult!.range)
				textStorage.addAttribute(NSForegroundColorAttributeName, value: listColor, range: r)
			}
		}

		// We detect and process anchors (links)
		Marklight.anchorRegex.matches(textStorage.string, range: paragraphRange) { (result) -> Void in
			let r = result!.range
			textStorage.addAttribute(NSFontAttributeName, value: linkFont, range: r)
			textStorage.addAttribute(NSForegroundColorAttributeName, value: linkColor, range: r)
			let sub = (textStorage.string as NSString).substringWithRange(r)
			let subRange = NSMakeRange(0, sub.characters.count)
			Marklight.openingSquareRegex.matches(sub, range: subRange) { (innerResult) -> Void in
				var sr = innerResult!.range
				sr.location += r.location
				textStorage.addAttribute(NSForegroundColorAttributeName, value: linkColor, range: sr)
			}
			Marklight.closingSquareRegex.matches(sub, range: subRange) { (innerResult) -> Void in
				var sr = innerResult!.range
				sr.location += r.location
				textStorage.addAttribute(NSForegroundColorAttributeName, value: linkColor, range: sr)
			}
			Marklight.parenRegex.matches(textStorage.string, range: result!.range) { (innerResult) -> Void in
				textStorage.addAttribute(NSForegroundColorAttributeName, value: linkColor, range: innerResult!.range)
			}
		}

		// We detect and process inline anchors (links)
		Marklight.anchorInlineRegex.matches(textStorage.string, range: paragraphRange) { (result) -> Void in
			let r = result!.range
			textStorage.addAttribute(NSFontAttributeName, value: linkFont, range: r)
			textStorage.addAttribute(NSForegroundColorAttributeName, value: linkColor, range: r)
			let sub = (textStorage.string as NSString).substringWithRange(r)
			let subRange = NSMakeRange(0, sub.characters.count)
			Marklight.openingSquareRegex.matches(sub, range: subRange) { (innerResult) -> Void in
				var sr = innerResult!.range
				sr.location += r.location
				textStorage.addAttribute(NSForegroundColorAttributeName, value: linkColor, range: sr)
			}
			Marklight.closingSquareRegex.matches(sub, range: subRange) { (innerResult) -> Void in
				var sr = innerResult!.range
				sr.location += r.location
				textStorage.addAttribute(NSForegroundColorAttributeName, value: linkColor, range: sr)
			}
			Marklight.parenRegex.matches(textStorage.string, range: result!.range) { (innerResult) -> Void in
				textStorage.addAttribute(NSForegroundColorAttributeName, value: linkColor, range: innerResult!.range)
			}
		}

		// image tag
		Marklight.imageTagRegex.matches(textStorage.string, range: wholeRange) { (result) -> Void in
			textStorage.addAttribute(NSFontAttributeName, value: imageFont, range: result!.range)
			textStorage.addAttribute(NSForegroundColorAttributeName, value: imageColor, range: result!.range)
		}

		Marklight.imageRegex.matches(textStorage.string, range: paragraphRange) { (result) -> Void in
			let r = result!.range
			textStorage.addAttribute(NSFontAttributeName, value: imageFont, range: r)
			textStorage.addAttribute(NSForegroundColorAttributeName, value: imageColor, range: r)
//			let sub = (textStorage.string as NSString).substringWithRange(r)
//			let subRange = NSMakeRange(0, sub.characters.count)
//
//			Marklight.imageOpeningSquareRegex.matches(sub, range: subRange) { (innerResult) -> Void in
//				var sr = innerResult!.range
//				sr.location += r.location
//				textStorage.addAttribute(NSForegroundColorAttributeName, value: imageColor, range: sr)
//			}
//			Marklight.imageClosingSquareRegex.matches(sub, range: subRange) { (innerResult) -> Void in
//				var sr = innerResult!.range
//				sr.location += r.location
//				textStorage.addAttribute(NSForegroundColorAttributeName, value: imageColor, range: sr)
//			}

		}

		// We detect and process inline images
		Marklight.imageInlineRegex.matches(textStorage.string, range: paragraphRange) { (result) -> Void in
			let r = result!.range
			textStorage.addAttribute(NSFontAttributeName, value: imageFont, range: r)
			let sub = (textStorage.string as NSString).substringWithRange(r)
			let subRange = NSMakeRange(0, sub.characters.count)
			Marklight.imageOpeningSquareRegex.matches(sub, range: subRange) { (innerResult) -> Void in
				var sr = innerResult!.range
				sr.location += r.location
				textStorage.addAttribute(NSForegroundColorAttributeName, value: imageColor, range: sr)
			}
			Marklight.imageClosingSquareRegex.matches(sub, range: subRange) { (innerResult) -> Void in
				var sr = innerResult!.range
				sr.location += r.location
				textStorage.addAttribute(NSForegroundColorAttributeName, value: imageColor, range: sr)
			}
			Marklight.parenRegex.matches(textStorage.string, range: result!.range) { (innerResult) -> Void in
				textStorage.addAttribute(NSForegroundColorAttributeName, value: imageColor, range: innerResult!.range)
			}
		}

		// We detect and process inline code
		Marklight.codeSpanRegex.matches(textStorage.string, range: wholeRange) { (result) -> Void in
			textStorage.addAttribute(NSFontAttributeName, value: codeFont, range: result!.range)
			textStorage.addAttribute(NSForegroundColorAttributeName, value: codeColor, range: result!.range)
			Marklight.codeSpanOpeningRegex.matches(textStorage.string, range: paragraphRange) { (innerResult) -> Void in
				textStorage.addAttribute(NSForegroundColorAttributeName, value: themeColor, range: innerResult!.range)
			}
			Marklight.codeSpanClosingRegex.matches(textStorage.string, range: paragraphRange) { (innerResult) -> Void in
				textStorage.addAttribute(NSForegroundColorAttributeName, value: themeColor, range: innerResult!.range)
			}
		}

		// We detect and process code blocks
		Marklight.codeBlockRegex.matches(textStorage.string, range: wholeRange) { (result) -> Void in
			textStorage.addAttribute(NSFontAttributeName, value: codeFont, range: result!.range)
			textStorage.addAttribute(NSForegroundColorAttributeName, value: codeColor, range: result!.range)
		}

//		// We detect and process quotes
//		Marklight.blockQuoteRegex.matches(textStorage.string, range: wholeRange) { (result) -> Void in
//			textStorage.addAttribute(NSFontAttributeName, value: quoteFont, range: result!.range)
//			textStorage.addAttribute(NSForegroundColorAttributeName, value: quoteColor, range: result!.range)
//			textStorage.addAttribute(NSParagraphStyleAttributeName, value: quoteIndendationStyle, range: result!.range)
//			Marklight.blockQuoteOpeningRegex.matches(textStorage.string, range: paragraphRange) { (innerResult) -> Void in
//				textStorage.addAttribute(NSForegroundColorAttributeName, value: quoteColor, range: innerResult!.range)
//			}
//		}

		// We detect and process strict italics
		Marklight.strictItalicRegex.matches(textStorage.string, range: paragraphRange) { (result) -> Void in
			textStorage.addAttribute(NSFontAttributeName, value: italicFont, range: result!.range)
			textStorage.addAttribute(NSForegroundColorAttributeName, value: italicColor, range: result!.range)
//			textStorage.addAttribute(NSForegroundColorAttributeName, value: italicColor, range: NSMakeRange(result!.range.location, 1))
//			textStorage.addAttribute(NSForegroundColorAttributeName, value: italicColor, range: NSMakeRange(result!.range.location + result!.range.length - 1, 1))
		}

		// We detect and process italics
//		Marklight.italicRegex.matches(textStorage.string, range: paragraphRange) { (result) -> Void in
//			textStorage.addAttribute(NSFontAttributeName, value: italicFont, range: result!.range)
//			textStorage.addAttribute(NSForegroundColorAttributeName, value: italicColor, range: result!.range)
////			textStorage.addAttribute(NSForegroundColorAttributeName, value: italicColor, range: NSMakeRange(result!.range.location, 1))
////			textStorage.addAttribute(NSForegroundColorAttributeName, value: italicColor, range: NSMakeRange(result!.range.location + result!.range.length - 1, 1))
//		}

		// We detect and process strict bolds
		Marklight.strictBoldRegex.matches(textStorage.string, range: paragraphRange) { (result) -> Void in
			textStorage.addAttribute(NSFontAttributeName, value: boldFont, range: result!.range)
			textStorage.addAttribute(NSForegroundColorAttributeName, value: boldColor, range: NSMakeRange(result!.range.location, 2))
			textStorage.addAttribute(NSForegroundColorAttributeName, value: boldColor, range: NSMakeRange(result!.range.location + result!.range.length - 2, 2))
		}

		// We detect and process bolds
		Marklight.boldRegex.matches(textStorage.string, range: paragraphRange) { (result) -> Void in
			textStorage.addAttribute(NSFontAttributeName, value: boldFont, range: result!.range)
			textStorage.addAttribute(NSForegroundColorAttributeName, value: boldColor, range: result!.range)
			textStorage.addAttribute(NSForegroundColorAttributeName, value: boldColor, range: NSMakeRange(result!.range.location, 2))
			textStorage.addAttribute(NSForegroundColorAttributeName, value: boldColor, range: NSMakeRange(result!.range.location + result!.range.length - 2, 2))
		}

		// We detect and process comment
		Marklight.commentRegex.matches(textStorage.string, range: paragraphRange) { (result) -> Void in
			textStorage.addAttribute(NSFontAttributeName, value: commentFont, range: result!.range)
			textStorage.addAttribute(NSForegroundColorAttributeName, value: commentColor, range: result!.range)
		}

		// We detect and process comment
		Marklight.deleteRegex.matches(textStorage.string, range: paragraphRange) { (result) -> Void in
			textStorage.addAttribute(NSFontAttributeName, value: deleteFont, range: result!.range)
			textStorage.addAttribute(NSForegroundColorAttributeName, value: deleteColor, range: result!.range)
			textStorage.addAttribute(NSStrikethroughStyleAttributeName, value: NSUnderlineStyle.StyleSingle.rawValue, range: result!.range)
		}
        textStorage.endEditing()
	}

	/// Tabs are automatically converted to spaces as part of the transform
	/// this constant determines how "wide" those tabs become in spaces
	private static let _tabWidth = 4

	// MARK: Headers

	/*
	 Head
	 ======

	 Subhead
	 -------
	 */

	private static let headerSetexPattern = [
		"^(.+?)",
		"\\p{Z}*",
		"\\n",
		"(>?)(\\s?)(=+|-+)     # $1 = string of ='s or -'s",
		"\\p{Z}*",
		"\\n+"
	].joinWithSeparator("\n")

	private static let headersSetexRegex = Regex(pattern: headerSetexPattern, options: [.AllowCommentsAndWhitespace, .AnchorsMatchLines])

	private static let setexUnderlinePattern = [
		"(>?)(\\s?)(=+|-+)     # $1 = string of ='s or -'s",
		"\\p{Z}*",
		"\\n+"
	].joinWithSeparator("\n")

	private static let headersSetexUnderlineRegex = Regex(pattern: setexUnderlinePattern, options: [.AllowCommentsAndWhitespace])

	/*
	 # Head

	 ## Subhead ##
	 */
    private static var headerAtxRegexMap: [Int : Regex] = [:]

    private static func headerAtxRegex(at level: Int) ->Regex {
        if let cache = headerAtxRegexMap[level] { return cache }
        let headerAtxPattern = [
            "^(>?)(\\s?)(\\#{\(level)})  # $1 = string of #'s",
            "\\p{Z}*",
            "(.*)        # $2 = Header text",
            "\\p{Z}*",
            "\\#*         # optional closing #'s (not counted)",
            "\\n*"
            ].joinWithSeparator("\n")
        
        let headersAtxRegex = Regex(pattern: headerAtxPattern, options: [.AllowCommentsAndWhitespace, .AnchorsMatchLines])
        
//        let headersAtxOpeningPattern = [
//            "^(\\#{\(level)})"
//            ].joinWithSeparator("\n")
//        
//        let headersAtxOpeningRegex = Regex(pattern: headersAtxOpeningPattern, options: [.AllowCommentsAndWhitespace, .AnchorsMatchLines])
//        
//        let headersAtxClosingPattern = [
//            "\\#{\(level)}\\n+"
//            ].joinWithSeparator("\n")
//        
//        let headersAtxClosingRegex = Regex(pattern: headersAtxClosingPattern, options: [.AllowCommentsAndWhitespace, .AnchorsMatchLines])
        
        Marklight.headerAtxRegexMap[level] = headersAtxRegex
        return headersAtxRegex
    }
    
	// MARK: Reference links

	/*
	 ???
	 */

	private static let referenceLinkPattern = [
		"^\\p{Z}{0,\(_tabWidth - 1)}\\[([^\\[\\]]+)\\]:  # id = $1",
		"  \\p{Z}*",
		"  \\n?                   # maybe *one* newline",
		"  \\p{Z}*",
		"<?(\\S+?)>?              # url = $2",
		"  \\p{Z}*",
		"  \\n?                   # maybe one newline",
		"  \\p{Z}*",
		"(?:",
		"    (?<=\\s)             # lookbehind for whitespace",
		"    [\"(]",
		"    (.+?)                # title = $3",
		"    [\")]",
		"    \\p{Z}*",
		")?                       # title is optional",
		"(?:\\n+|\\Z)"
	].joinWithSeparator("\n")

	private static let referenceLinkRegex = Regex(pattern: referenceLinkPattern, options: [.AllowCommentsAndWhitespace, .AnchorsMatchLines])

	// MARK: Lists

	/*
	 * First element
	 * Second element
	 */

	private static let _markerUL = "[*+-]"
	private static let _markerOL = "(\\n*|\\s+)\\d+[.]"

	private static let _listMarker = "(?m)^((\\n*(>?\\s?)\\*)|((\\n*(>?\\s?)|\\s+)\\d+[.]))"//"(>?\\s?)(?:\(_markerUL)|\(_markerOL))"
	private static let _wholeList = [
		"(                               # $1 = whole list",
		"  (                             # $2",
		"    \\p{Z}{0,\(_tabWidth - 1)}",
		"    (\(_listMarker))            # $3 = first list item marker",
		"    \\p{Z}+",
		"  )",
		"  (?s:.+?)",
		"  (                             # $4",
		"      \\z",
		"    |",
		"      \\n{2,}",
		"      (?=\\S)",
		"      (?!                       # Negative lookahead for another list item marker",
		"        \\p{Z}*",
		"        \(_listMarker)\\p{Z}+",
		"      )",
		"  )",
		")"
	].joinWithSeparator("\n")

    //"(?:(?<=\\n\\n)|(\\A(.*)\\n*)*)"
	private static let listPattern = "(?:(?<=\\n\\n)|(\\A(.*)\\n*)*)" + _wholeList

	private static let listRegex = Regex(pattern: listPattern, options: [.AllowCommentsAndWhitespace, .AnchorsMatchLines])
	private static let listOpeningRegex = Regex(pattern: _listMarker, options: [.AllowCommentsAndWhitespace, .AnchorsMatchLines])

	// MARK: - Anchors

	/*
	 < http://example.com >
	 */
	private static let linkPattern = "<(\\s*)(?i)(ftp|https?)://(?:www\\.)?\\S+(?:/|\\b)(\\s*)>"
	private static let linkRegex = Regex(pattern: linkPattern, options: [.AllowCommentsAndWhitespace, .DotMatchesLineSeparators])
	/*
	 [Title](http://example.com)
	 */

//	private static let anchorPattern = [
//		"(                               # wrap whole match in $1",
//		"    \\[",
//		"        (\(Marklight.getNestedBracketsPattern()))  # link text = $2",
//		"    \\]",
//		"",
//		"    \\p{Z}?                        # one optional space",
//		"    (?:\\n\\p{Z}*)?                # one optional newline followed by spaces",
//		"",
//		"    \\[",
//		"        (.*?)                   # id = $3",
//		"    \\]",
//		")"
//	].joinWithSeparator("\n")
	private static let anchorPattern = "\\b(\\[)\\B(.*)\\](\\()(.*)\\B(\\))"
	private static let anchorRegex = Regex(pattern: anchorPattern, options: [.AllowCommentsAndWhitespace, .DotMatchesLineSeparators])

	private static let opneningSquarePattern = [
		"(\\[)"
	].joinWithSeparator("\n")

	private static let openingSquareRegex = Regex(pattern: opneningSquarePattern, options: [.AllowCommentsAndWhitespace])

	private static let closingSquarePattern = [
		"\\]"
	].joinWithSeparator("\n")

	private static let closingSquareRegex = Regex(pattern: closingSquarePattern, options: [.AllowCommentsAndWhitespace])

	private static let parenPattern = [
		"(",
		"\\(                 # literal paren",
		"      \\p{Z}*",
		"      (\(Marklight.getNestedParensPattern()))    # href = $3",
		"      \\p{Z}*",
		"      (               # $4",
		"      (['\"])       # quote char = $5",
		"      (.*?)           # title = $6",
		"      \\5             # matching quote",
		"      \\p{Z}*",
		"      )?              # title is optional",
		"  \\)",
		")"
	].joinWithSeparator("\n")

	private static let parenRegex = Regex(pattern: parenPattern, options: [.AllowCommentsAndWhitespace])

	private static let anchorInlinePattern = [
		"(                           # wrap whole match in $1",
		"    \\[",
		"        (\(Marklight.getNestedBracketsPattern()))   # link text = $2",
		"    \\]",
		"    \\(                     # literal paren",
		"        \\p{Z}*",
		"        (\(Marklight.getNestedParensPattern()))   # href = $3",
		"        \\p{Z}*",
		"        (                   # $4",
		"        (['\"])           # quote char = $5",
		"        (.*?)               # title = $6",
		"        \\5                 # matching quote",
		"        \\p{Z}*                # ignore any spaces between closing quote and )",
		"        )?                  # title is optional",
		"    \\)",
		")"
	].joinWithSeparator("\n")

	private static let anchorInlineRegex = Regex(pattern: anchorInlinePattern, options: [.AllowCommentsAndWhitespace, .DotMatchesLineSeparators])

	// MARK: - Images

	/*
	 <img src="http://example.com" >
	 */
	private static let imageTagPattern = "<img\\s*(src=\"(.*)\")?\\s*/>"
	private static let imageTagRegex = Regex(pattern: imageTagPattern, options: [.AllowCommentsAndWhitespace, .DotMatchesLineSeparators])

	/*
	 ![Title](http://example.com/image.png)
	 */

	private static let imagePattern = [
		"(               # wrap whole match in $1",
		"!\\[",
		"    (.*?)       # alt text = $2",
		"\\]",
		"",
		"\\p{Z}?            # one optional space",
		"(?:\\n\\p{Z}*)?    # one optional newline followed by spaces",
		"",
		"\\[",
		"    (.*?)       # id = $3",
		"\\]",
		"",
		")"
	].joinWithSeparator("\n")

	private static let imageRegex = Regex(pattern: imagePattern, options: [.AllowCommentsAndWhitespace, .DotMatchesLineSeparators])

	private static let imageOpeningSquarePattern = [
		"(!\\[)"
	].joinWithSeparator("\n")

	private static let imageOpeningSquareRegex = Regex(pattern: imageOpeningSquarePattern, options: [.AllowCommentsAndWhitespace])

	private static let imageClosingSquarePattern = [
		"(\\])"
	].joinWithSeparator("\n")

	private static let imageClosingSquareRegex = Regex(pattern: imageClosingSquarePattern, options: [.AllowCommentsAndWhitespace])

	private static let imageInlinePattern = [
		"(                     # wrap whole match in $1",
		"  !\\[",
		"      (.*?)           # alt text = $2",
		"  \\]",
		"  \\s?                # one optional whitespace character",
		"  \\(                 # literal paren",
		"      \\p{Z}*",
		"      (\(Marklight.getNestedParensPattern()))    # href = $3",
		"      \\p{Z}*",
		"      (               # $4",
		"      (['\"])       # quote char = $5",
		"      (.*?)           # title = $6",
		"      \\5             # matching quote",
		"      \\p{Z}*",
		"      )?              # title is optional",
		"  \\)",
		")"
	].joinWithSeparator("\n")

	private static let imageInlineRegex = Regex(pattern: imageInlinePattern, options: [.AllowCommentsAndWhitespace, .DotMatchesLineSeparators])

	// MARK: Code

	/*
	 ```
	 Code
	 ```

	 Code
	 */

	private static let codeBlockPattern = [
		"(?:\\n\\n|\\A\\n?)",
		"(                        # $1 = the code block -- one or more lines, starting with a space",
		"(?:",
		"    (?:\\p{Z}{\(_tabWidth)})       # Lines must start with a tab-width of spaces",
		"    .*\\n+",
		")+",
		")",
		"((?=^\\p{Z}{0,\(_tabWidth)}[^ \\t\\n])|\\Z) # Lookahead for non-space at line-start, or end of doc"
	].joinWithSeparator("\n")

	private static let codeBlockRegex = Regex(pattern: codeBlockPattern, options: [.AllowCommentsAndWhitespace, .AnchorsMatchLines])

	private static let codeSpanPattern = [
		"(?<![\\\\`])   # Character before opening ` can't be a backslash or backtick",
		"(`+)           # $1 = Opening run of `",
		"(?!`)          # and no more backticks -- match the full run",
		"(.+?)          # $2 = The code block",
		"(?<!`)",
		"\\1",
		"(?!`)"
	].joinWithSeparator("\n")

	private static let codeSpanRegex = Regex(pattern: codeSpanPattern, options: [.AllowCommentsAndWhitespace, .DotMatchesLineSeparators])

	private static let codeSpanOpeningPattern = [
		"(?<![\\\\`])   # Character before opening ` can't be a backslash or backtick",
		"(>?)(`+)           # $1 = Opening run of `"
	].joinWithSeparator("\n")

	private static let codeSpanOpeningRegex = Regex(pattern: codeSpanOpeningPattern, options: [.AllowCommentsAndWhitespace, .DotMatchesLineSeparators])

	private static let codeSpanClosingPattern = [
		"(?<![\\\\`])   # Character before opening ` can't be a backslash or backtick",
		"(>?)(`+)           # $1 = Opening run of `"
	].joinWithSeparator("\n")

	private static let codeSpanClosingRegex = Regex(pattern: codeSpanClosingPattern, options: [.AllowCommentsAndWhitespace, .DotMatchesLineSeparators])

	// MARK: Block quotes

	/*
	 > Quoted text
	 */

	private static let blockQuotePattern = [
		"(                           # Wrap whole match in $1",
		"    (",
		"    ^\\p{Z}*>\\p{Z}?              # '>' at the start of a line",
		"        .+\\n               # rest of the first line",
		"    (.+\\n)*                # subsequent consecutive lines",
		"    \\n*                    # blanks",
		"    )+",
		")"
	].joinWithSeparator("\n")

	private static let blockQuoteRegex = Regex(pattern: blockQuotePattern, options: [.AllowCommentsAndWhitespace, .AnchorsMatchLines])

	private static let blockQuoteOpeningPattern = [
		"(^\\p{Z}*>\\p{Z})"
	].joinWithSeparator("\n")

	private static let blockQuoteOpeningRegex = Regex(pattern: blockQuoteOpeningPattern, options: [.AnchorsMatchLines])

	// MARK: Bold

	/*
	 **Bold**
	 __Bold__
	 */

	private static let strictBoldPattern = "(^|[\\W_])(?:(?!\\1)|(?=^))(\\*|_)\\2(?=\\S)(.*?\\S)\\2\\2(?!\\2)(?=[\\W_]|$)"

	private static let strictBoldRegex = Regex(pattern: strictBoldPattern, options: [.AnchorsMatchLines])

	private static let boldPattern = "(\\*\\*|__) (?=\\S) (.+?[*_]*) (?<=\\S) \\1"

	private static let boldRegex = Regex(pattern: boldPattern, options: [.AllowCommentsAndWhitespace, .AnchorsMatchLines])

	// MARK: Italic

	/*
	 *Italic*
	 _Italic_
	 */
	private static let strictItalicPattern = "(?u)(\\*\\b(?:(?!\\*).)*?\\b(\\!?)\\*)" // "(^|[\\W_])(?:(?!\\1)|(?=^))(\\*|_)(?=\\S)((?:(?!\\2).)*?\\S)\\2(?!\\2)(?=[\\W_]|$)" //

	private static let strictItalicRegex = Regex(pattern: strictItalicPattern, options: [.AnchorsMatchLines])

	private static let italicPattern = "(\\*|_) (?=\\S) (.+?) (?<=\\S) \\1"

	private static let italicRegex = Regex(pattern: italicPattern, options: [.AllowCommentsAndWhitespace, .AnchorsMatchLines])

	// MARK: - Comment

	/*
	 <!-- Comment -->
	 */

	private static let commentPattern = "<!--(.*?)-->"
	private static let commentRegex = Regex(pattern: commentPattern, options: [.AnchorsMatchLines])

	// MARK: - Delete
	/*
	 ~~ Delete ~~
	 */
	private static let deletePattern = "~~(.*?[^(~)*])~~"
	private static let deleteRegex = Regex(pattern: deletePattern, options: [.AnchorsMatchLines])
// MARK: - Regx
	private struct Regex {
		private let regularExpression: NSRegularExpression!

		private init(pattern: String, options: NSRegularExpressionOptions = NSRegularExpressionOptions(rawValue: 0)) {
			var error: NSError?
			let re: NSRegularExpression?
			do {
				re = try NSRegularExpression(pattern: pattern,
					options: options)
			} catch let error1 as NSError {
				error = error1
				re = nil
			}

			// If re is nil, it means NSRegularExpression didn't like
			// the pattern we gave it.  All regex patterns used by Markdown
			// should be valid, so this probably means that a pattern
			// valid for .NET Regex is not valid for NSRegularExpression.
			if re == nil {
				if let error = error {
					print("Regular expression error: \(error.userInfo)")
				}
				assert(re != nil)
			}

			self.regularExpression = re
		}

		private func matches(input: String, range: NSRange,
			completion: (result: NSTextCheckingResult?) -> Void) {
				let s = input as NSString
				let options = NSMatchingOptions(rawValue: 0)
				regularExpression.enumerateMatchesInString(s as String,
					options: options,
					range: range,
					usingBlock: { (result, flags, stop) -> Void in
						completion(result: result)
				})
		}
	}

	/// maximum nested depth of [] and () supported by the transform;
	/// implementation detail
	private static let _nestDepth = 6

	private static var _nestedBracketsPattern = ""
	private static var _nestedParensPattern = ""

	/// Reusable pattern to match balanced [brackets]. See Friedl's
	/// "Mastering Regular Expressions", 2nd Ed., pp. 328-331.
	private static func getNestedBracketsPattern() -> String {
		// in other words [this] and [this[also]] and [this[also[too]]]
		// up to _nestDepth
		if (_nestedBracketsPattern.isEmpty) {
			_nestedBracketsPattern = repeatString([
				"(?>             # Atomic matching",
				"[^\\[\\]]+      # Anything other than brackets",
				"|",
				"\\["
				].joinWithSeparator("\n"), _nestDepth) +
				repeatString(" \\])*", _nestDepth)
		}
		return _nestedBracketsPattern
	}

	/// Reusable pattern to match balanced (parens). See Friedl's
	/// "Mastering Regular Expressions", 2nd Ed., pp. 328-331.
	private static func getNestedParensPattern() -> String {
		// in other words (this) and (this(also)) and (this(also(too)))
		// up to _nestDepth
		if (_nestedParensPattern.isEmpty) {
			_nestedParensPattern = repeatString([
				"(?>            # Atomic matching",
				"[^()\\s]+      # Anything other than parens or whitespace",
				"|",
				"\\("
				].joinWithSeparator("\n"), _nestDepth) +
				repeatString(" \\))*", _nestDepth)
		}
		return _nestedParensPattern
	}

	/// this is to emulate what's available in PHP
	private static func repeatString(text: String, _ count: Int) -> String {
		return Array(count: count, repeatedValue: text).reduce("", combine: +)
	}
}