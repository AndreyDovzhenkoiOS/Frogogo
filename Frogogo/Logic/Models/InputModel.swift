//
//  InputModel.swift
//  Frogogo
//
//  Created by Andrey Dovzhenko on 10/27/19.
//  Copyright © 2019 Andrey Dovzhenko. All rights reserved.
//

import UIKit

protocol InputModelProtocol {
    var type: InputModelType { get }
    var formType: InputType? { get }
}

enum InputModelType {
    case formUser
}

enum InputType {
    case firstName, lastName, email, usrlAvatar
}

final class InputModel: InputModelProtocol {
    let placeholderText: String?
    let onChange: FormCallback<InputType?, String?>?
    let returnKey: UIReturnKeyType
    let keyboardType: UIKeyboardType
    let type: InputModelType = .formUser
    let formType: InputType?
    var text: String?

    init(
        placeholderText: String? = nil,
        onChange: FormCallback<InputType?, String?>? = nil,
        returnKey: UIReturnKeyType = .done,
        keyboardType: UIKeyboardType = .default,
        formType: InputType? = nil,
        text: String? = nil
    ) {
        self.placeholderText = placeholderText
        self.keyboardType = keyboardType
        self.returnKey = returnKey
        self.onChange = onChange
        self.formType = formType
        self.text = text
    }

    static func firstName(onChange: FormCallback<InputType?, String?>? = nil) -> InputModel {
        return InputModel(placeholderText: Localized.FormUser.Input.firstName,
                          onChange: onChange,
                          formType: .firstName)
    }

    static func lastName(onChange: FormCallback<InputType?, String?>? = nil) -> InputModel {
        return InputModel(placeholderText: Localized.FormUser.Input.lastName,
                          onChange: onChange,
                          formType: .lastName)
    }

    static func email(onChange: FormCallback<InputType?, String?>? = nil) -> InputModel {
        return InputModel(placeholderText: Localized.FormUser.Input.email,
                          onChange: onChange,
                          keyboardType: .emailAddress,
                          formType: .email)
       }

    static func urlAvatar(onChange: FormCallback<InputType?, String?>? = nil) -> InputModel {
        return InputModel(placeholderText: Localized.FormUser.Input.urlAvatar,
                          onChange: onChange,
                          formType: .usrlAvatar)
    }
}
