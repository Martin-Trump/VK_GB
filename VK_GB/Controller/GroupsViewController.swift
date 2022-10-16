//
//  GroupsViewController.swift
//  VK_GB
//
//  Created by Павел Шатунов on 15.08.2022.
//

import Foundation
import UIKit
import RealmSwift

class GroupsViewController: UITableViewController {
    let networkService = NetworkService()
    var groupsArray: Results<Group>?
    let realm = try! Realm()
    var token: NotificationToken?
    init() {
        super.init(style: .plain)
        self.title = "Группы"
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(GroupCell.self, forCellReuseIdentifier: "GroupCell")
        //loadGroups()
        realmObserve()
       
        
    }
    
    
    
    func realmObserve() {
        let groups = Groups()
        let allGroups = realm.objects(Groups.self)
        groupsArray = realm.objects(Group.self)
        if allGroups.first?.groups == nil {
            networkService.getCommunities { [self] communities in
                try! realm.write {
                    realm.add(groups)
                    allGroups.first?.groups.append(objectsIn: communities)
                    
                }
            }
        }
        token = groupsArray?.observe { [weak self] (changes: RealmCollectionChange) in
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
//    func loadGroups() {
//        let groups = Groups()
//        let allGroups = realm.objects(Groups.self)
//        if let groupsRealm = allGroups.first(where: { groups in
//            !groups.groups.isEmpty
//        }) {
//            self.groupsArray = Array(groupsRealm.groups)
//            self.tableView.reloadData()
//        } else {
//            networkService.getCommunities { [self] community in
//                 try! realm.write{
//                     realm.add(groups)
//                    allGroups.first?.groups.append(objectsIn: community)
//                }
//                self.groupsArray = Array(allGroups.first!.groups)
//                self.tableView.reloadData()
//            }
//        }
//
//}

           
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "GroupCell") as? GroupCell else {
            return UITableViewCell()
        }
        cell.set(group: groupsArray![indexPath.row] )
        return cell
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groupsArray?.count ?? 0
    }
    
}

