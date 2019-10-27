//
//  ViewControllerAssembly.swift
//  Frogogo
//
//  Created by Andrey Dovzhenko on 10/27/19.
//  Copyright © 2019 Andrey Dovzhenko. All rights reserved.
//

import UIKit

enum ViewControllerType {
    case listUsers
    case formUser
}

struct ViewControllerAssembly {
    static func resolve(type: ViewControllerType, callback: VoidCallback? = nil) -> UIViewController {
        switch type {
        case .listUsers:
            let service = NetworkService(provider: RequestProvider())
            let viewModel = ListUsersViewModel(service: service)
            return ListUsersViewController(viewModel: viewModel)
        case .formUser:
            let service = NetworkService(provider: RequestProvider())
            let viewModel = FormUserViewModel(service: service)
            viewModel.callBackSuccess = callback
            return FormUserViewController(viewModel: viewModel)
        }
    }
}
