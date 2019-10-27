//
//  FormUserViewModel.swift
//  Frogogo
//
//  Created by Andrey Dovzhenko on 10/27/19.
//  Copyright © 2019 Andrey Dovzhenko. All rights reserved.
//

import Foundation

protocol FormUserViewModelProtocol {
    var items: [InputModel] { get set }
    var completionHandler: Callback<ErrorValidation>? { get set }

    func addedNewUser()
}

final class FormUserViewModel: FormUserViewModelProtocol {
    var completionHandler: Callback<ErrorValidation>?

    private let form = FormModel()
    private let validationManager = ValidationManager()

    lazy var items: [InputModel] = {
        let onChangeInput: ((InputType?, String?) -> Void) = { [weak form, weak self] type, text in
            form?.fillEvidence(type: type, text: text ?? "")

        }

        var items: [InputModel] = [
            InputModel.firstName(onChange: { onChangeInput($0, $1) }),
            InputModel.lastName(onChange: { onChangeInput($0, $1) }),
            InputModel.email(onChange: { onChangeInput($0, $1) }),
            InputModel.urlAvatar(onChange: { onChangeInput($0, $1) })
        ]

        return items
    }()

    func addedNewUser() {
        execute()
    }

    private func execute() {
        do {
            try validationManager.supportValidationAddNewUser(form: form)
            saveNewUser()
        } catch ErrorValidation.incorrectEmail {
            completionHandler?(.incorrectEmail)
        } catch {
            completionHandler?(.emptyFields)
        }
    }

    private func saveNewUser() {

    }
}
