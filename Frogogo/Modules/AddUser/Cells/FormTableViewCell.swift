//
//  FormTableViewCell.swift
//  Frogogo
//
//  Created by Andrey Dovzhenko on 10/26/19.
//  Copyright © 2019 Andrey Dovzhenko. All rights reserved.
//

import UIKit

final class FormTableViewCell: UITableViewCell {

    private let textField = InputTextField().thenUI {
        $0.tintColor = Asset.darkGreen.color
        $0.textColor = Asset.darkGreen.color
    }

    private let lineView = UIView().thenUI {
        $0.alpha = 0.5
        $0.backgroundColor = Asset.lightPinkOpacity.color
    }

    private let validationLabel = UILabel().thenUI {
        $0.textColor = Asset.lightRed.color
        $0.font = UIFont.system(.bold, size: 11)
    }

    private enum InputMode {
        case active
        case inactive
    }

    private var inputMode = InputMode.inactive {
        didSet {
            updatedPlaceholderLabel()
        }
    }

    private var placeholderBottom = NSLayoutConstraint()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        configureLineView()
        configureTextField()
        configureValidationLabel()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    func configure() {
        textField.placeholder = "Почта"
        validationLabel.text = "инкоретк"
    }

    private func configureLineView() {
        addSubview(lineView)
        lineView.height(1).left(25).right(16).bottom(17)
    }

    private func configureValidationLabel() {
        addSubview(validationLabel)
        validationLabel.bottom()
        validationLabel.leadingAnchor ~ lineView.leadingAnchor
        validationLabel.trailingAnchor ~ lineView.trailingAnchor
        validationLabel.topAnchor ~ lineView.topAnchor
    }

    private func configureTextField() {
        textField.delegate = self

        addSubview(textField)
        textField.top()
        textField.leadingAnchor ~ lineView.leadingAnchor
        textField.trailingAnchor ~ lineView.trailingAnchor - 8
        textField.bottomAnchor ~ lineView.topAnchor + 3
    }

    private func updatedPlaceholderLabel() {
        let isActive = inputMode == .active || textField.text?.isEmpty == false
        textField.inputModeUpdated(isActive: isActive)
    }

    private func updateValidation(isValid: Bool) {

        textField.placeholderLabel.textColor = isValid ?
            Asset.greyOpacity.color :
            Asset.lightRed.color

           validationLabel.animateValidation { [weak self] in
               self?.validationLabel.textColor = isValid ? .clear : Asset.greyOpacity.color
           }

           lineView.animateValidation { [weak self] in
               self?.lineView.backgroundColor = isValid ?
                Asset.greyOpacity.color :
                Asset.lightRed.color
               self?.lineView.alpha = isValid ? 0.5 : 1
           }
       }
}

extension FormTableViewCell: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        inputMode = .active
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        inputMode = .inactive
        if textField.text.isNilOrEmpty {
            updateValidation(isValid: true)
        }
    }

    func textField(_ textField: UITextField,
                   shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        if !string.isEmpty, textField.text.isNilOrEmpty && string == " " {
            return true
        }
        textField.text = (textField.text as NSString?)?.replacingCharacters(in: range, with: string)
        textField.sendActions(for: .editingChanged)
        return false
    }

    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return true
    }
}
