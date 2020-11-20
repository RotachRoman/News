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
    private var parseData: ParserRSS!
    
    private let myRefreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refresh(sender:)), for: .valueChanged)
        return refreshControl
    }()
    
    override func loadView() {
        super.loadView()
        editNavigation()
        updateInterface()
        
        setupTableView()
        setupConstraints()
        
        tableView.refreshControl = myRefreshControl
        tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.estimatedRowHeight = 50
        tableView.rowHeight = UITableView.automaticDimension
        
        tableView.reloadData()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    //MARK: - Work with Data
    
    @objc private func refresh(sender: UIRefreshControl){
            updateInterface()
            sender.endRefreshing()
    }
    
    private func recordDataInArray() {
        var count = 0
        while (count < parseData?.items.count ?? 0) {
            let title = parseData.items[count].titleNews
            var text = parseData.items[count].textNews
            let dateString = parseData.items[count].dateNews
            
            replacingText(text: &text)
            let convertDate = stringToDate(date: dateString)
        
            newsModel.append(NewsModel(title: title, text: text, date: convertDate))
            count += 1
        }
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }

    private func stringToDate(date: String) -> Date{
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "E, d MMM y H:mm:ss Z"
        guard let date = dateFormatter.date(from: date) else {
            preconditionFailure("Take a look to your format")
        }
        return date
    }
    
    private func replacingText( text: inout String){
        text = text.replacingOccurrences(of: "</p>", with: "\n", options: NSString.CompareOptions.literal, range: nil)
        text = text.replacingOccurrences(of: "<p>", with: "", options: NSString.CompareOptions.literal, range: nil)
        text = text.replacingOccurrences(of: "<[^>]+>", with: " ", options: .regularExpression, range: nil)
    }
    
    private func loadData(){
        guard let url = URL(string:"https://www.banki.ru/xml/news.rss") else {
            // show error
            return
        }
        let request = URLRequest(url: url)
        let session = URLSession.shared.dataTask(with: request) {[weak self] (data, response, error) in
            if error != nil {
                print("Error")
                return
            }
            guard let data = data else {
                print("No data")
                return
            }
            var str = String(data: data, encoding: .ascii)
            str = str?.replacingOccurrences(of: "\r", with: "\n")
            
            self?.parseData = ParserRSS()
            self?.parseData.setData(data: data)
            self?.parseData.parse()
            self?.recordDataInArray()
        }
        session.resume()
    }
    
    private func updateInterface(){
            loadData()
            recordDataInArray()
    }
        
    //MARK: - Settings Navigation
    private func editNavigation(){
        
        self.navigationController?.navigationBar.barTintColor = .white
        self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.black]
        
        self.navigationItem.title = "News"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(update))
    }
    
    @objc private func update() {
        tableView.reloadData()
    }
    
    // MARK: - Setting Views and Table
    private func setupTableView(){
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(NewsTableViewCell.self, forCellReuseIdentifier: "cell")
        
        view.addSubview(tableView)
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
        
        if news.isReadNews == true {
            cell.backgroundColor = .init(red: 66/255, green: 145/255, blue: 1, alpha: 0.1)
        } else {
            cell.backgroundColor = .none
        }
        
        return cell
    }
    
    //MARK:- Create new view
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        ind = indexPath.row
        newsModel[ind].isReadNews = true
        let vc = AboutCellViewController()
        self.navigationController?.pushViewController(vc, animated: false)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
