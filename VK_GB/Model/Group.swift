//
//  Group.swift
//  VK_GB
//
//  Created by Павел Шатунов on 15.08.2022.
//

import Foundation
import RealmSwift

class Community: Object, Codable {
    @objc dynamic var id: Int = 0
    @objc dynamic var name: String = ""
    @objc dynamic var avatar: String = ""
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case avatar = "photo_50"
    }
    override static func primaryKey() -> String? {
        return "id"
    }
    
    override static func indexedProperties() -> [String] {
        return ["name"]
    }
}
