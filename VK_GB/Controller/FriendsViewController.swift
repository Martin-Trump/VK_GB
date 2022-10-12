//
//  FriendsViewController.swift
//  VK_GB
//
//  Created by Павел Шатунов on 15.08.2022.
//

import Foundation
import UIKit
import RealmSwift

class FriendsViewController: UITableViewController {
    let networkService = NetworkService()
    var friends = [Friend]()
    init() {
        super.init(style: .plain)
        self.title = "Друзья"
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(FriendCell.self, forCellReuseIdentifier: "FriendCell")
        loadFriends()
    }
    func loadFriends() {
        networkService.getFriends {  (friends) in
            self.friends = friends
            self.tableView.reloadData()
            }
        }
           
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "FriendCell") as? FriendCell else {
            return UITableViewCell()
        }
        cell.set(friend: friends[indexPath.row])
        return cell
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friends.count
    }
    
}



