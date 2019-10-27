//
//  FormTableViewCell.swift
//  Frogogo
//
//  Created by Andrey Dovzhenko on 10/26/19.
//  Copyright © 2019 Andrey Dovzhenko. All rights reserved.
//

import UIKit

protocol FormDelegate: class {
    func moveView(keyboardHeight: CGFloat, isShow: Bool)
}

final class FormTableViewCell: UITableViewCell {

    private let textField = InputTextField().thenUI {
        $0.tintColor = Asset.darkGreen.color
        $0.textColor = Asset.darkGreen.color
        $0.keyboardType = .default
        $0.autocorrectionType = .no
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

    private let validationManager = ValidationManager()
    private var inputModel: InputModel?
    private weak var delegate: FormDelegate?
    private var placeholderBottom = NSLayoutConstraint()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        configureLineView()
        configureTextField()
        configureValidationLabel()
        setupNotifications()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    func configure(with item: InputModelProtocol, delegate: FormDelegate?) {
        self.delegate = delegate
        guard let inputModel = item as? InputModel else { return }
        self.inputModel = inputModel
        textField.placeholder = inputModel.placeholderText
        textField.returnKeyType = inputModel.returnKey
        textField.keyboardType = inputModel.keyboardType
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

        textField.addAction(for: .editingChanged) { [weak self] _ in
            let type = self?.inputModel?.formType
            self?.inputModel?.onChange?(type, self?.textField.text)
        }
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

    private func setupNotifications() {
        NotificationCenter.addObserver(self, #selector(keyboardWillShow), NotificationName.keyboardWillShowNotification)
        NotificationCenter.addObserver(self, #selector(keyboardWillShow), NotificationName.keyboardWillHideNotification)
    }

    @objc private func keyboardWillShow(_ notification: Notification) {
        let key = UIResponder.keyboardFrameEndUserInfoKey
        guard let keyboardFrame = notification.userInfo?[key] as? NSValue else { return }
        let isShow = notification.name == NotificationName.keyboardWillShowNotification
        delegate?.moveView(keyboardHeight: keyboardFrame.cgRectValue.height, isShow: isShow)
    }

}

extension FormTableViewCell: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        inputMode = .active
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        inputMode = .inactive
        guard let type = inputModel?.formType else { return }
        let validations = validationManager.performValidation(text: textField.text, type: type)
        if textField.text.isNilOrEmpty {
            updateValidation(isValid: true)
        } else {
            validationLabel.text = validations.error
            updateValidation(isValid: validations.isValid)
        }
    }

    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return true
    }
}
