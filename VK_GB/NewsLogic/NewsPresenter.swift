//
//  NewsPresenter.swift
//  VK_GB
//
//  Created by Павел Шатунов on 28.10.2022.
//

import Foundation
import UIKit

protocol NewsPresenterProtocol {
    func displayNews(response: Newsfeed.Model.Response.ResponseType)
}

class NewsPresenter: NewsPresenterProtocol {
    weak var viewController: NewsDisplayLogic?
    var layoutCalc: FeedCellLayoutCalculatorProtocol = FeedCellLayoutCalculator()
    
    func displayNews(response: Newsfeed.Model.Response.ResponseType) {
        switch response {
        case .presentNewsfeed(let feed, let revealed):
            let cells = feed.items.map { feedItem in
                
                cellViewModel(feedItem: feedItem, profiles: feed.profiles, groups: feed.groups, revealedPost: revealed)
            }
            let footerTitle = String.localizedStringWithFormat(NSLocalizedString("newsfeed cells count", comment: ""), cells.count)
            let feedViewModel = FeedViewModel.init(cells: cells, footerTitle: footerTitle)
            viewController?.displayData(data: Newsfeed.Model.ViewModel.ViewModelData.displayNewsfeed(feedViewModel: feedViewModel))
        case .presentFooterLoader:
            viewController?.displayData(data: Newsfeed.Model.ViewModel.ViewModelData.displayFooterLoader)
        
        }
    }
    
    let dateFormatter: DateFormatter = {
       var dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ru_RU")
        dateFormatter.dateFormat = "d MMM 'в' HH:mm"
        return dateFormatter
    }()
    
    
    private func cellViewModel(feedItem: FeedItem, profiles: [Profile], groups: [Community], revealedPost: [Int]) -> FeedViewModel.Cell {
        let profile = self.profile(sourceId: feedItem.sourceId, profile: profiles, groups: groups)
        
        let photoAttachment = self.photoAttachment(feedItem: feedItem)
        
        let date = Date(timeIntervalSince1970: feedItem.date)
        let dateTitle = dateFormatter.string(from: date)
        
        let isFullSized = revealedPost.contains {postId -> Bool in
            postId == feedItem.postId
        }
        
        let textPost = feedItem.text?.replacingOccurrences(of: "<br>", with: "\n")
        
        let size = layoutCalc.sizes(postText: feedItem.text, photoAttachments: photoAttachment, isFullSizedPost: isFullSized)
        
        return FeedViewModel.Cell.init(postId: feedItem.postId, iconUrlString: profile.photo, name: profile.name, date: dateTitle, text: textPost, likes: formattedCounter(feedItem.likes?.count), comments: formattedCounter(feedItem.comments?.count), shares: formattedCounter(feedItem.reposts?.count), views: formattedCounter(feedItem.views?.count), photoAttachements: photoAttachment, sizes: size)
    }
    
    private func formattedCounter(_ counter: Int?) -> String? {
        guard let counter = counter, counter > 0 else {return nil}
        var counterString = String(counter)
        if 4...6 ~= counterString.count {
            counterString = String(counterString.dropLast(3)) + "K"
        } else if counterString.count > 6 {
            counterString = String(counterString.dropLast(6)) + "M"
        }
        return counterString
    }
    
    private func profile(sourceId: Int, profile: [Profile], groups: [Community]) -> ProfileRepresentable {
        let groupORprofile: [ProfileRepresentable] = sourceId >= 0 ? profile : groups
        let normalSourceId = sourceId >= 0 ? sourceId : -sourceId
        let profileRepresentable = groupORprofile.first { $0.id == normalSourceId }
        return profileRepresentable!
    }
    
    private func photoAttachment(feedItem: FeedItem) -> [FeedViewModel.FeedCellPhotoAttachment] {
        guard let attachments = feedItem.attachments else {return []}
        
        return attachments.compactMap({ (attachment) -> FeedViewModel.FeedCellPhotoAttachment? in
                   guard let photo = attachment.photo else { return nil }
                   return FeedViewModel.FeedCellPhotoAttachment.init(photoUrlString: photo.srcBIG,
                                                                     width: photo.width,
                                                                     height: photo.height)
        })
    }
}

