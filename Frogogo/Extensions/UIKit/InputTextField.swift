//
//  InputTextField.swift
//  Frogogo
//
//  Created by Andrey Dovzhenko on 10/27/19.
//  Copyright © 2019 Andrey Dovzhenko. All rights reserved.
//

import UIKit

class InputTextField: UITextField {
    private enum Constants {
        static let scaleCoeff: CGFloat = 0.75
    }

    var placeholderCenter: CGFloat = 0

    var placeholderLabel = UILabel(frame: .zero)

    override open func drawPlaceholder(in rect: CGRect) {
        super.drawPlaceholder(in: rect)
        guard let font = font else { return }
        configurePlaceholderLabel(rect: rect, font: font)
    }

    private func configurePlaceholderLabel(rect: CGRect, font: UIFont) {
        placeholderLabel.frame = CGRect(x: rect.origin.x, y: 2, width: rect.width, height: font.pointSize)
        placeholderLabel.center = CGPoint(x: placeholderLabel.center.x,
                                          y: frame.height - placeholderLabel.frame.height / 2 - 10)
        placeholderLabel.text = placeholder
        placeholder = nil

        placeholderLabel.font = UIFont(name: font.fontName, size: font.pointSize)

        placeholderLabel.textColor = Asset.greyOpacity.color
        placeholderLabel.alpha = 0.5

        placeholderCenter = placeholderLabel.center.x * Constants.scaleCoeff

        addSubview(placeholderLabel)
        bringSubviewToFront(placeholderLabel)
    }

    override open func textRect(forBounds bounds: CGRect) -> CGRect {
        textAlignment = .left
        contentVerticalAlignment = .bottom
        return bounds.insetBy(dx: 1.5, dy: 4)
    }

    func inputModeUpdated(isActive: Bool) {
        if isActive {
            active()
        } else {
            inactive()
        }
    }

    override open func editingRect(forBounds bounds: CGRect) -> CGRect {
        textAlignment = .left
        contentVerticalAlignment = .bottom
        return bounds.insetBy(dx: 1.5, dy: 4)
    }

    private func active() {
        let centerX = max(placeholderCenter, placeholderLabel.center.x * Constants.scaleCoeff)
        let center = CGPoint(x: centerX, y: placeholderLabel.frame.height)
        animatePlaceholder(with: center, scale: Constants.scaleCoeff, alpha: 0.85)
    }

    private func inactive() {
        if text?.isEmpty == true {
            let centerX = min(placeholderCenter / Constants.scaleCoeff,
                              placeholderLabel.center.x / Constants.scaleCoeff)
            let centerY = frame.height - (placeholderLabel.frame.height / 2) - 10
            animatePlaceholder(with: CGPoint(x: centerX, y: centerY), scale: 1, alpha: 0.5)
        }
    }

    private func animatePlaceholder(with center: CGPoint, scale: CGFloat, alpha: CGFloat) {
        UIView.animate(withDuration: 0.35, animations: {
            self.placeholderLabel.transform(with: scale, center: center)
            self.placeholderLabel.alpha = alpha
        })
    }
}
