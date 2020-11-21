//
//  AdditionalyTable.swift
//  News
//
//  Created by Rotach Roman on 20.11.2020.
//

import UIKit
import CoreData

class AdditionalyTable: UIViewController, UITableViewDelegate {
    
    private let addTableView = UITableView()
    private var source: [Sources] = []
    
    override func loadView() {
        super .loadView()
        
        setupTableView()
        setupConstraints()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        completionSource()
    }
    
    private func completionSource(){
        let context = getContext()
        let fetchRequest: NSFetchRequest<Sources> = Sources.fetchRequest()
        
        do {
            source = try context.fetch(fetchRequest)
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }
    
    private func editHidden(){
        if addTableView.isHidden {
            addTableView.isHidden = false
        } else {
            addTableView.isHidden = true
        }
    }
    
    // MARK: - Setting Views and Table
    private func setupTableView(){
        addTableView.delegate = self
        addTableView.dataSource = self
        
        addTableView.register(UITableViewCell.self, forCellReuseIdentifier: "addCell")
        
        view.addSubview(addTableView)
    }
    
    // MARK: - Setting Constraints
    private func setupConstraints() {
        
        let safe = view.safeAreaLayoutGuide
        
        addTableView.translatesAutoresizingMaskIntoConstraints = false
        
        addTableView.topAnchor.constraint(equalTo: safe.topAnchor).isActive = true
        addTableView.leftAnchor.constraint(equalTo: safe.leftAnchor).isActive = true
        addTableView.bottomAnchor.constraint(equalTo: safe.centerYAnchor).isActive = true
        addTableView.rightAnchor.constraint(equalTo: safe.centerXAnchor).isActive = true
    }
    
    //MARK: - Supporting files
    private func getContext() -> NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }
}

extension AdditionalyTable: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return source.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = addTableView.dequeueReusableCell(withIdentifier: "addCell", for: indexPath)
        cell.textLabel?.text = "\(source[indexPath.row])"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        editHidden()
    }
}
