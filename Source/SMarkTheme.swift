//
//  SMarkTheme.swift
//  SMarkLight
//
//  Created by LawLincoln on 16/8/30.
//  Copyright © 2016年 LawLincoln. All rights reserved.
//
#if os(iOS)
	import UIKit
	public typealias MColor = UIColor
	public typealias MFont = UIFont
#elseif os(OSX)
	import Cocoa
	public typealias MColor = NSColor
	public typealias MFont = NSFont
#endif
import Foundation
enum ThemeKeys: String {
	case color = "color", background = "background", fontFamily = "font-family", fontSize = "font-size", fontWeight = "font-weight", base = "base", title = "title", bold = "bold", link = "link", comment = "comment", code = "code", quote = "quote", tasklist = "tasklist", italic = "italic", text = "text", delete = "delete"
}

public struct ThemeItem {
	public let color: MColor
	public let font: MFont?
	public let background: MColor?

	init(json: [String: AnyObject]) {
		color = MColor(raw: json[ThemeKeys.color.rawValue] as? String) ?? MColor.blackColor()
		background = MColor(raw: json[ThemeKeys.background.rawValue] as? String) ?? MColor.whiteColor()
		let family = json[ThemeKeys.fontFamily.rawValue] as? String
		let size = json[ThemeKeys.fontSize.rawValue] as? CGFloat
		let weight = json[ThemeKeys.fontWeight.rawValue] as? String

		if let f = family, let s = size, let w = weight { font = MFont(fontfamily: f, weight: w, size: s) }
		else if let f = family, let w = weight { font = MFont(fontfamily: f, weight: w) }
		else if let f = family, let s = size { font = MFont(fontfamily: f, size: s) }
		else if let f = family { font = MFont(fontfamily: f) }
		else { font = nil }
	}
}
public struct SMarkTheme {

	public let base: ThemeItem?
	public let title: ThemeItem?
	public let bold: ThemeItem?
	public let link: ThemeItem?
	public let comment: ThemeItem?
	public let code: ThemeItem?
	public let quote: ThemeItem?
	public let tasklist: ThemeItem?
	public let italic: ThemeItem?
	public let text: ThemeItem?
	public let delete: ThemeItem?

	public init(json: [String: AnyObject]) {

		let baseFontFamily = json["base"]?[ThemeKeys.fontFamily.rawValue] as? String ?? "AvenirNextCondensed"
		let baseFontSize = json["base"]?[ThemeKeys.fontSize.rawValue] as? CGFloat ?? 16
		let baseFontWeight = json["base"]?[ThemeKeys.fontWeight.rawValue] as? String ?? ""
		let list: [ThemeKeys] = [.base, .title, .bold, .link, .comment, .code, .quote, .tasklist, .italic, .text, .delete]
		var valueList: [ThemeItem!] = [nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil]
		for (i, key) in list.enumerate() {
			guard var item = json[key.rawValue] as? [String: AnyObject] else { continue }
			let family = item[ThemeKeys.fontFamily.rawValue] ?? baseFontFamily
			let size = item[ThemeKeys.fontSize.rawValue] ?? baseFontSize
			let weight = item[ThemeKeys.fontWeight.rawValue] ?? baseFontWeight
			item[ThemeKeys.fontFamily.rawValue] = family
			item[ThemeKeys.fontSize.rawValue] = size
			item[ThemeKeys.fontWeight.rawValue] = weight
			let value = ThemeItem(json: item)
			valueList.removeAtIndex(i)
			valueList.insert(value, atIndex: i)
		}
		base = valueList[safe: 0] ?? nil
		title = valueList[safe: 1] ?? nil
		bold = valueList[safe: 2] ?? nil
		link = valueList[safe: 3] ?? nil
		comment = valueList[safe: 4] ?? nil
		code = valueList[safe: 5] ?? nil
		quote = valueList[safe: 6] ?? nil
		tasklist = valueList[safe: 7] ?? nil
		italic = valueList[safe: 8] ?? nil
		text = valueList[safe: 9] ?? nil
		delete = valueList[safe: 10] ?? nil
	}

	public init?(theme name: String = "default", `in` bundle: NSBundle? = nil) {
		#if os(iOS)
			let b = bundle ?? NSBundle(forClass: MarklightTextStorage.self)
		#elseif os(OSX)
			let b = bundle ?? NSBundle(forClass: SMarkEditor.self)
		#endif
		if let p = b.pathForResource(name, ofType: "smark") {
			do {
				guard let data = NSData(contentsOfFile: p) else { return nil }
				let dict = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments)
				guard let json = dict as? [String: AnyObject] else {
					assertionFailure("json format not right")
					return nil
				}
				self.init(json: json)
			} catch { return nil }
		} else {
			return nil
		}
	}
}

