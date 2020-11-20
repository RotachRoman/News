//
//  CellView.swift
//  News
//
//  Created by Rotach Roman on 10.11.2020.
//

import UIKit

final class CellView: UIView, CreateViewProtocol {

    private let padding: CGFloat = 12
    
    private lazy var scrollView: UIScrollView = {
        let scroll = UIScrollView()
        scroll.translatesAutoresizingMaskIntoConstraints = false
        return scroll
    }()
    
    private lazy var stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private lazy var textTitle: UILabel = {
        let lable = UILabel()
        lable.textColor = .black
        lable.font = UIFont.boldSystemFont(ofSize: 18)
        lable.textAlignment = .left
        lable.numberOfLines = 5
        lable.lineBreakMode = .byWordWrapping
        lable.translatesAutoresizingMaskIntoConstraints = false
        return lable
    }()
    
    private lazy var textLable: UILabel = {
        let lable = UILabel()
        lable.textColor = .black
        lable.font = UIFont.systemFont(ofSize: 15)
        lable.textAlignment = .left
        lable.numberOfLines = .bitWidth
        lable.lineBreakMode = .byWordWrapping
        lable.translatesAutoresizingMaskIntoConstraints = false
        return lable
    }()
    
    private lazy var dateLable: UILabel = {
        let lable = UILabel()
        lable.textColor = .gray
        lable.font = UIFont.systemFont(ofSize: 12)
        lable.textAlignment = .left
        lable.translatesAutoresizingMaskIntoConstraints = false
        return lable
    }()
    
    private override init(frame: CGRect) {
      super.init(frame: frame)
      setupViews()
      setupConstraints()
    }
    
    public convenience init(news: NewsModel) {
        self.init(frame: .zero)
        configureCell(news: news)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setting Views
    internal func setupViews() {
        addSubview(scrollView)
        scrollView.addSubview(stackView)
        stackView.addArrangedSubview(textTitle)
        stackView.addArrangedSubview(dateLable)
        stackView.addArrangedSubview(textLable)
    }
    
    // MARK: - Setting Constraints
    internal func setupConstraints() {
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: self.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            scrollView.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        ])
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            stackView.trailingAnchor.constraint(lessThanOrEqualTo: scrollView.layoutMarginsGuide.trailingAnchor, constant: -padding)
        ])

        NSLayoutConstraint.activate([
            textTitle.topAnchor.constraint(equalTo: stackView.topAnchor, constant: padding),
            textTitle.leadingAnchor.constraint(equalTo: stackView.leadingAnchor, constant: padding),
            textTitle.trailingAnchor.constraint(equalTo: stackView.layoutMarginsGuide.trailingAnchor)
        ])

        NSLayoutConstraint.activate([
            dateLable.topAnchor.constraint(equalTo: textTitle.layoutMarginsGuide.bottomAnchor, constant: 2),
            dateLable.leadingAnchor.constraint(equalTo: stackView.leadingAnchor, constant: padding),
            dateLable.trailingAnchor.constraint(lessThanOrEqualTo: stackView.trailingAnchor)
        ])

        NSLayoutConstraint.activate([
            textLable.topAnchor.constraint(equalTo: dateLable.layoutMarginsGuide.bottomAnchor, constant: padding),
            textLable.leadingAnchor.constraint(equalTo: stackView.leadingAnchor, constant: padding),
            textLable.bottomAnchor.constraint(equalTo: stackView.bottomAnchor),
            textLable.trailingAnchor.constraint(lessThanOrEqualTo: stackView.layoutMarginsGuide.trailingAnchor)
        ])
    }
}

// MARK: - View Configuration
extension CellView {
    
    public func configureCell(news: NewsModel) {
        
        textTitle.text = news.newsTitle
        textLable.text = news.newsText
        dateLable.text = String(describing: news.date)
    }
}

