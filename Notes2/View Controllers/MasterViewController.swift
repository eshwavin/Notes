//
//  ViewController.swift
//  Notes2
//
//  Created by Srivinayak Chaitanya Eshwa on 25/05/20.
//  Copyright © 2020 Srivinayak Chaitanya Eshwa. All rights reserved.
//

import UIKit
import CoreData

class MasterViewController: UITableViewController {

    private var dataSource: NotesDataSource<MasterViewController>?
    
    var managedObjectContext: NSManagedObjectContext!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
    }
    

    private func setupTableView() {
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 100
        
        dataSource = NotesDataSource(tableView: tableView, cellIdentifier: CellIdentifiers.notesMasterCell.rawValue, delegate: self)
        
    }
    
}

extension MasterViewController: TableViewDataSourceDelegate {
    func configure(_ cell: NotesTableViewCell, for note: (title: String, contents: String)) {
        cell.configure(for: note)
    }
}

