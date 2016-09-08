//: [Previous](@previous)

import UIKit
func matchesForRegexInText(regex: String, text: String) -> [String] {
    
    do {
        let regex = try NSRegularExpression(pattern: regex, options: [])
        let nsString = text as NSString
        let results = regex.matchesInString(text, options: [], range: NSMakeRange(0, nsString.length))
        return results.map { nsString.substringWithRange($0.range)}
    } catch let error as NSError {
        print("invalid regex: \(error.localizedDescription)")
        return []
    }
}
let p = NSBundle.mainBundle().pathForResource("File2", ofType: nil)!
let string = "\n\n**这些文字会生成`<strong>`**\n\n*这些文字会生成`<em>`*"//try? String(contentsOfFile: p)
//"(?m)\\n*`{1,3}.*\\b\\n?(.|\\n)*\\n`{1,3}"
let matches = matchesForRegexInText("\\n{2,}(-?\\s?\\*?)*\\n+", text: string)
print(matches)


