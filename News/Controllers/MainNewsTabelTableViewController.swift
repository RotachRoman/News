//
//  MainNewsTabelTableViewController.swift
//  News
//
//  Created by Rotach Roman on 10.11.2020.
//

import UIKit

var ind: Int = -1
var newsModel: [NewsModel] = [NewsModel]()

final class MainNewsTabelTableViewController: UIViewController, UITableViewDelegate, XMLParserDelegate {
    
    private var tableView = UITableView()
    private var rssParser: RSSParser!

    override func viewDidLoad() {
        super.viewDidLoad()
//        workWithParse()
        
        setupTableView()
        setupConstraints()
        addNews()
        
        sortedNews()
        editNavigation()
        tableView.reloadData()
        
        loadData()
        
//        let rssParser = RSSParser()
//        rssParser.startParsingWithContentsOfURL(rssURl: "https://www.banki.ru/xml/news.rss")
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    func workWithParse(){
        guard let url = URL(string: "https://www.banki.ru/xml/news.rss") else { return  }
        rssParser = RSSParser()
        rssParser.startParsingWithContentsOfURL(rssURl: url) { active in
            
        }
    }
    
    //MARK: - load
    private func loadData(){
        guard let url = URL(string:"https://www.finam.ru/net/analysis/conews/rsspoint") else {
            // show error
            return
        }
        let request = URLRequest(url: url)
        let session = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if error != nil {
                return
            }
            guard let data = data else {
                // show error
                return
            }
            var str = String(data: data, encoding: .ascii)
            str = str?.replacingOccurrences(of: "\r", with: "\n")
            
            let p = ParserRSS()
            p.setData(data: data)
            p.parse()
            
        }
        session.resume()
        
    }
    
    //MARK: - Settings Navigation
    private func editNavigation(){
        
        self.navigationController?.navigationBar.barTintColor = .white
        self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.black]
        
        self.navigationItem.title = "News"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(refresh))
    }
    
    @objc private func refresh() {
        
    }
    
    // MARK: - Setting Views
    private func setupTableView(){
        view.addSubview(tableView)
        
        tableView.register(NewsTableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    // MARK: - Setting Constraints
    private func setupConstraints() {
        
        let safe = view.safeAreaLayoutGuide
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        tableView.topAnchor.constraint(equalTo: safe.topAnchor).isActive = true
        tableView.leftAnchor.constraint(equalTo: safe.leftAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: safe.rightAnchor).isActive = true
    }
    
    // MARK: -  Work with news
    private func addNews() {
        newsModel.append(NewsModel(title: "Hello", text: "Hi, my friend", date: "22.08"))
        
        newsModel.append(NewsModel(title: "News", text: "Hi, boy", date: "22.09"))
    }
    
    private func sortedNews(){
        newsModel.sort { $0.date > $1.date }
    }
}

// MARK: - Table view data source
extension MainNewsTabelTableViewController: UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return newsModel.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! NewsTableViewCell
        let news = newsModel[indexPath.row]
        cell.news = news
        
        cell.selectionStyle = .none
        
        if news.isReadNews == true{
            cell.backgroundColor = .init(red: 66/255, green: 145/255, blue: 1, alpha: 0.1)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        ind = indexPath.row
        newsModel[indexPath.row].isReadNews = true
        let vc = CellViewController()
        self.navigationController?.pushViewController(vc, animated: false)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
}
