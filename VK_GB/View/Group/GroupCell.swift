//
//  GroupCell.swift
//  VK_GB
//
//  Created by Павел Шатунов on 15.08.2022.
//

import Foundation
import UIKit

class GroupCell: UITableViewCell {
    var networkService = NetworkService()
    
    private var avatarImage = UIImageView()
    private var nameField   = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(avatarImage)
        addSubview(nameField)
        configureAvatar()
        configureNameField()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func set(group: Group) {
        networkService.loadImage(url: group.photo) { image, error in
            self.avatarImage.image = image
        }
        nameField.text = group.name
    }
        

    
    func configureAvatar() {
        avatarImage.translatesAutoresizingMaskIntoConstraints = false
        avatarImage.layer.cornerRadius = 20
        avatarImage.clipsToBounds = true
        avatarImage.contentMode = .scaleAspectFit
        NSLayoutConstraint.activate([
            avatarImage.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 20),
            avatarImage.centerYAnchor.constraint(equalTo: centerYAnchor),
            avatarImage.heightAnchor.constraint(equalToConstant: 40),
            avatarImage.widthAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    func configureNameField() {
        nameField.translatesAutoresizingMaskIntoConstraints = false
        nameField.numberOfLines = 0
        nameField.adjustsFontSizeToFitWidth = false
        nameField.font = UIFont(name: "Andale Mono", size: 15)
        NSLayoutConstraint.activate([
            nameField.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            nameField.leftAnchor.constraint(equalTo: avatarImage.rightAnchor, constant: 30),
            nameField.heightAnchor.constraint(equalToConstant: 15),
            nameField.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -12)
        ])
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

