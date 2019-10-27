//
//  Users.swift
//  Frogogo
//
//  Created by Andrey Dovzhenko on 10/27/19.
//  Copyright © 2019 Andrey Dovzhenko. All rights reserved.
//

import Foundation

struct User: Codable {
    let id: Int
    let firstName: String
    let lastName: String
    let email: String
    let avatar: String?
    let createdAt: String

    private enum CodingKeys: String, CodingKey {
        case id
        case firstName = "first_name"
        case lastName = "last_name"
        case email
        case avatar = "avatar_url"
        case createdAt = "created_at"
    }

    var fullName: String {
        return "\(firstName) \(lastName)"
    }
}

struct UserRequestBody: Codable {
    let firstName: String
    let lastName: String
    let email: String

    private enum CodingKeys: String, CodingKey {
        case firstName = "first_name"
        case lastName = "last_name"
        case email
    }
}
