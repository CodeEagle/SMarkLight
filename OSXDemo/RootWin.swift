//
//  RootWin.swift
//  SMarkLight
//
//  Created by LawLincoln on 16/8/31.
//  Copyright © 2016年 LawLincoln. All rights reserved.
//

import Cocoa
import SMarkLight

class RootWin: NSWindow {
	private var aWin: NSWindow?

	override init(contentRect: NSRect, styleMask aStyle: Int, backing bufferingType: NSBackingStoreType, defer flag: Bool) {
		super.init(contentRect: contentRect, styleMask: aStyle, backing: bufferingType, defer: flag)
	}

	required init?(coder: NSCoder) {
		super.init(coder: coder)
	}

	convenience init() {
		self.init(contentRect: NSMakeRect(0, 0, 300, 400), styleMask: 0, backing: NSBackingStoreType.Buffered, defer: true)
		setup()
	}

	override func awakeFromNib() {
		super.awakeFromNib()
		setup()
    }

	private func setup() {
        let sc = SMarkEditorScrollView(frame: contentView!.bounds)
		sc.translatesAutoresizingMaskIntoConstraints = false
		contentView?.addSubview(sc)
		contentView?.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-0-[sc]-0-|", options: NSLayoutFormatOptions.DirectionLeftToRight, metrics: nil, views: ["sc": sc]))
		contentView?.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-0-[sc]-0-|", options: NSLayoutFormatOptions.DirectionLeftToRight, metrics: nil, views: ["sc": sc]))
    
		// Load a sample markdown content from a file inside the app bundle
		
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(3 * Double(NSEC_PER_SEC))), dispatch_get_main_queue()) { () -> Void in
//            Marklight.theme = SMarkStyle.List.mouNight.value!
        }
	}
}
