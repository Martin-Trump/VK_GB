//
//  Session.swift
//  VK_GB
//
//  Created by Павел Шатунов on 01.08.2022.
//

import Foundation

class Session {
    static let shared = Session()
    
    var token: String?
    var userId: Int?
    
    private init() {}
}
