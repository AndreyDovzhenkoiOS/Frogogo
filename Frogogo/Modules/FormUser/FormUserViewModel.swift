//
//  FormUserViewModel.swift
//  Frogogo
//
//  Created by Andrey Dovzhenko on 10/27/19.
//  Copyright © 2019 Andrey Dovzhenko. All rights reserved.
//

import Foundation

enum StateForm: Error {
    case emptyFields
    case incorrectEmail
    case somethingWentWrong
    case successAdd
    case successEdit
}

protocol FormUserViewModelProtocol {
    var form: FormModel { get set }
    var user: User? { get set }
    var items: [InputModel] { get set }
    var currentState: StateForm? { get set }

    var completionHandler: Callback<StateForm>? { get set }
    var callBackSuccess: VoidCallback? { get set }

    func addedNewUser()
}

final class FormUserViewModel: FormUserViewModelProtocol {

    var user: User? {
        didSet {
            if let user = user {
                form.update(with: user)
            }
        }
    }

    var currentState: StateForm?
    var callBackSuccess: VoidCallback?
    var completionHandler: Callback<StateForm>?

    private let service: NetworkService
    var form = FormModel()
    private let validationManager = ValidationManager()

    init(service: NetworkService) {
        self.service = service
    }

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
        guard let user = user else {
            requestAddUser()
            return
        }
        requestEditUser(id: user.id)
    }
}

extension FormUserViewModel {
    private func requestAddUser() {
        service.addUser(requestBody: form.userRequestBody) { [weak self] result, error in
            guard error == nil else {
                self?.completionHandler?(.somethingWentWrong)
                return
            }
            guard result == nil else {
                self?.completionHandler?(.successAdd)
                return
            }
        }
    }

    func requestEditUser(id: Int) {
        service.editUser(id: id, requestBody: form.userRequestBody) { [weak self] result, error in
            guard error == nil else {
                self?.completionHandler?(.somethingWentWrong)
                return
            }
            guard result == nil else {
                self?.completionHandler?(.successEdit)
                return
            }
        }
    }
}
