//
//  Group.swift
//  VK_GB
//
//  Created by Павел Шатунов on 15.08.2022.
//

import Foundation

class Community: Codable {
    let id: Int
    let name: String
    let avatar: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case avatar = "photo_50"
    }
}
