//
//  CellViewController.swift
//  News
//
//  Created by Rotach Roman on 10.11.2020.
//

import UIKit

final class CellViewController: UIViewController {
    
    lazy var newsView: CellView = {
        let newsV = CellView(news: newsModel[ind])
        newsV.translatesAutoresizingMaskIntoConstraints = true
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
    private func setupViews() {
        view.backgroundColor = .white
        view.addSubview(newsView)
    }
    
    // MARK: - Setting Constraints
    private func setupConstraints() {
        let safe = view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            newsView.leadingAnchor.constraint(equalTo: safe.leadingAnchor),
            newsView.topAnchor.constraint(equalTo: safe.topAnchor),
            newsView.trailingAnchor.constraint(equalTo: safe.trailingAnchor),
            newsView.bottomAnchor.constraint(equalTo: safe.bottomAnchor)
        ])
    }
}
