//
//  MainNewsTabelTableViewController.swift
//  News
//
//  Created by Rotach Roman on 10.11.2020.
//

import UIKit
import CoreData

var ind: Int = -1
var newsModel: [NewsModel] = [NewsModel]()

final class MainNewsTabelTableViewController: UIViewController, UITableViewDelegate, XMLParserDelegate {
    
    private let addTableView = UITableView()
    private let mainTableView = UITableView()
    private var parseData: ParserRSS!
    private var sources: [Sources] = []
    
    private let myRefreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refresh(sender:)), for: .valueChanged)
        return refreshControl
    }()
    
    override func loadView() {
        super.loadView()
        
        loadMainTableView()
        loadAdditionalTable()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mainTableView.estimatedRowHeight = 100
        mainTableView.rowHeight = UITableView.automaticDimension
        
        addTableView.estimatedRowHeight = 100
        addTableView.rowHeight = UITableView.automaticDimension
        editHidden()
        
        mainTableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super .viewWillAppear(animated)
        mainTableView.reloadData()
        completionSource()
        addTableView.reloadData()
    }
    
    private func loadMainTableView(){
        editNavigation()
        updateInterface()
        
        setupTableView()
        setupConstraints()
        
        mainTableView.refreshControl = myRefreshControl
        mainTableView.reloadData()
    }
    
    private func loadAdditionalTable(){
        setupAddTableView()
        setupAddConstraints()
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
            self.mainTableView.reloadData()
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
    
    private func loadData(url: URL){
        
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
        loadData(url: URL(string: "https://www.banki.ru/xml/news.rss")!)
    }
    
    //MARK: - Fetch
    private func completionSource(){
        let context = getContext()
        let fetchRequest: NSFetchRequest<Sources> = Sources.fetchRequest()
        
        do {
            sources = try context.fetch(fetchRequest)
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }
        
    //MARK: - Settings Navigation
    private func editNavigation(){
        
        self.navigationController?.navigationBar.barTintColor = .white
        self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.black]
        
        self.navigationItem.title = "News"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(add))
        
        let button = UIButton(type: .system)
        button.setTitle("Источники ", for: .normal)
        button.setImage(UIImage(systemName: "chevron.down.square"), for: .normal)
        button.sizeToFit()
        button.addTarget(self, action: #selector(list), for: .touchUpInside)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: button)
    }
    
    //MARK: - Funcs Bar Buttons
    @objc private func list () {
        editHidden()
    }
    
    @objc private func add() {
        addTableHidden()
        
        let alertController = UIAlertController(title: "Новый источник", message: "Введите адресс нового источника (должен начинаться с https//www)", preferredStyle: .alert)
        let saveAction = UIAlertAction(title: "Сохранить", style: .default) { action in
            let textField = alertController.textFields?.first
            textField?.placeholder = "https://www.banki.ru/xml/news.rss"
            if let newSourse = textField?.text {
                newsModel.removeAll()
                self.saveSourse(sourse: newSourse)
                guard let newURL = URL(string: newSourse) else { return }
                self.loadData(url: newURL)
                self.addTableView.reloadData()
            }
        }
        alertController.addTextField { _ in}
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { _ in }
        
        alertController.addAction(saveAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    private func saveSourse(sourse: String) {
        let context = getContext()
        guard let entity = NSEntityDescription.entity(forEntityName: "Sources", in: context) else { return }
        let sourceObject = Sources(entity: entity, insertInto: context)
        let fullURl = sourse
        guard let URLSource = URL(string: fullURl) else {
            return
        }
        sourceObject.source = URLSource
        
        do {
            try context.save()
            sources.insert(sourceObject, at: 0)
        }catch let error as NSError {
            print(error.localizedDescription)
        }
    }
    
    // MARK: - Setting Views and Table
    private func setupTableView(){
        mainTableView.delegate = self
        mainTableView.dataSource = self
        
        mainTableView.register(NewsTableViewCell.self, forCellReuseIdentifier: "cell")
        
        view.addSubview(mainTableView)
    }
    
    // MARK: - Setting Constraints
    private func setupConstraints() {
        
        let safe = view.safeAreaLayoutGuide
        
        mainTableView.translatesAutoresizingMaskIntoConstraints = false
        
        mainTableView.topAnchor.constraint(equalTo: safe.topAnchor).isActive = true
        mainTableView.leftAnchor.constraint(equalTo: safe.leftAnchor).isActive = true
        mainTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        mainTableView.rightAnchor.constraint(equalTo: safe.rightAnchor).isActive = true
    }
    
    // MARK: - Setting additional Views and Table
    private func setupAddTableView(){
        addTableView.backgroundColor = .lightGray
        addTableView.layer.cornerRadius = 5
        addTableView.delegate = self
        addTableView.dataSource = self
        
        addTableView.register(UITableViewCell.self, forCellReuseIdentifier: "addCell")
        
        view.addSubview(addTableView)
    }
    
    // MARK: - Setting Additional Constraints
    private func setupAddConstraints() {
        
        let safe = view.safeAreaLayoutGuide
        
        addTableView.translatesAutoresizingMaskIntoConstraints = false
        
        addTableView.topAnchor.constraint(equalTo: safe.topAnchor).isActive = true
        addTableView.leftAnchor.constraint(equalTo: safe.leftAnchor, constant: 10).isActive = true
        addTableView.bottomAnchor.constraint(equalTo: safe.centerYAnchor).isActive = true
        addTableView.rightAnchor.constraint(equalTo: safe.rightAnchor, constant: -20).isActive = true
    }
    //MARK: - Supporting files
    private func getContext() -> NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }
    
    private func editHidden(){
        if addTableView.isHidden {
            addTableView.isHidden = false
        } else {
            addTableView.isHidden = true
        }
    }
    
    private func addTableHidden () {
        if !addTableView.isHidden {
            addTableView.isHidden = true
        }
    }
}

// MARK: - Table view data source
extension MainNewsTabelTableViewController: UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == mainTableView {
            return newsModel.count
        } else {
            return sources.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == mainTableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! NewsTableViewCell
            let news = newsModel[indexPath.row]
            cell.news = news
            
            if news.isReadNews == true {
                cell.backgroundColor = .init(red: 66/255, green: 145/255, blue: 1, alpha: 0.1)
            } else {
                cell.backgroundColor = .none
            }
            
            return cell
        } else {
            let cell = addTableView.dequeueReusableCell(withIdentifier: "addCell", for: indexPath)
            let source = sources[indexPath.row]
            cell.backgroundColor = .lightGray
            cell.textLabel?.numberOfLines = 0
            cell.textLabel?.text = String(describing: source.source!)
            return cell
        }
    }
    
    //MARK:- Create new view
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == mainTableView {
            addTableHidden()
            ind = indexPath.row
            newsModel[ind].isReadNews = true
            let vc = AboutCellViewController()
            self.navigationController?.pushViewController(vc, animated: false)
        } else {
            newsModel.removeAll()
            loadData(url: sources[indexPath.row].source!)
            editHidden()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
