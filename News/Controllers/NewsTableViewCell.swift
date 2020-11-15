//
//  NewsTableViewCell.swift
//  News
//
//  Created by Rotach Roman on 10.11.2020.
//

import UIKit

final class NewsTableViewCell: UITableViewCell {
    
    private let padding: CGFloat = 8
    
    var news : NewsModel? {
        didSet {
            newsTitle.text = news?.newsTitle
            newsDate.text = news?.date
        }
    }
    
    private let newsTitle : UILabel = {
        let lable = UILabel()
        lable.textColor = .black
        lable.numberOfLines = 3
        lable.lineBreakMode = .byWordWrapping
        lable.font = UIFont.boldSystemFont(ofSize: 18)
        lable.textAlignment = .left
        lable.translatesAutoresizingMaskIntoConstraints = false
        return lable
    }()
    
    private let newsDate : UILabel = {
        let lable = UILabel()
        lable.textColor = .gray
        lable.font = UIFont.systemFont(ofSize: 12)
        lable.textAlignment = .right
        lable.translatesAutoresizingMaskIntoConstraints = false
        return lable
    }()

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        setupViews()
        setupConstraints()
    }
    
    // MARK: - Setting Views
    private func setupViews() {
        addSubview(newsTitle)
        addSubview(newsDate)
    }
    
    // MARK: - Setting Constraints
    private func setupConstraints(){
        
        NSLayoutConstraint.activate([
            newsDate.topAnchor.constraint(equalTo: self.layoutMarginsGuide.topAnchor),
            newsDate.leadingAnchor.constraint(equalTo: self.layoutMarginsGuide.leadingAnchor)
        ])
        NSLayoutConstraint.activate([
            newsTitle.topAnchor.constraint(equalTo: newsDate.bottomAnchor),
            newsTitle.leadingAnchor.constraint(equalTo: self.layoutMarginsGuide.leadingAnchor),
            newsTitle.trailingAnchor.constraint(equalTo: self.layoutMarginsGuide.trailingAnchor)
        ])
    }
}
