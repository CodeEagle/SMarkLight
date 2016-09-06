// : Playground - noun: a place where people can play

import Cocoa

//let str = "asdf\n<!-- abc -->\n~~delete~~\nasdf"
//let range = NSMakeRange(0, str.characters.count)
//let commentPattern = "<!--(.*?)-->"
//let deletePattern = "~~(.*?)~~"
//do {
//	let a = try NSRegularExpression(pattern: deletePattern, options: .UseUnixLineSeparators)
//	a.enumerateMatchesInString(str, options: NSMatchingOptions(rawValue: 0), range: range) { (result, flags, stop) in
//		print(result?.range)
//		if let r = result?.range {
//			print("comment:\((str as NSString).substringWithRange(r))")
//		}
//	}
//} catch {
//	print(error)
//}
//let f = NSFont.systemFontOfSize(16)
//NSFontManager.sharedFontManager().convertFont(f, toHaveTrait: NSFontTraitMask.ItalicFontMask)
let text = "1986\\. What a great season. A link here: <http://www.example.com/> that should be automatically detected." + "\n\n" + "Stuff *here!*. This is pretty cool." + "\n\n" + "* Hello\n" + "* Booboo\n\n abc"
let range = (text as NSString).rangeOfString("\n\n", options: NSStringCompareOptions.BackwardsSearch)

let sub = (text as NSString).substringWithRange(NSMakeRange(0, NSMaxRange(range)))
print(sub)