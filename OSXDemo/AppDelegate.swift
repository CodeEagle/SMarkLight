//
//  AppDelegate.swift
//  OSXDemo
//
//  Created by LawLincoln on 16/8/31.
//  Copyright © 2016年 LawLincoln. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

	@IBOutlet weak var window: NSWindow!

	func applicationDidFinishLaunching(aNotification: NSNotification) {

	}

	func applicationWillTerminate(aNotification: NSNotification) {
		// Insert code here to tear down your application
	}

	func applicationShouldHandleReopen(sender: NSApplication, hasVisibleWindows flag: Bool) -> Bool {
		if flag { window?.orderFront(self) }
		else { window?.makeKeyAndOrderFront(self) }
		return true
	}

}

