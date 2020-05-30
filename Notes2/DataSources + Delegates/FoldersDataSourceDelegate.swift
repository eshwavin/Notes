//
//  NotesDataSource.swift
//  Notes2
//
//  Created by Srivinayak Chaitanya Eshwa on 27/05/20.
//  Copyright © 2020 Srivinayak Chaitanya Eshwa. All rights reserved.
//

import UIKit
import CoreData

class FoldersDataSourceDelegate<Delegate: TableViewDataSourceDelegate>: NSObject, UITableViewDataSource, UITableViewDelegate {
    
    let folders = [["Folder 1", "Folder2", "Folder3"]]
    
    private let tableView: UITableView
    private weak var delegate: Delegate?
    private let cellIdentifier: String
    
    typealias Cell = Delegate.Cell
    
    required init(tableView: UITableView, cellIdentifier: String, delegate: Delegate) {
        self.tableView = tableView
        self.cellIdentifier = cellIdentifier
        self.delegate = delegate
        
        super.init()
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.reloadData()
    }
    
    // MARK: TableViewDataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return folders.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return folders[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? Cell else {
            fatalError("Unexpected Cell Type at \(indexPath)")
        }
        
        let folder = folders[indexPath.section][indexPath.row]
        
        delegate?.configure(cell, for: folder)
        
        return cell
    }
    
    // MARK: TableViewDelegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}
