//
//  KeyActionLabel.swift
//  Label 關鍵字觸發動作
//  Created by 陳彥辰 on 2017/1/17.
//  Copyright © 2017年 RayMini. All rights reserved.
//

import UIKit

//計算觸碰得位置
extension UIGestureRecognizer {
    func indexOfCharacterTouched(label: UILabel) -> Int? {
        guard label.attributedText != nil else {
            return nil
        }
        //Create instances of NSLayoutManager, NSTextContainer and NSTextStorage
        let layoutManager = NSLayoutManager()
        let textContainer = NSTextContainer(size: CGSize.zero)
        let textStorage = NSTextStorage(attributedString: label.attributedText!)
        //Configure layoutManager and textStorage
        layoutManager.addTextContainer(textContainer)
        textStorage.addLayoutManager(layoutManager)
        
        //Configure textContainer
        textContainer.lineFragmentPadding = 0
        textContainer.lineBreakMode = label.lineBreakMode
        textContainer.maximumNumberOfLines = label.numberOfLines
        textContainer.size = label.bounds.size
        
        let locationOfTouchInLabel = self.location(in: label)
        let textBoundingBox = layoutManager.usedRect(for: textContainer)
        let textContainerOffset = CGPoint(x: (label.bounds.size.width - textBoundingBox.size.width) * 0.5 - textBoundingBox.origin.x, y: (label.bounds.size.height - textBoundingBox.size.height) * 0.5 - textBoundingBox.origin.y)
        
        let locationOfTouchInTextContainer = CGPoint(x: locationOfTouchInLabel.x - textContainerOffset.x, y: locationOfTouchInLabel.y - textContainerOffset.y)
//        let locationOfTouchInTextContainer = CGPoint(
//            x: locationOfTouchInLabel.x,
//            y: locationOfTouchInLabel.y)

        let indexOfCharacter = layoutManager.characterIndex(
            for: locationOfTouchInTextContainer,
            in: textContainer,
            fractionOfDistanceBetweenInsertionPoints: nil)
        
        return indexOfCharacter
    }
}

// Label 關鍵字觸發 Action
class KeyActionLabel: UILabel, UIGestureRecognizerDelegate {
    
    private var rangeArray:[NSRange] = []
    private var keywordArray: [String] = []
    private var handler:((_ index: Int) -> Void)?
    
    
    func creatTabAction(title: String, fontSize: CGFloat, color: UIColor, keyword: [String], keywordColor: UIColor, handler: ((_ index: Int) -> Void)?) {
        var text = title
        self.handler = handler
        for i in 0..<keyword.count {
            while let range = text.range(of: keyword[i]) {
                let lineRange = (text as NSString).range(of: keyword[i])
                self.rangeArray.append(lineRange)
                
                var withTitle: String = ""
                for _ in 0..<keyword[i].characters.count {
                    withTitle = withTitle + "|"
                }
                text = text.replacingCharacters(in: range, with: withTitle)
            }
            self.attributedText = self.creatDifferentAttributed(title: title + " ", fontSize: fontSize, color: color, rangeColor: keywordColor)
        }
        
        for i in 0..<self.rangeArray.count {
            for j in i+1..<self.rangeArray.count {
                if self.rangeArray[j].location < self.rangeArray[i].location {
                    let value = self.rangeArray[j]
                    self.rangeArray.remove(at: j)
                    self.rangeArray.insert(value, at: i)
                }
            }
        }
        
        
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(respondToLinkLabelTapped(_:)))
        tapGestureRecognizer.delegate = self
        self.isUserInteractionEnabled = true
        self.addGestureRecognizer(tapGestureRecognizer)
    }
    
    private func creatDifferentAttributed(title: String, fontSize: CGFloat, color: UIColor, rangeColor: UIColor) -> NSAttributedString? {
        let attrs = [NSFontAttributeName: UIFont.systemFont(ofSize: fontSize),
                     NSForegroundColorAttributeName: color]
        let str = NSMutableAttributedString(string: title, attributes: attrs)
        for i in 0..<self.rangeArray.count {
            // 變更顏色
            str.addAttribute(NSForegroundColorAttributeName, value: rangeColor, range: self.rangeArray[i])
            // 下底線
            str.addAttribute(NSUnderlineStyleAttributeName, value: NSUnderlineStyle.styleSingle.rawValue, range: self.rangeArray[i])
        }
        
        return str
    }
    // 點擊觸碰到哪一個
    @objc private func respondToLinkLabelTapped(_ gestureRecognizer: UITapGestureRecognizer) {
        let indexOfCharacterTouched = gestureRecognizer.indexOfCharacterTouched(label: self)
        if indexOfCharacterTouched != nil {
            for i in 0..<self.rangeArray.count {
                if indexOfCharacterTouched! >= self.rangeArray[i].location &&
                    indexOfCharacterTouched! <= self.rangeArray[i].location + self.rangeArray[i].length {
                    if let tap = self.handler {
                        tap(i)
                    }
                }
            }
        }
    }
}
