//
//  ViewController.swift
//  Marklight Sample
//
//  Created by Matteo Gavagnin on 01/01/16.
//  Copyright © 2016 MacTeo. All rights reserved.
//

import UIKit

// Import the Marklight framework
import SMarkLight

class ViewController: UIViewController {

	// Keep strong instance of the `NSTextStorage` subclass
	

	// Connect an outlet from the `UITextView` on the storyboard
	private var textView = SMarkEditor()

	// Connect the `textView`'s bottom layout constraint to react to keyboard movements
//    var bottomTextViewConstraint: NSLayoutConstraint!

	override func viewDidLoad() {
		super.viewDidLoad()
        automaticallyAdjustsScrollViewInsets = false
        textView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(textView)
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-0-[textView]-0-|", options: NSLayoutFormatOptions.DirectionLeftToRight, metrics: nil, views: ["textView": textView]))
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-0-[textView]-0-|", options: NSLayoutFormatOptions.DirectionLeftToRight, metrics: nil, views: ["textView": textView]))
        
		// Load a sample markdown content from a file inside the app bundle
		if let samplePath = NSBundle.mainBundle().pathForResource("Sample", ofType: "md") {
			do {
				let string = try String(contentsOfFile: samplePath)
				// Set the loaded string to the `UITextView`
				textView.text  = string
				// Append the loaded string to the `NSTextStorage`
			} catch _ {
				print("Cannot read Sample.md file")
			}
		}

		

		// We do some magic to resize the `UITextView` to react the the keyboard size change (appearance, disappearance, ecc)
//		NSNotificationCenter.defaultCenter().addObserverForName(UIKeyboardWillChangeFrameNotification, object: nil, queue: NSOperationQueue.mainQueue()) { (notification) -> Void in
//
//			let initialRect = notification.userInfo![UIKeyboardFrameBeginUserInfoKey]?.CGRectValue
//			let _ = self.view.frame.size.height - self.view.convertRect(initialRect!, fromView: nil).origin.y
//			let keyboardRect = notification.userInfo![UIKeyboardFrameEndUserInfoKey]?.CGRectValue
//			let newHeight = self.view.frame.size.height - self.view.convertRect(keyboardRect!, fromView: nil).origin.y
//
//			self.bottomTextViewConstraint.constant = newHeight
//
//			self.textView.setNeedsUpdateConstraints()
//
//			let duration = notification.userInfo![UIKeyboardAnimationDurationUserInfoKey]?.doubleValue
//			let curve = notification.userInfo![UIKeyboardAnimationCurveUserInfoKey]?.unsignedIntegerValue
//
//			UIView.animateWithDuration(duration!, delay: 0, options: [UIViewAnimationOptions(rawValue: curve!), .BeginFromCurrentState], animations: { () -> Void in
//				self.textView.layoutIfNeeded()
//				}, completion: { (finished) -> Void in
//
//			})
//		}

		 
	}

	 
}

