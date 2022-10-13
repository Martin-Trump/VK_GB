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
    var groupsArray = [Group]()
    let realm = try! Realm()
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
        loadGroups()
        
    }
    func loadGroups() {
        let groups = Groups()
        let allGroups = realm.objects(Groups.self)
        if let groupsRealm = allGroups.first(where: { groups in
            !groups.groups.isEmpty
        }) {
            self.groupsArray = Array(groupsRealm.groups)
            self.tableView.reloadData()
        } else {
            networkService.getCommunities { [self] community in
                 try! realm.write{
                     realm.add(groups)
                    allGroups.first?.groups.append(objectsIn: community)
                }
                self.groupsArray = Array(allGroups.first!.groups)
                self.tableView.reloadData()
            }
        }
        
}

           
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "GroupCell") as? GroupCell else {
            return UITableViewCell()
        }
        cell.set(group: groupsArray[indexPath.row])
        return cell
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groupsArray.count
    }
    
}

