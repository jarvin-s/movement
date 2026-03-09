//
//  User.swift
//  health-and-lifestyle
//
//  Created by Jarvin Siegers on 26/02/2026.
//

import Foundation

struct User: Identifiable, Codable {
    let id: String
    let fullname: String
    let email: String

    var initials: String {
        let formatter = PersonNameComponentsFormatter()
        if let components = formatter.personNameComponents(from: fullname) {
            formatter.style = .abbreviated
            return formatter.string(from: components)
        }
        return ""
    }

    enum CodingKeys: String, CodingKey {
        case id
        case fullname
        case email
    }
}

extension User {
    static var MOCK_USER = User(id: NSUUID().uuidString, fullname: "Jarvin Siegers", email: "jarvin123@gmail.com")
}
