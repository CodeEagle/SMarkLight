//: Playground - noun: a place where people can play

import UIKit
import XCPlayground
let sample = NSBundle.mainBundle().pathForResource("Sample", ofType: "md")!
let str = (try? String(contentsOfFile: sample))!

let nsstr = str as NSString
func printStr(of subrange: NSRange?) {
    guard let value = subrange else { return }
    print(nsstr.substringWithRange(value))
}

SMarkParser.shared.parse(within: str)




