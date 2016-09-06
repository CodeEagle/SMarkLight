//
//  Extension.swift
//  SMarkLight
//
//  Created by LawLincoln on 16/9/1.
//  Copyright © 2016年 LawLincoln. All rights reserved.
//

import Foundation
#if os(iOS)
	import UIKit
	public typealias MColor = UIColor
	public typealias MFont = UIFont
#elseif os(OSX)
	import Cocoa
	public typealias MColor = NSColor
	public typealias MFont = NSFont
#endif
extension MFont {
	convenience init?(fontfamily: String, weight: String = "", size: CGFloat = 15) {
		let aname = "\(fontfamily.capitalizedString)" + (weight == "" ? "" : "-\(weight.capitalizedString)")
		self.init(name: aname, size: size)
	}
	#if os(OSX)
		static func italicSystemFontOfSize(size: CGFloat) -> MFont {
			let f = MFont.systemFontOfSize(size)
			return NSFontManager.sharedFontManager().convertFont(f, toHaveTrait: NSFontTraitMask.ItalicFontMask)
		}
	#endif
}
extension MColor {

	convenience init?(raw: String?) {
		guard let hex = raw else { return nil }
		var cString: String = hex.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet() as NSCharacterSet).uppercaseString

		if (cString.hasPrefix("#")) { cString = cString.substringFromIndex(cString.startIndex.advancedBy(1)) }
		if ((cString.characters.count) != 6) { return nil }
		var rgbValue: UInt32 = 0
		NSScanner(string: cString).scanHexInt(&rgbValue)
		self.init(
			red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
			green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
			blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
			alpha: CGFloat(1.0)
		)
	}
}
extension Array {
	subscript(safe index: Int) -> Element? {
		return indices.contains(index) ? self[index]: nil
	}
}