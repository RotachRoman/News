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
            newsDate.text = getFormatingStringDate()
        }
    }
    
    private func getFormatingStringDate() -> String {
        let components = news!.date.get(.day, .month, .hour, .minute)
        if let day = components.day, let month = components.month, let hour = components.hour, let minute = components.minute{
            let date = Date()
            if date.get(.day) == day {
                return "Сегодня в \(hour):\(minute)"
            } else {
                if date.get(.day) - 1 == day {
                    return "Вчера в \(hour):\(minute)"
                } else {
                    return "\(hour):\(minute) \(day).\(month)"
                }
            }
        }
        return "\(news!.date)"
    }
    
    private let newsTitle : UILabel = {
        let lable = UILabel()
        lable.textColor = .black
        lable.numberOfLines = 0
        lable.lineBreakMode = .byWordWrapping
        lable.font = UIFont.boldSystemFont(ofSize: 18)
        lable.textAlignment = .left
        lable.translatesAutoresizingMaskIntoConstraints = false
        return lable
    }()
    
    private let newsDate : UILabel = {
        let lable = UILabel()
        lable.numberOfLines = 1
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
            newsDate.topAnchor.constraint(equalTo: self.topAnchor, constant: padding),
            newsDate.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: padding),
            newsTitle.trailingAnchor.constraint(equalTo: self.layoutMarginsGuide.trailingAnchor)
        ])
        NSLayoutConstraint.activate([
            newsTitle.topAnchor.constraint(equalTo: newsDate.bottomAnchor, constant: 2),
            newsTitle.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: padding),
            newsTitle.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -padding),
            newsTitle.trailingAnchor.constraint(equalTo: self.layoutMarginsGuide.trailingAnchor)
            
        ])
    }
}

extension Date {
    func get(_ components: Calendar.Component..., calendar: Calendar = Calendar.current) -> DateComponents {
        return calendar.dateComponents(Set(components), from: self)
    }

    func get(_ component: Calendar.Component, calendar: Calendar = Calendar.current) -> Int {
        return calendar.component(component, from: self)
    }
}
