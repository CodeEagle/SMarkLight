//
//  SMarkStyle.swift
//  SMarkLight
//
//  Created by LawLincoln on 16/9/1.
//  Copyright © 2016年 LawLincoln. All rights reserved.
//

import Foundation
let baseBundle = NSBundle(forClass: SMarkEditor.self)
public enum SMarkStyleItemType: String {
	case link = "LINK", autoLinkURL = "AUTO_LINK_URL", autoLinkEmail = "AUTO_LINK_EMAIL", image = "IMAGE", code = "CODE", html = "HTML", htmlEntity = "HTML_ENTITY", emph = "EMPH", strong = "STRONG", listBullet = "LIST_BULLET", listEnumerator = "LIST_ENUMERATOR", comment = "COMMENT", h1 = "H1", h2 = "H2", h3 = "H3", h4 = "H4", h5 = "H5", h6 = "H6", blockquote = "BLOCKQUOTE", verbatim = "VERBATIM", htmlBlock = "HTMLBLOCK", hRule = "HRULE", reference = "REFERENCE", note = "NOTE", strike = "STRIKE", editor = "editor", editorSelection = "editor-selection"
}
public struct SMarkStyleItem {

	private let foreground: String?
	private let background: String?
	private let fontStyle: String?
	private let fontFamily: String
	private let fontSize: CGFloat
	private let strike: String?
	public var foregroundColor: MColor? { return MColor(raw: foreground) }
	public var backgroundColor: MColor? { return MColor(raw: background) }
	public var strikeColor: MColor? { return MColor(raw: strike) }
	public var font: MFont? { return MFont(fontfamily: fontFamily, weight: fontStyle ?? "", size: fontSize) }
}
public struct SMarkStyle {
	private static var defaultFont: String { return "Menlo" }
	private static var defaultFontSize: CGFloat { return 16 }

	private var foreground: String { return items[.editor]?.foreground ?? "529F61" }
	private var background: String { return items[.editor]?.background ?? "194141" }
	private var fontFamily: String { return items[.editor]?.fontFamily ?? SMarkStyle.defaultFont }
	private var fontStyle: String { return items[.editor]?.fontStyle ?? "" }
	private var fontSize: CGFloat { return items[.editor]?.fontSize ?? 16 }

	public var font: MFont { return MFont(fontfamily: fontFamily, weight: fontStyle, size: fontSize)! }
	public var foregroundColor: MColor? { return MColor(raw: foreground) }
	public var backgroundColor: MColor? { return MColor(raw: background) }
	public var caretColor: MColor? { return MColor(raw: caret) }

	private let caret: String
	public let items: [SMarkStyleItemType: SMarkStyleItem]

	public enum List: String {
		case mouFreshAir = "Mou Fresh Air"
		case mouFreshAirPlus = "Mou Fresh Air+"
		case mouNight = "Mou Night"
		case mouNightPlus = "Mou Night+"
		case mouPaper = "Mou Paper"
		case mouPaperPlus = "Mou Paper+"
		case solarizedDark = "Solarized (Dark)"
		case solarizedDarkPlus = "Solarized (Dark)+"
		case solarizedLight = "Solarized (Light)"
		case solarizedLightPlus = "Solarized (Light)+"
		case tomorrowBlue = "Tomorrow Blue"
		case tomorrow = "Tomorrow"
		case tomorrowPlus = "Tomorrow+"
		case writer = "Writer"
		case writerPlus = "Writer+"

		public var value: SMarkStyle? {

			enum Keys: String {
				case comment = "#"
				case foreground = "foreground"
				case background = "background"
				case foregroundColor = "foreground-color"
				case backgroundColor = "background-color"
				case caret = "caret"
				case caretColor = "caret-color"
				case fontStyle = "font-style"
				case fontSize = "font-size"
				case fontFamily = "font-family"
				case strike = "strike"
				case strikeColor = "strike-color"
			}
			var baseFontFamily: String?
			var baseFontSize: CGFloat?
			func dealLine(entity: String) -> ((SMarkStyleItemType, SMarkStyleItem)?, caret: String?) {
				var lines = entity.componentsSeparatedByString("\n")
				let first = lines.removeFirst()
				let raw = first.stringByTrimmingCharactersInSet(.whitespaceAndNewlineCharacterSet())
				guard let type = SMarkStyleItemType(rawValue: raw) else { return (nil, nil) }
				let mark = ":"
				var map: [Keys: AnyObject] = [:]
				for rawLine in lines {
					var line = rawLine
					if line.hasPrefix(Keys.comment.rawValue) { continue }
					if let range = line.rangeOfString(Keys.comment.rawValue) { line = line.substringToIndex(range.startIndex) }
					line = line.stringByTrimmingCharactersInSet(.whitespaceCharacterSet())
					let keyValues = line.componentsSeparatedByString(mark)
					guard let keyRaw = keyValues[safe: 0], key = Keys(rawValue: keyRaw), var value = keyValues[safe: 1] else { continue }
					value = value.stringByTrimmingCharactersInSet(.whitespaceCharacterSet())
					value = value.stringByReplacingOccurrencesOfString("px", withString: "")
					switch key {
					case .foreground, .foregroundColor: map[.foreground] = value
					case .background, .backgroundColor: map[.background] = value
					case .strike, .strikeColor: map[.strike] = value
					case .caret, .caretColor: map[.caret] = value
					case .fontSize: if let i = Int(value) { map[.fontSize] = CGFloat(i) }
					case .fontFamily: map[.fontFamily] = value
					case .fontStyle: map[.fontStyle] = value
					default: break
					}
				}
				let foreground = map[.foreground] as? String
				let background = map[.background] as? String
				let fontFamily = map[.fontFamily] as? String ?? (baseFontFamily ?? SMarkStyle.defaultFont)
				let fontSize = map[.fontSize] as? CGFloat ?? (baseFontSize ?? SMarkStyle.defaultFontSize)
				let fontStyle = map[.fontStyle] as? String
				let strike = map[.strike] as? String
				if type == .editor { baseFontFamily = fontFamily ?? SMarkStyle.defaultFont }
				let item = SMarkStyleItem(foreground: foreground, background: background, fontStyle: fontStyle, fontFamily: fontFamily, fontSize: fontSize, strike: strike)
				return ((type, item), map[.caret] as? String)
			}

			guard let p = baseBundle.pathForResource(rawValue, ofType: "style") else { return nil }
			do {
				let lines = try String(contentsOfFile: p).componentsSeparatedByString("\n\n")
				var caret = "ffffff"
				var dict: [SMarkStyleItemType: SMarkStyleItem] = [:]
				for entity in lines {
					let (ret, cret) = dealLine(entity)
					if let r = ret { dict[r.0] = r.1 }
					if let c = cret { caret = c }
				}
				return SMarkStyle(caret: caret, items: dict)
			} catch { return nil }
		}
	}
}
