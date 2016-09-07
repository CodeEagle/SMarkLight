//
//  SMarkEditor.swift
//  SMarkLight
//
//  Created by LawLincoln on 16/9/1.
//  Copyright © 2016年 LawLincoln. All rights reserved.
//
#if os(OSX)
    import Cocoa
    public typealias MTextView = NSTextView
#elseif os(iOS)
    import UIKit
    public typealias MTextView = UITextView
#endif
#if os(OSX)
    public class SMarkEditorScrollView: NSScrollView {
        
        private var textView = SMarkEditor(frame: NSMakeRect(0, 0, 400, 400))
        public required init?(coder: NSCoder) {
            super.init(coder: coder)
            setup()
        }
        
        public override init(frame frameRect: NSRect) {
            super.init(frame: frameRect)
            setup()
        }
        
        private func setup() {
            documentView = textView
            textView.textContainerInset = NSMakeSize(4, 4)
        }
        
        public var string: String? {
            get { return textView.string }
            set(val) { textView.string = val }
        }
    }
#endif

public class SMarkEditor: MTextView {
    
    deinit { NSNotificationCenter.defaultCenter().removeObserver(self) }
    
    required public init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    #if os(OSX)
    override init(frame frameRect: NSRect, textContainer container: NSTextContainer?) {
        super.init(frame: frameRect, textContainer: container)
        setup()
    }
    
    private func setup() {
        automaticQuoteSubstitutionEnabled = false
        automaticDashSubstitutionEnabled = false
        automaticLinkDetectionEnabled = false
        allowsUndo = true
        font = Marklight.theme.font
        if let color = Marklight.theme.foregroundColor {
            textColor = color
            insertionPointColor = color
        }
        if let color = Marklight.theme.backgroundColor { backgroundColor = color }
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(SMarkEditor.textChange), name: NSTextDidChangeNotification, object: self)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(SMarkEditor.renderWhenTextChange), name: Marklight.Event.themeChange.rawValue, object: nil)
    }
    
    override public var intrinsicContentSize: NSSize {
        guard let container = textContainer, manager = layoutManager else { return NSZeroSize }
        manager.ensureLayoutForTextContainer(container)
        return manager.usedRectForTextContainer(container).size
    }
    
    public override func viewDidMoveToSuperview() {
        super.viewDidMoveToSuperview()
        guard let value = superview else { return }
        translatesAutoresizingMaskIntoConstraints = false
        value.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-0-[textView]-0-|", options: NSLayoutFormatOptions.DirectionLeftToRight, metrics: nil, views: ["textView": self]))
        value.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-0-[textView]-0-|", options: NSLayoutFormatOptions.DirectionLeftToRight, metrics: nil, views: ["textView": self]))
    }
    
    override public var string: String? {
        get { return super.string }
        set(val) {
            super.string = val
            renderWhenTextChange()
        }
    }
    
    #elseif os(iOS)
    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        setup()
    }
    
    override public var text: String! {
        get { return super.text }
        set(val) {
            super.text = val
            dealText()
            delayPagedRender()
        }
    }

    private func setup() {
        font = Marklight.theme.font
        if let color = Marklight.theme.foregroundColor {
            textColor = color
            tintColor = color
        }
        if let color = Marklight.theme.backgroundColor { backgroundColor = color }
        textContainerInset = UIEdgeInsetsMake(4, 4, 4, 4)
        NSNotificationCenter.defaultCenter().addObserverForName(UITextViewTextDidChangeNotification, object: self, queue: NSOperationQueue.mainQueue()) {[weak self] (notification) -> Void in
            guard let sself = self else { return }
            if sself.textStorage.string.hasSuffix("\n") {
                CATransaction.setCompletionBlock({ () -> Void in
                    sself.scrollToCaret(animated: false)
                })
            } else {
                sself.scrollToCaret(animated: false)
            }
            sself.textChange()
        }
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(SMarkEditor.renderWhenTextChange), name: Marklight.Event.themeChange.rawValue, object: self)
    }
    
    private func scrollToCaret(animated animated: Bool) {
        guard let value = selectedTextRange?.end else { return }
        var rect = caretRectForPosition(value)
        rect.size.height = rect.size.height + textContainerInset.bottom
        scrollRectToVisible(rect, animated: animated)
    }

    #endif
    
    private func delayPagedRender() {
        let sel = #selector(SMarkEditor.pagedRender)
        NSObject.cancelPreviousPerformRequestsWithTarget(self, selector: sel, object: nil)
        performSelector(sel, withObject: nil, afterDelay: 0.2)
    }
    
    @objc private func pagedRender() {
        #if os(OSX)
            guard let value = string else { return }
            var range: NSRange?
            var v = enclosingScrollView?.contentView.documentVisibleRect
            if let h = v?.height { v?.size.height = h + 50 }// pre render a bit
            if let visibleRect = v, container = textContainer, visibleGlyphRange = layoutManager?.glyphRangeForBoundingRectWithoutAdditionalLayout(visibleRect, inTextContainer: container) {
                range = layoutManager?.characterRangeForGlyphRange(visibleGlyphRange, actualGlyphRange: nil)
            }
            if range == nil || range?.length == 0 {
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(0.05 * Double(NSEC_PER_SEC))), dispatch_get_main_queue()) { () -> Void in
                    self.pagedRender()
                }
                return
            }
            guard let st = textStorage  else { return }
        #elseif os(iOS)
            guard let value = text else { return }
            var range: NSRange?
            var visibleRect = CGRect(origin: self.contentOffset, size: self.bounds.size)
            visibleRect.size.height += 20 // pre render a bit
            
            let visibleGlyphRange = self.layoutManager.glyphRangeForBoundingRectWithoutAdditionalLayout(visibleRect, inTextContainer: self.textContainer)
            range = self.layoutManager.characterRangeForGlyphRange(visibleGlyphRange, actualGlyphRange: nil)
            
            if range == nil || range?.length == 0 {
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(0.05 * Double(NSEC_PER_SEC))), dispatch_get_main_queue()) { () -> Void in
                    self.pagedRender()
                }
                return
            }
            let st = textStorage
        #endif
        guard let r = range else { return }
//        guard let value = rawText, st = smarkTextStorage else { return }
        let targetLength = value.characters.count
        let pageSize = r.length + 100
        var location = 0
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), { () -> Void in
            repeat {
                var range = NSMakeRange(location, pageSize)
                if range.location > targetLength { break }
                if range.location < targetLength && NSMaxRange(range) >  targetLength {
                    range.length = targetLength - range.location
                }
                let sub = (value as NSString).substringWithRange(range)
                let r = (sub as NSString).rangeOfString("\n\n", options: NSStringCompareOptions.BackwardsSearch)
                if r.location != NSNotFound {
                    let dealLength = NSMaxRange(r)
                    range.length = dealLength
                }
                location += range.length
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    Marklight.processEditing(st, with: range)
                })
            } while( location < targetLength )
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.invalidateIntrinsicContentSize()
            })
        })
    }
    
    private var rawText: String? {
        #if os(OSX)
            return string
        #elseif os(iOS)
            return text
        #endif
    }
    
    private var smarkTextStorage: NSTextStorage? {
        #if os(OSX)
            return textStorage
        #elseif os(iOS)
            return textStorage
        #endif
    }
    
    
    
    private func firstPage() {
        guard let st = smarkTextStorage, value = rawText else { return }
        let r = NSMakeRange(0, min(500, value.characters.count))
        Marklight.processEditing(st, with: r)
    }
    
    @objc private func renderWhenTextChange() {
        firstPage()
        delayPagedRender()
    }
    
    @objc private func dealText() {
        var range: NSRange?
        #if os(OSX)
            guard let st = textStorage, let visibleRect = enclosingScrollView?.contentView.documentVisibleRect, let container = textContainer,let manager = layoutManager else {
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(0.05 * Double(NSEC_PER_SEC))), dispatch_get_main_queue()) { () -> Void in
                    self.dealText()
                }
                return
            }
            let visibleGlyphRange = manager.glyphRangeForBoundingRectWithoutAdditionalLayout(visibleRect, inTextContainer: container)
            range = manager.characterRangeForGlyphRange(visibleGlyphRange, actualGlyphRange: nil)
        #elseif os(iOS)
            let st = textStorage
            let visibleRect = CGRect(origin: self.contentOffset, size: self.bounds.size)
            let visibleGlyphRange = self.layoutManager.glyphRangeForBoundingRectWithoutAdditionalLayout(visibleRect, inTextContainer: self.textContainer)
            range = self.layoutManager.characterRangeForGlyphRange(visibleGlyphRange, actualGlyphRange: nil)
        #endif
        if range == nil || range?.length == 0 {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(0.05 * Double(NSEC_PER_SEC))), dispatch_get_main_queue()) { () -> Void in
                self.dealText()
            }
            return
        }
        guard let r = range else { return }
        Marklight.processEditing(st, with: nearestNewLine(of: r))
    }
    
    private func nearestNewLine(of range: NSRange) -> NSRange {
        guard let value = rawText else { return range }
        var range = range
        let sub = (value  as NSString).substringWithRange(range)
        let r = (sub as NSString).rangeOfString("\n\n", options: NSStringCompareOptions.BackwardsSearch)
        if r.location != NSNotFound {
            let dealLength = NSMaxRange(r)
            range.length = dealLength
        }
        return range
    }
    
    @objc private func textChange() {
        let sel = #selector(SMarkEditor.dealText)
        NSObject.cancelPreviousPerformRequestsWithTarget(self, selector: sel, object: nil)
        performSelector(sel, withObject: nil, afterDelay: 0.2)
    }
}