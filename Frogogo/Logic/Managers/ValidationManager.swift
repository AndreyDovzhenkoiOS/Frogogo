//
//  ValidationManager.swift
//  Frogogo
//
//  Created by Andrey Dovzhenko on 10/27/19.
//  Copyright © 2019 Andrey Dovzhenko. All rights reserved.
//

import Foundation

struct ValidationManager {

    func performValidation(text: String?, type: InputType) -> (error: String?, isValid: Bool) {
         switch type {
         case .email:
             guard isEmailValid(email: text) else {
                return (Localized.FormUser.Validation.errorEmail, false)
             }
         case .usrlAvatar:
            guard isUrlValid(url: text) else {
               return (Localized.FormUser.Validation.errorUrl, false)
            }
         default:
            break
         }
         return (nil, true)
     }

    private func isEmailValid(email: String?) -> Bool {
        let paramaters = "([A-Z0-9a-z!#$%&'*+-/=?^_`{|}~();:<>/,№.\"]){1,}"
        let emailParameters = paramaters + "@" + paramaters + "\\." + paramaters
        return isValid(email, validationString: emailParameters)
    }

    private func isUrlValid(url: String?) -> Bool {
        let paramaters = "((https|http)://)((\\w|-)+)(([.]|[/])((\\w|-)+))+"
        return isValid(url, validationString: paramaters)
    }

    private func isValid(_ text: String?, validationString: String) -> Bool {
        return NSPredicate(format: "SELF MATCHES %@", validationString).evaluate(with: text)
    }
}
