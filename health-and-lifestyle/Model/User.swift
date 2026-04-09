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
    var highestUnlockedPlanetIndex: Int

    init(id: String, fullname: String, email: String, highestUnlockedPlanetIndex: Int = 0) {
        self.id = id
        self.fullname = fullname
        self.email = email
        self.highestUnlockedPlanetIndex = highestUnlockedPlanetIndex
    }

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
        case highestUnlockedPlanetIndex
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        fullname = try container.decode(String.self, forKey: .fullname)
        email = try container.decode(String.self, forKey: .email)
        highestUnlockedPlanetIndex = try container.decodeIfPresent(Int.self, forKey: .highestUnlockedPlanetIndex) ?? 0
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(fullname, forKey: .fullname)
        try container.encode(email, forKey: .email)
        try container.encode(highestUnlockedPlanetIndex, forKey: .highestUnlockedPlanetIndex)
    }
}

extension User {
    static var MOCK_USER = User(id: NSUUID().uuidString, fullname: "Jarvin Siegers", email: "jarvin123@gmail.com")
}
