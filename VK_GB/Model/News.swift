//
//  News.swift
//  VK_GB
//
//  Created by Павел Шатунов on 15.08.2022.
//

import Foundation

//struct NewsModel: Codable {
//    let postID: Int
//    let text: String
//    let date: Double
//    let attachments: [Attachment]?
//    let likes: Like
//    let comments: Comment
//    let sourceID: Int
//    var avatarURL: String?
//    var creatorName: String?
//    var photosURL: [String]? {
//        get {
//            let photosURL = attachments?.compactMap{ $0.photo?.sizes?.last?.url }
//            return photosURL
//        }
//    }
//    enum CodingKeys: String, CodingKey {
//        case postID = "post_id"
//        case text
//        case date
//        case likes
//        case comments
//        case attachments
//        case sourceID = "source_id"
//        case avatarURL
//        case creatorName
//    }
//    
//    
//}
//struct Attachment: Codable {
//    let type: String?
//    let photo: Photo?
//}
//struct Like: Codable {
//    let count: Int
//}
//struct Comment: Codable {
//    let count: Int
//}
