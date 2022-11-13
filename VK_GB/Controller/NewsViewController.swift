//
//  NewsViewController.swift
//  VK_GB
//
//  Created by Павел Шатунов on 15.08.2022.
//

import Foundation
import UIKit

protocol NewsDisplayLogic: AnyObject {
    func displayData(data: Newsfeed.Model.ViewModel.ViewModelData )
}

class NewsViewController: UITableViewController, NewsDisplayLogic, NewsfeedCodeCellDelegate {
   
    
    var interactor: NewsInteractorProtocol?
    
    var router: (NSObjectProtocol & NewsRoutingLogic)?
    
    private lazy var footerView = FooterView()
    
    private var refresh: UIRefreshControl = {
       var refresh = UIRefreshControl()
        refresh.addTarget(self, action: #selector(refreshing), for: .valueChanged)
        return refresh
    }()
    
    @objc func refreshing() {
        addFeedBack()
        interactor?.makeRequest(type: Newsfeed.Model.Request.RequestType.getNewsfeed)
    }
    
    func setup() {
        let interactor = NewsInteractor()
        let router = NewsfeedRouter()
        let presenter = NewsPresenter()
        self.interactor = interactor
        self.router = router
        interactor.presenter = presenter
        presenter.viewController = self
        router.viewController = self
        
    }
    
    private var feedViewModel = FeedViewModel.init(cells: [], footerTitle: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        setupTable()
        interactor?.makeRequest(type: Newsfeed.Model.Request.RequestType.getNewsfeed)
    }
    
    func setupTable() {
        tableView.separatorStyle = .none
        tableView.tableFooterView = footerView
        tableView.backgroundColor = .clear
        tableView.addSubview(refresh)
        tableView.register(NewsfeedCodeCell.self, forCellReuseIdentifier: NewsfeedCodeCell.reuseId)
        
    }
    
    
    func displayData(data: Newsfeed.Model.ViewModel.ViewModelData) {
        switch data {
        case .displayNewsfeed(let feedViewModel):
            self.feedViewModel = feedViewModel
            footerView.setTitle(feedViewModel.footerTitle)
            tableView.reloadData()
            refresh.endRefreshing()
        case .displayFooterLoader:
            footerView.showLoader()
        }
    }
    
    func revealPost(for cell: NewsfeedCodeCell) {
        guard let indexPath = tableView.indexPath(for: cell) else {return}
        let cellViewModel = feedViewModel.cells[indexPath.row]
        interactor?.makeRequest(type: Newsfeed.Model.Request.RequestType.revealPostIds(postId: cellViewModel.postId))
    }
    
    override func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if scrollView.contentOffset.y > scrollView.contentSize.height / 1.1 {
            addFeedBack()
            interactor?.makeRequest(type: Newsfeed.Model.Request.RequestType.getNextBatch)
        }
    }
    
    func addFeedBack() {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return feedViewModel.cells.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: NewsfeedCodeCell.reuseId, for: indexPath) as? NewsfeedCodeCell else {return UITableViewCell()}
        let cellViewModel = feedViewModel.cells[indexPath.row]
        cell.set(viewModel: cellViewModel)
        cell.delegate = self
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let cellViewModel = feedViewModel.cells[indexPath.row]
        return cellViewModel.sizes.totalHeight
    }
    
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        let cellViewModel = feedViewModel.cells[indexPath.row]
        return cellViewModel.sizes.totalHeight
    }
    
}



import SwiftUI
struct FlowProvider: PreviewProvider {
    static var previews: some View {
        ContainerView().edgesIgnoringSafeArea(.all)
    }
    struct ContainerView: UIViewControllerRepresentable {
        let tabBar = NewsViewController()
        func makeUIViewController(context: UIViewControllerRepresentableContext<FlowProvider.ContainerView>) -> NewsViewController {
            return tabBar
        }
        func updateUIViewController(_ uiViewController: FlowProvider.ContainerView.UIViewControllerType, context: UIViewControllerRepresentableContext<FlowProvider.ContainerView>) {
        }
    }
}



