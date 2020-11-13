//
//  CellView.swift
//  News
//
//  Created by Rotach Roman on 10.11.2020.
//

import UIKit

final class CellView: UIView {

    private let padding: CGFloat = 16
    private let nc: CGFloat = 80
    
    private lazy var textTitle: UILabel = {
        let lable = UILabel()
        lable.textColor = .black
        lable.font = UIFont.boldSystemFont(ofSize: 22)
        lable.textAlignment = .left
        lable.lineBreakMode = NSLineBreakMode.byWordWrapping
        lable.translatesAutoresizingMaskIntoConstraints = false
        return lable
    }()
    
    private lazy var textField: UITextField = {
        let field = UITextField()
        field.textColor = .black
        field.font = UIFont.systemFont(ofSize: 18)
        field.textAlignment = .justified
        field.translatesAutoresizingMaskIntoConstraints = false
        return field
    }()
    
    private lazy var dateLable: UILabel = {
        let lable = UILabel()
        lable.textColor = .gray
        lable.font = UIFont.systemFont(ofSize: 14)
        lable.textAlignment = .right
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
    private func setupViews() {
        
        addSubview(textTitle)
        addSubview(textField)
        addSubview(dateLable)
    }
    
    // MARK: - Setting Constraints
    private func setupConstraints() {
        
        NSLayoutConstraint.activate([
            textTitle.topAnchor.constraint(equalTo: topAnchor, constant: padding + nc),
            textTitle.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding),
        ])
        
        NSLayoutConstraint.activate([
            dateLable.topAnchor.constraint(equalTo: textTitle.bottomAnchor, constant: 2),
            dateLable.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding),
        ])

        NSLayoutConstraint.activate([
            textField.topAnchor.constraint(equalTo: dateLable.bottomAnchor, constant: padding),
            textField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding),
        ])
    }
}

// MARK: - View Configuration
extension CellView {
    
    public func configureCell(news: NewsModel) {
        
        textTitle.text = news.newsTitle
        textField.text = news.newsText
        dateLable.text = news.date
    }
}

