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
}

extension RequestTarget {
    enum HTTPMethod: String {
        case get, post, put, delete
    }

    var path: String {
        switch self {
        case .users:
            return "/users.json"
        }
    }

    var method: HTTPMethod {
        switch self {
        case .users:
            return .get
        }
    }

    var parameters: [String: String]? {
        switch self {
        default:
            return nil
        }
    }
}
