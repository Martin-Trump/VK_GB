//
//  NewsRouter.swift
//  VK_GB
//
//  Created by Павел Шатунов on 28.10.2022.
//

import Foundation
import UIKit

protocol NewsRoutingLogic {
}

class NewsfeedRouter: NSObject, NewsRoutingLogic {

  weak var viewController: NewsViewController?
}
