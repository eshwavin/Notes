//
//  NotesDataSource.swift
//  Notes2
//
//  Created by Srivinayak Chaitanya Eshwa on 27/05/20.
//  Copyright © 2020 Srivinayak Chaitanya Eshwa. All rights reserved.
//

import UIKit
import CoreData

class NotesDataSource<Delegate: TableViewDataSourceDelegate>: NSObject, UITableViewDataSource {
    
    let notes = [[(title: "Title1", contents: "hksfsafv bjjhsfk lfhk asfh"),
                (title: "Title2", contents: "hksfsafv bjjhsfk lfhk asfh"),
                (title: "Title3", contents: "hksfsafv bjjhsfk lfhk asfh"),
                (title: "Title4", contents: "hksfsafv bjjhsfk lfhk asfh")
            ]]
    
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
        tableView.reloadData()
    }
    
    // MARK: TableViewDataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return notes.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notes[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? Cell else {
            fatalError("Unexpected Cell Type at \(indexPath)")
        }
        
        let note = notes[indexPath.section][indexPath.row]
        
        delegate?.configure(cell, for: note)
        
        return cell
    }
    
}


