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
let p = NSBundle.mainBundle().pathForResource("ref", ofType: nil)!
var string = try? String(contentsOfFile: p)// "\n\n**这些文字会生成`<strong>`**\n\n*这些文字会生成`<em>`*"//
//"(?m)\\n*`{1,3}.*\\b\\n?(.|\\n)*\\n`{1,3}"
/*
 ![Alt text][id]
 「id」是圖片參考的名稱，圖片參考的定義方式則和連結參考一樣：
 
 [id]: http://ww2.sinaimg.cn/mw690/417b96e8gw1f7mavtowcqj20zk0qoqau.jpg "Optional title attribute"
 
 ![Alt text](/path/to/img.jpg)
 
 ![Alt text](/path/to/img.jpg "Optional title~")
 */
//(\\w|\\s|/|:|\\.|\\\")
//private let imagePattern = "(?m)\\n\\!\\[?(\\w|\\s)*\\]\\((.[^\\)])*\\)"

//private let imageRefPattern = "(?m)(?<open>\\n?\\!\\[?(\\w|\\s)*\\]\\[(.[^\\]])*\\])(?:[.\\n[^\\[]]*)(?<close>\\[(.[^\\]])*\\]:.*\\b)"
//print(string)
//[\\n>\\s]?(=+|-+)\\b
/*
 😆0:> ### Header
 😆1:>
 😆2:> Header
 😆3:> ======
 😆4:>
 😆5:> Another header
 😆6:> -------------
 😆7:
 > This is the first level of quoting.
 😆8:>
 😆9:> > This is nested blockquote.
 😆10:>
 😆11:> Back to the first level.
 😆12:
 > * 整理知识，学习笔记
 😆13:> * 发布日记，杂文，所见所想
 😆14:> * 撰写发布技术文稿（代码支持）
 😆15:> * 撰写发布学术论文（LaTeX 公式支持）
 😆16:
 > 请保留此份 Cmd Markdown 的欢迎稿兼使用说明，如需撰写新稿件，点击顶部工具栏右侧的 <i class="icon-file"></i> **新文稿** 或者使用快捷键 `Ctrl+Alt+N`。
 */
let quoteLines = "(?m)^\\n*>+.*"
let quoteOpen = "(?m)^\\n*>(>|\\s)*"
let atx = "(?m)^([^'{1-3}]\\n*(?:>?\\s?))#{1,6}(?:.*[^\\n])(?:#*)\\b"
let setex = "(?m)^(?:[\\n>\\s]?.*)\\b\\n[^\\n{2,}](?:>?\\s?)(?:=|-){3,}"
let code = "(?m)(?:(?<open>`{1,3}).*\\k<open>)"
let codeSpanInLine = "`[^`]*`"
let list = "(?m)^(?:(?:\\n*>?\\s?\\*)|(?:(?:\\n*>?\\s?|\\s+)\\d+[.]))"
let listLine = "((\\p{Z}{0,3}(\(list))\\p{Z}+)(?s:.+?)(\\z|\\n{2,}(?=\\S)(?!\\p{Z}*\(list)\\p{Z}+)))"
let imagePattern = "(?m)^\\!\\[[^\\]]*\\]\\([^\\)]*\\)\\n?"
// let imageRefPattern = "(?m)(?<open>\\n?\\!\\[?(\\w|\\s)*\\]\\[(.[^\\]])*\\])(?:[.\\n[^\\[]]*)(?<close>\\[(.[^\\]])*\\]:.*\\b)"
let imageRefPatternOpen = "(?:\\n?\\!\\[?(\\w|\\s)*\\]\\[(.[^\\]])*\\])"
let imageRefPatternClose = "(?:\\[[^\\]]*\\]:.*\\n?.*\\n)"
let imageRefPattern = "(?m)\(imageRefPatternOpen)(?:[.\\n[^\\[]]*)\(imageRefPatternClose)"
let test = "\\p{Z}{1,3}"
let refNote = "\\[[^\\]]*\\]\\[\\d+\\]"
let italic = "(?m)(?<=[^\\*_\\\\])(\\*|_)[^\\s\\*_](|[^\\n\\1\\\\])*[^\\s\\\\]\\1"
//string = "dsA123A"
//let test = "A(?:\\w+)A"
let matches = matchesForRegexInText(refNote, text: string!)
for (i, match) in matches.enumerate() {
    print(match)
//    if matche.hasPrefix("```") || matche.hasPrefix("``") { continue }
//    let results = matchesForRegexInText(codeSpanInLine, text: matche)
//    for re in results {
//        print(re)
//    }
}


