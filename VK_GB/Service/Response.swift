//
//  Response.swift
//  VK_GB
//
//  Created by Павел Шатунов on 10.10.2022.
//

import Foundation

class Response<T: Codable>: Codable {
    let response: Items<T>
}

class Items<T: Codable>: Codable {
    let items: [T]
}
