//
//  NetworkService.swift
//  Frogogo
//
//  Created by Andrey on 10/27/19.
//  Copyright © 2019 Andrey Dovzhenko. All rights reserved.
//

import Foundation

protocol NetworkServiceProtocol {
    func getUsers(completion: @escaping RequestResult<[User]?, Error?>)
}

final class NetworkService: NetworkServiceProtocol {

    private let provider: RequestProviderProtocol

    init(provider: RequestProviderProtocol) {
        self.provider = provider
    }

    func getUsers(completion: @escaping RequestResult<[User]?, Error?>) {
        provider.request(target: .users, type: [User].self, completion: completion)
    }

}
