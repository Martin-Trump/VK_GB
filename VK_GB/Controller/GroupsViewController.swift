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
    var groups = [Group]()
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
        networkService.getCommunities {  (communities) in
            self.groups = communities
            self.tableView.reloadData()
            }
        }
           
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "GroupCell") as? GroupCell else {
            return UITableViewCell()
        }
        cell.set(group: groups[indexPath.row])
        return cell
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groups.count
    }
    
}

