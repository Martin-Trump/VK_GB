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
    var friendsArray: Results<Friend>?
    let realm = try! Realm()
    var token: NotificationToken?
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
        //loadFriends()
        realmObserve()
    }
    
    func realmObserve() {
        let friends = Friends()
        let allFriends = realm.objects(Friends.self)
        friendsArray = realm.objects(Friend.self)
        if allFriends.first?.friends == nil {
            networkService.getFriends { [self] friends in
                try! realm.write {
                    realm.add(friends)
                    allFriends.first?.friends.append(objectsIn: friends)
                    
                }
            }
        }
        token = friendsArray?.observe { [weak self] (changes: RealmCollectionChange) in
            guard let tableView = self?.tableView else { return }
                        switch changes {
                        case .initial:
                            // Results are now populated and can be accessed without blocking the UI
                            tableView.reloadData()
                        case .update(_, let deletions, let insertions, let modifications):
                            // Query results have changed, so apply them to the UITableView
                            tableView.performBatchUpdates({
                                // Always apply updates in the following order: deletions, insertions, then modifications.
                                // Handling insertions before deletions may result in unexpected behavior.
                                tableView.deleteRows(at: deletions.map({ IndexPath(row: $0, section: 0)}),
                                                     with: .automatic)
                                tableView.insertRows(at: insertions.map({ IndexPath(row: $0, section: 0) }),
                                                     with: .automatic)
                                tableView.reloadRows(at: modifications.map({ IndexPath(row: $0, section: 0) }),
                                                     with: .automatic)
                            }, completion: { finished in
                                // ...
                            })
                        case .error(let error):
                            // An error occurred while opening the Realm file on the background worker thread
                            fatalError("\(error)")
                }
            }
        }
   
//    func loadFriends() {
//        let friends = Friends()
//        let allFriends = realm.objects(Friends.self)
//        if let friendsRealm = allFriends.first(where: { friends in
//            !friends.friends.isEmpty
//        }) {
//            self.friendsArray = Array(friendsRealm.friends)
//            self.tableView.reloadData()
//        } else {
//            networkService.getFriends { [self] friend in
//                 try! realm.write{
//                     realm.add(friends)
//                    allFriends.first?.friends.append(objectsIn: friend)
//                }
//                self.friendsArray = Array(allFriends.first!.friends)
//                self.tableView.reloadData()
//            }
//        }
//
//}
           
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "FriendCell") as? FriendCell else {
            return UITableViewCell()
        }
        cell.set(friend: friendsArray![indexPath.row])
        return cell
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friendsArray?.count ?? 0
    }
    
}



