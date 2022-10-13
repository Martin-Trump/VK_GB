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
    var friendsArray = [Friend]()
    let realm = try! Realm()
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
        let friends = Friends()
        let allFriends = realm.objects(Friends.self)
        if let friendsRealm = allFriends.first(where: { friends in
            !friends.friends.isEmpty
        }) {
            self.friendsArray = Array(friendsRealm.friends)
            self.tableView.reloadData()
        } else {
            networkService.getFriends { [self] friend in
                 try! realm.write{
                     realm.add(friends)
                    allFriends.first?.friends.append(objectsIn: friend)
                }
                self.friendsArray = Array(allFriends.first!.friends)
                self.tableView.reloadData()
            }
        }
        
}
           
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "FriendCell") as? FriendCell else {
            return UITableViewCell()
        }
        cell.set(friend: friendsArray[indexPath.row])
        return cell
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friendsArray.count
    }
    
}



