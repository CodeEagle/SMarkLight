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

let string = "*寫作*用語言 *Hello* 123\\. *asdf*"
let matches = matchesForRegexInText("(?u)(\\*\\b(?:(?!\\*).)*?\\b\\*)", text: string)
print(matches)



