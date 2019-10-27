//
//  AlertModel.swift
//  Frogogo
//
//  Created by Andrey Dovzhenko on 10/27/19.
//  Copyright © 2019 Andrey Dovzhenko. All rights reserved.
//

import Foundation

struct AlertModel {
    let title: String
    let description: String
    let titleAction: String
    let isError: Bool

    static var incorrectEmail: AlertModel {
        return AlertModel(title: Localized.Alert.titleError,
                          description: Localized.FormUser.errorEmail,
                          titleAction: Localized.Alert.titleActionUnderstand,
                          isError: true)
    }

    static var emptyFields: AlertModel {
        return AlertModel(title: Localized.Alert.titleError,
                          description: Localized.FormUser.errorEmptyFields,
                          titleAction: Localized.Error.server,
                          isError: true)
    }

    static var somethingWentWrong: AlertModel {
        return AlertModel(title: Localized.Alert.titleError,
                          description: Localized.Error.server,
                          titleAction: Localized.Alert.titleActionUnderstand,
                          isError: true)
    }

    static var successAdd: AlertModel {
        return AlertModel(title: Localized.Alert.titleSuccess,
                          description: Localized.FormUser.successAdd,
                          titleAction: Localized.Alert.titleSuccess,
                          isError: false)
    }

    static var successEdit: AlertModel {
        return AlertModel(title: Localized.Alert.titleSuccess,
                          description: Localized.FormUser.successEdit,
                          titleAction: Localized.Alert.titleSuccess,
                          isError: false)
    }
}
