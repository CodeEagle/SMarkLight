//
//  RootVC.swift
//  SMarkLight
//
//  Created by LawLincoln on 16/9/1.
//  Copyright © 2016年 LawLincoln. All rights reserved.
//
import SMarkLight
import Cocoa
class ARootWin: NSWindow {
	deinit {
		Swift.print("deinit")
	}
	override init(contentRect: NSRect, styleMask aStyle: Int, backing bufferingType: NSBackingStoreType, defer flag: Bool) {
		super.init(contentRect: contentRect, styleMask: aStyle, backing: bufferingType, defer: flag)
	}

	required init?(coder: NSCoder) {
		super.init(coder: coder)
	}

	convenience init() {
		let mask = NSTitledWindowMask | NSClosableWindowMask | NSMiniaturizableWindowMask | NSResizableWindowMask
		self.init(contentRect: NSMakeRect(0, 0, 300, 400), styleMask: mask, backing: NSBackingStoreType.Buffered, defer: true)
		setup()
	}

	override func awakeFromNib() {
		super.awakeFromNib()
		setup()
	}

	var sc: NSScrollView = NSScrollView(frame: NSZeroRect)

	private func setup() {
//		contentViewController = RootVC()
		let textView = SMarkEditor(frame: NSZeroRect)
		sc.translatesAutoresizingMaskIntoConstraints = false
		contentView?.addSubview(sc)
		contentView?.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-0-[sc]-0-|", options: NSLayoutFormatOptions.DirectionLeftToRight, metrics: nil, views: ["sc": sc]))
		contentView?.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-0-[sc]-0-|", options: NSLayoutFormatOptions.DirectionLeftToRight, metrics: nil, views: ["sc": sc]))

		// Load a sample markdown content from a file inside the app bundle
		if let samplePath = NSBundle.mainBundle().pathForResource("Sample", ofType: "md") {
			do {
				let string = try String(contentsOfFile: samplePath)
				textView.string = string
			} catch { }
		}

	}
}

class RootVC: NSViewController {
	required init?(coder: NSCoder) {
		super.init(coder: coder)
	}

	override func loadView() {
		view = NSVisualEffectView(frame: NSMakeRect(0, 0, 300, 400))
	}

	override init?(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
		super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
	}

	convenience init() {
		self.init(nibName: nil, bundle: nil)!
	}

}
