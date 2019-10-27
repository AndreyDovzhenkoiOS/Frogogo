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
}

final class FormUserViewModel: FormUserViewModelProtocol {
    private let form = FormModel()

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
}
