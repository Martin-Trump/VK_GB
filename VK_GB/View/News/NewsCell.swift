//
//  NewsCell.swift
//  VK_GB
//
//  Created by Павел Шатунов on 15.08.2022.
//

import Foundation
import UIKit

class NewsTableViewCell: UITableViewCell {
    
    static let reusedID = "NewsTableViewCell"
    
    let avatarView: UIImageView = {
        let avatarView = UIImageView()
        avatarView.layer.cornerRadius = 15
        avatarView.layer.masksToBounds = true
        avatarView.contentMode = .scaleToFill
        avatarView.translatesAutoresizingMaskIntoConstraints = false
        return avatarView
    }()
    
    let labelCreator: UILabel = {
        let labelCreator = UILabel()
        labelCreator.textColor = #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1)
        labelCreator.translatesAutoresizingMaskIntoConstraints = false
        return labelCreator
    }()
    let dateLabel: UILabel = {
        let dateLabel = UILabel()
        dateLabel.textColor = #colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1)
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        return dateLabel
    }()
    let titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.textColor = #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1)
        titleLabel.numberOfLines = 5
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        return titleLabel
    }()
    let commentButton: UIButton = {
        let commentButton = UIButton()
        commentButton.setImage(UIImage(systemName: "bubble.right"), for: .normal)
        commentButton.translatesAutoresizingMaskIntoConstraints = false
        return commentButton
    }()
    let repostButton: UIButton = {
        let repostButton = UIButton()
        repostButton.setImage(UIImage(systemName: "arrowshape.turn.up.left"), for: .normal)
        repostButton.translatesAutoresizingMaskIntoConstraints = false
        return repostButton
    }()
}
