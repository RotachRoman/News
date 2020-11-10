//
//  NewsModel.swift
//  News
//
//  Created by Rotach Roman on 10.11.2020.
//

import Foundation

final class NewsModel {
    
    let newsTitle: String
    let newsText: String
    let date: String
    var isReadNews: Bool
    
    init (title: String, text: String, date: String){
        self.newsTitle = title
        self.newsText = text
        self.date = date
        self.isReadNews = false
    }
}
