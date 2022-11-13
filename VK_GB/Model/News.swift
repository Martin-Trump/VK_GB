//
//  News.swift
//  VK_GB
//
//  Created by Павел Шатунов on 15.08.2022.
//

import Foundation

enum Newsfeed {

    enum Model {
        struct Request {
            enum RequestType {
                case getNewsfeed
                //case getUser
                case revealPostIds(postId: Int)
                case getNextBatch
            }
        }
        struct Response {
            enum ResponseType {
                case presentNewsfeed(feed: FeedResponse, revealdedPostIds: [Int])
                //case presentUserInfo(user: UserResponse?)
                case presentFooterLoader
            }
        }
        struct ViewModel {
            enum ViewModelData {
                case displayNewsfeed(feedViewModel: FeedViewModel)
                //case displayUser(userViewModel: UserViewModel)
                case displayFooterLoader
            }
        }
    }
}

//struct UserViewModel: TitleViewViewModel {
//    var photoUrlString: String?
//    var name: String
//}

struct FeedViewModel {
    struct Cell: FeedCellViewModel {
        var postId: Int

        var iconUrlString: String
        var name: String
        var date: String
        var text: String?
        var likes: String?
        var comments: String?
        var shares: String?
        var views: String?
        var photoAttachements: [FeedCellPhotoAttachementViewModel]
        var sizes: FeedCellSizes
    }

    struct FeedCellPhotoAttachment: FeedCellPhotoAttachementViewModel {
        var photoUrlString: String?
        var width: Int
        var height: Int
    }
    let cells: [Cell]
    let footerTitle: String?
}
