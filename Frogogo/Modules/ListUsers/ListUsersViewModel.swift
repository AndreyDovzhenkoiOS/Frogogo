//
//  ListUsersViewModel.swift
//  Frogogo
//
//  Created by Andrey Dovzhenko on 10/26/19.
//  Copyright © 2019 Andrey Dovzhenko. All rights reserved.
//

import Foundation

enum ListUsersViewModelType {
    case update, error
}

protocol ListUsersViewModelProtocol {
    var users: [User]? { get set }
    var completionHandler: Callback<ListUsersViewModelType>? { get set }

    func requestGetUsers()
}

final class ListUsersViewModel: ListUsersViewModelProtocol {
    var users: [User]?
    var completionHandler: Callback<ListUsersViewModelType>?

    private let service: NetworkService

    init(service: NetworkService) {
        self.service = service
    }

    func handlerRequestUsers(users: [User]?) {
        self.users = users
        completionHandler?(.update)
    }
}

extension ListUsersViewModel {
    func requestGetUsers() {
        service.getUsers { [weak self] in
            guard $1 == nil else {
                self?.completionHandler?(.error)
                return
            }
            self?.handlerRequestUsers(users: $0)
        }
    }
}
