//
//  NewsService.swift
//  VK_GB
//
//  Created by Павел Шатунов on 28.10.2022.
//

import Foundation

class NewsService {
    
    private var revealedPost = [Int]()
    private var feedResponse: FeedResponse?
    private var newFrom: String?
    let network = NetworkService()
    
    func getNews(completion: @escaping([Int], FeedResponse) -> Void) {
        network.getNewsFeed(nextBatchFrom: nil) { feed in
            self.feedResponse = feed
            guard let feedResponse = self.feedResponse else {
                return
            }
            completion(self.revealedPost, feedResponse)
        }
    }
    
    func revealPost(postId: Int, completion: @escaping([Int], FeedResponse) -> Void) {
        revealedPost.append(postId)
        guard let feedResponse = self.feedResponse else {
            return
        }
        completion(revealedPost, feedResponse)
    }
    
    func getNext(completion: @escaping ([Int], FeedResponse) -> Void) {
        newFrom = feedResponse?.nextFrom
        network.getNewsFeed(nextBatchFrom: newFrom) { [weak self] feed in
            guard let feed = feed else {return}
            guard self?.feedResponse?.nextFrom != feed.nextFrom else {return}
            
            if self?.feedResponse == nil {
                self?.feedResponse = feed
            } else {
                self?.feedResponse?.items.append(contentsOf: feed.items)
            }
            var profiles = feed.profiles
            if let oldProfiles = self?.feedResponse?.profiles {
                let oldProfilesFiltered = oldProfiles.filter({oldProfile -> Bool in
                    !feed.profiles.contains(where: {$0.id == oldProfile.id})
                })
                profiles.append(contentsOf: oldProfilesFiltered)
            }
            var groups = feed.groups
            if let oldGroups = self?.feedResponse?.groups {
                let oldGroupsFiltered = oldGroups.filter({oldGroup -> Bool in
                    !feed.groups.contains(where: {$0.id == oldGroup.id})
                })
                groups.append(contentsOf: oldGroupsFiltered)
            }
            self?.feedResponse?.groups = groups
            self?.feedResponse?.nextFrom = feed.nextFrom
            
        }
        guard let feedResponse = self.feedResponse else { return }
            completion(self.revealedPost, feedResponse)
    }
}



