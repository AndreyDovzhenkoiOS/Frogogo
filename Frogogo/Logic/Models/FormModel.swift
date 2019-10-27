//
//  FormModel.swift
//  Frogogo
//
//  Created by Andrey Dovzhenko on 10/27/19.
//  Copyright © 2019 Andrey Dovzhenko. All rights reserved.
//

import Foundation

class FormModel {
    var firstName: String
    var lastName: String
    var email: String
    var usrlAvatar: String?

    init(firstName: String = String(),
         lastName: String = String(),
         email: String = String(),
         usrlAvatar: String? = nil) {
        self.firstName = firstName
        self.lastName = lastName
        self.email = email
        self.usrlAvatar = usrlAvatar
    }

    var isFillAllFields: Bool {
        return !firstName.isEmpty && !lastName.isEmpty && !email.isEmpty
    }

    var userRequestBody: UserRequestBody {
        return UserRequestBody(firstName: firstName,
                               lastName: lastName,
                               email: email)
    }
    func fillEvidence(type: InputType?, text: String) {
        switch type {
        case .firstName?:
            firstName = text
        case .lastName?:
            lastName = text
        case .email?:
            email = text
        case .usrlAvatar?:
            usrlAvatar = text
        default:
            break
        }
    }
}
