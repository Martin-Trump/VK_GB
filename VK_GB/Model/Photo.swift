//
//  Photo.swift
//  VK_GB
//
//  Created by Павел Шатунов on 15.08.2022.
//

import Foundation


class PhotoItem: Codable {
    var id: Int = 0
    var ownerID: Int = 0
    var sizes =  [Size]()
    
    enum CodingKeys: String, CodingKey {
        case id
        case ownerID = "owner_id"
        case sizes
    }
    
    
}

class Size: Codable {
     var type: String = ""
     var url: String = ""
}

