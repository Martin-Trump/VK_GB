//
//  NewsInteractor.swift
//  VK_GB
//
//  Created by Павел Шатунов on 28.10.2022.
//

import Foundation
import UIKit

protocol NewsInteractorProtocol: AnyObject {
    func makeRequest(type: Newsfeed.Model.Request.RequestType )
}

class NewsInteractor: NewsInteractorProtocol {
    var network: NewsService?
    var presenter: NewsPresenterProtocol?
    
    
    func makeRequest(type: Newsfeed.Model.Request.RequestType) {
        if network == nil {
            self.network = NewsService()
        }
        switch type {
        case .getNewsfeed:
            network?.getNews(completion: { [weak self] (revealed, feed) in
                self?.presenter?.displayNews(response: Newsfeed.Model.Response.ResponseType.presentNewsfeed(feed: feed, revealdedPostIds: revealed))
            })
        case .revealPostIds(let postId):
            network?.revealPost(postId: postId, completion: { [weak self] revealed, feed in
                self?.presenter?.displayNews(response: Newsfeed.Model.Response.ResponseType.presentNewsfeed(feed: feed, revealdedPostIds: revealed))
            })
        
        case .getNextBatch:
            self.presenter?.displayNews(response: Newsfeed.Model.Response.ResponseType.presentFooterLoader)
            network?.getNext(completion: { [weak self] revealed, feed in
                self?.presenter?.displayNews(response: Newsfeed.Model.Response.ResponseType.presentNewsfeed(feed: feed, revealdedPostIds: revealed))
            })
        }
    }
}
