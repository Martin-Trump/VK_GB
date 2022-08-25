//
//  Friend.swift
//  VK_GB
//
//  Created by Павел Шатунов on 15.08.2022.
//

import Foundation

struct Friend: Codable {
    let firstName: String
    let lastName: String
    let avatar: String
    
    enum CodingKeys: String, CodingKey {
        case firstName = "first_name"
        case lastName = "last_name"
        case avatar = "photo_50"
    }
}
