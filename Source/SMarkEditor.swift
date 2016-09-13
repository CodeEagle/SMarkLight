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
public typealias DidRender = (String?) -> Void
#if os(OSX)
    public class SMarkEditorScrollView: NSScrollView {
        
        private var textView: SMarkEditor!
        public var didRender: DidRender? {
            didSet {
                textView?.didRender = didRender
            }
        }
        public required init?(coder: NSCoder) {
            super.init(coder: coder)
            setup()
        }
        
        public override init(frame frameRect: NSRect) {
            super.init(frame: frameRect)
            setup()
        }
        
        private func setup() {
           
            textView = SMarkEditor(frame: bounds)
            documentView = textView
            textView.textContainerInset = NSMakeSize(4, 4)
            autoresizingMask = [NSAutoresizingMaskOptions.ViewWidthSizable, NSAutoresizingMaskOptions.ViewHeightSizable]
            themeChange()
            NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(SMarkEditorScrollView.themeChange), name: SMarkParser.Event.themeChange.rawValue, object: nil)
        }
        
        @objc private func themeChange() {
            if let color = SMarkParser.shared.theme.backgroundColor { backgroundColor = color }
        }
        
        public var string: String? {
            get { return textView.string }
            set(val) { textView.string = val }
        }
    }
#endif

public class SMarkEditor: MTextView {
    
    
    private var resetRange: NSRange?
    private var firstPageLength = 0
    private var codeBlockRange: [NSRange] = []
    
    deinit { NSNotificationCenter.defaultCenter().removeObserver(self) }
    
    required public init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    public var didRender: DidRender?
    
    @objc private func themeChange() {
        if let color = SMarkParser.shared.theme.backgroundColor { backgroundColor = color }
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
        delegate = self
        autoresizingMask = [NSAutoresizingMaskOptions.ViewWidthSizable, NSAutoresizingMaskOptions.ViewHeightSizable]
        font = SMarkParser.shared.theme.font
        if let color = SMarkParser.shared.theme.foregroundColor {
            textColor = color
            insertionPointColor = color
        }
        
        themeChange()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(SMarkEditor.textChange), name: NSTextDidChangeNotification, object: self)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(SMarkEditor.renderWhenTextChange), name: SMarkParser.Event.themeChange.rawValue, object: nil)
    }
    
    
    
    override public var intrinsicContentSize: NSSize {
        guard let container = textContainer, manager = layoutManager else { return NSZeroSize }
        manager.ensureLayoutForTextContainer(container)
        return manager.usedRectForTextContainer(container).size
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
        font = SMarkParser.shared.theme.font
        if let color = SMarkParser.shared.theme.foregroundColor {
            textColor = color
            tintColor = color
        }
        if let color = SMarkParser.shared.theme.backgroundColor { backgroundColor = color }
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
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(SMarkEditor.renderWhenTextChange), name: SMarkParser.Event.themeChange.rawValue, object: self)
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
        guard let value = rawText, st = smarkTextStorage else { return }
        let r = NSMakeRange(0, firstPageLength)
        let targetLength = value.characters.count
        let maxRange = NSMaxRange(r)
        if maxRange >= targetLength { return }// first page
        let pageSize = 512
        var location = maxRange
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
                for codeRange in self.codeBlockRange {
                    let end = NSMaxRange(range)
                    if end > codeRange.location && end < NSMaxRange(codeRange) {
                        range.length = codeRange.location - range.location
                        break
                    }
                }
                location += range.length
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    SMarkParser.shared.parse(within: st, in: range)
                })
            } while( location < targetLength )
            Swift.print("end:\(CACurrentMediaTime())")
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.invalidateIntrinsicContentSize()
            })
        })
    }
    
    private var rawText: String? {
        get {
            #if os(OSX)
                return string
            #elseif os(iOS)
                return text
            #endif
        }
        set(val) {
            #if os(OSX)
                 string = val
            #elseif os(iOS)
                 text = val
            #endif
        }
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
        let max = value.characters.count
        var r = NSMakeRange(0, min(1000, value.characters.count))
        if r.length != max {
            let sub = (value as NSString).substringWithRange(r)
            let range = (sub as NSString).rangeOfString("\n\n", options: NSStringCompareOptions.BackwardsSearch)
            if range.location != NSNotFound {
                let dealLength = NSMaxRange(range)
                r.length = dealLength
            }
        }
        for range in codeBlockRange {
            let end = NSMaxRange(r)
            if end > range.location && end < NSMaxRange(range) {
                r.length = range.location - r.location
                break
            }
        }
        firstPageLength = r.length
        SMarkParser.shared.parse(within: st, in: r, async: false)
        Swift.print("start:\(CACurrentMediaTime()), total:\(max)")
    }
    
    @objc private func renderWhenTextChange() {
        guard let value = rawText else { return }
        codeBlockRange = SMarkParser.shared.codeBlockRange(of: value)
        themeChange()
        firstPage()
        delayPagedRender()
    }
    
    @objc private func dealText() {
        didRender?(rawText)
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
        SMarkParser.shared.parse(within: st, in: nearestNewLine(of: r))
    }
    
    private func nearestNewLine(of range: NSRange) -> NSRange {
        guard let value = rawText else { return range }
        if NSMaxRange(range) == rawText?.characters.count { return range }
        var range = range
        let sub = (value  as NSString).substringWithRange(range)
        if !sub.hasSuffix("\n\n") {
            var tmpRange = range
            tmpRange.location = range.length
            tmpRange.length = 0
            func nextNewline() -> NSRange {
                tmpRange.length += 10
                let next = (value  as NSString).substringWithRange(tmpRange)
                if next.containsString("\n\n") {
                    let r = (sub as NSString).rangeOfString("\n\n", options: NSStringCompareOptions.BackwardsSearch)
                    if r.location != NSNotFound {
                        let dealLength = NSMaxRange(r)
                        range.length += dealLength
                    }
                    return range
                } else {
                    return nextNewline()
                }
            }
            range = nextNewline()
        }
        return range
    }
    
    @objc private func textChange() {
        let sel = #selector(SMarkEditor.dealText)
        NSObject.cancelPreviousPerformRequestsWithTarget(self, selector: sel, object: nil)
        performSelector(sel, withObject: nil, afterDelay: 0.2)
    }
    
}

#if os(OSX)
    extension SMarkEditor: NSTextViewDelegate {
        
        public override func didChangeText() {
            super.didChangeText()
            reset()
        }
        
        private func reset() {
            if let range = resetRange {
                resetRange = nil
                renderWhenTextChange()
                selectedRange = range
                scrollRangeToVisible(selectedRange)
            }
        }
        
        public func textView(textView: NSTextView, shouldChangeTextInRanges affectedRanges: [NSValue], replacementStrings: [String]?) -> Bool {
            for range in affectedRanges {
                let r = range.rangeValue
                let zeroRange = NSMakeRange(0, 0)
                let maxRangeLocation = NSMaxRange(r)
                let max = rawText?.characters.count ?? 0
                let first = replacementStrings?.first
                let isPasteBorad = NSPasteboard.generalPasteboard().stringForType(NSPasteboardTypeString) == first
                let selectAll = r.location == 0 && r.length == max
                if let replace = first where replace != "" && selectAll && maxRangeLocation != NSMaxRange(zeroRange) {
                   resetRange =  zeroRange
                } else if first != "\n" && first != "" && isPasteBorad {
                    resetRange = NSMakeRange(maxRangeLocation, 0)
                }
            }
            return true
        }
    }
#endif