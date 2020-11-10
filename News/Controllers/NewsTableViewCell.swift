//
//  NewsTableViewCell.swift
//  News
//
//  Created by Rotach Roman on 10.11.2020.
//

import UIKit

final class NewsTableViewCell: UITableViewCell {
    
    var news : NewsModel? {
        didSet {
            newsTitle.text = news?.newsTitle
            newsDate.text = news?.date
        }
    }
    
    private let newsTitle : UILabel = {
        let lable = UILabel()
        lable.textColor = .black
        lable.font = UIFont.boldSystemFont(ofSize: 22)
        lable.textAlignment = .left
        return lable
    }()
    
    private let newsDate : UILabel = {
        let lable = UILabel()
        lable.textColor = .gray
        lable.font = UIFont.systemFont(ofSize: 14)
        lable.textAlignment = .right
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
        newsTitle.anchor(top: topAnchor, left: leftAnchor, bottom: nil, right: nil, paddingTop: 5, paddingLeft: 14, paddingBottom: 0, paddingRight: 10, width: frame.size.width , height: 0 , enableInsets: false)
        
        newsDate.anchor(top: newsTitle.bottomAnchor, left: leftAnchor, bottom: bottomAnchor, right: nil, paddingTop: -5, paddingLeft: 14, paddingBottom: 0, paddingRight: 10, width: 0, height: 0, enableInsets: false)
    }
}
