//
//  AboutCellViewController.swift
//  News
//
//  Created by Rotach Roman on 10.11.2020.
//

import UIKit

final class AboutCellViewController: UIViewController, CreateViewProtocol {
        
    lazy var newsView: CellView = {
        let newsV = CellView(news: newsModel[ind])
        newsV.translatesAutoresizingMaskIntoConstraints = false
        return newsV
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
        editNavigation()
    }
    
    //MARK: - Settings Navigation
    private func editNavigation(){
        
        self.navigationController?.navigationBar.barTintColor = .white
        self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.black]
        
        self.navigationItem.title = newsModel[ind].newsTitle
    }
    
    // MARK: - Setting Views
    internal func setupViews() {
        view.backgroundColor = .white
        view.addSubview(newsView)
    }
    
    // MARK: - Setting Constraints
    internal func setupConstraints() {
        let safe = view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            newsView.leadingAnchor.constraint(equalTo: safe.leadingAnchor),
            newsView.topAnchor.constraint(equalTo: safe.topAnchor),
            newsView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            newsView.trailingAnchor.constraint(equalTo: safe.trailingAnchor)
        ])
    }
}
