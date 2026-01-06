//
//  CountdownButton.swift
//  StrayScanner
//
//  Created by Himanshu on 1/6/26.
//  Copyright © 2026 Stray Robots. All rights reserved.
//

import UIKit

@IBDesignable
class CountdownLabel : UILabel {
    @IBInspectable var topInset: CGFloat = 6
    @IBInspectable var bottomInset: CGFloat = 6
    @IBInspectable var leftInset: CGFloat = 12
    @IBInspectable var rightInset: CGFloat = 12
    
    @IBInspectable var borderWidthValue: CGFloat = 3.0 {
        didSet { layer.borderWidth = borderWidthValue }
    }
    
    @IBInspectable var borderColorValue: UIColor = UIColor(named: "DarkColor")! {
        didSet { layer.borderColor = borderColorValue.cgColor }
    }
    
    override func drawText(in rect: CGRect) {
        let insets = UIEdgeInsets(
            top: topInset,
            left: leftInset,
            bottom: bottomInset,
            right: rightInset
        )
        super.drawText(in: rect.inset(by: insets))
    }
    
    override var intrinsicContentSize: CGSize {
        let size = super.intrinsicContentSize
        return CGSize(
            width: size.width + leftInset + rightInset,
            height: size.height + topInset + bottomInset
        )
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()

        // Dynamic pill shape
        layer.cornerRadius = bounds.height / 2
        layer.borderWidth = borderWidthValue
        layer.borderColor = borderColorValue.cgColor
        clipsToBounds = true
    }
}
