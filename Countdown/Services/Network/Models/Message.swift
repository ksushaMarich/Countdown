//
//  Message.swift
//  Candy
//
//  Created by Захар Бабкин on 20.01.2024.
//

import Foundation


struct MessageModel: Codable {
    enum Role: String, Codable {
        case user
        case system
    }
    let role: Role
    let content: String
}
