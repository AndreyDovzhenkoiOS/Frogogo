//
//  RequestTarget.swift
//  Frogogo
//
//  Created by Andrey Dovzhenko on 10/27/19.
//  Copyright © 2019 Andrey Dovzhenko. All rights reserved.
//

import Foundation

enum RequestTarget {
    case users
    case addUser(UserRequestBody)
    case editUser(Int, UserRequestBody)
}

extension RequestTarget {
    enum HTTPMethod: String {
        case get, post, patch
    }

    var path: String {
        switch self {
        case .users, .addUser:
            return "/users.json"
        case let .editUser(id, _):
            return "/users/\(id).json"
        }
    }

    var method: HTTPMethod {
        switch self {
        case .users:
            return .get
        case .addUser:
            return .post
        case .editUser:
            return .patch
        }
    }

    func httpBody() throws -> Data? {
        switch self {
        case let .addUser(payload):
            return try encode(payload)
        case let .editUser(_, payload):
              return try encode(payload)
        default:
            return nil
        }
    }

    private func encode<T: Encodable>(_ json: T) throws -> Data {
        return try JSONEncoder().encode(json)
    }
}
