//
//  MainMenuViewController.swift
//  VK_GB
//
//  Created by Павел Шатунов on 15.08.2022.
//

import Foundation
import UIKit

class MainMenuViewController: UITabBarController {

     override func viewDidLoad() {
        super.viewDidLoad()

        setupMainMenu()
    }
    
   
    func setupMainMenu() {
       
        let groupsViewController = createNavController(vc: GroupsViewController(), textItem: "Группы", imageItem: "person.2.crop.square.stack")
        let friendsViewController = createNavController(vc: FriendsViewController(), textItem: "Друзья", imageItem: "person.3.sequence.fill")
        let newsViewController = createNavController(vc: NewsViewController(), textItem: "Новости", imageItem: "newspaper.circle.fill")
        
        viewControllers = [groupsViewController, friendsViewController, newsViewController]
        
    }
    
    
}



func createNavController(vc: UIViewController, textItem: String, imageItem: String) -> UINavigationController {
    
    let item = UITabBarItem(title: textItem, image: UIImage(systemName: imageItem), tag: 0)
    let navController = UINavigationController(rootViewController: vc)
    navController.tabBarItem = item
    return navController
}
