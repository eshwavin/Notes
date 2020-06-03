//
//  NoteViewController.swift
//  Notes2
//
//  Created by Srivinayak Chaitanya Eshwa on 01/06/20.
//  Copyright © 2020 Srivinayak Chaitanya Eshwa. All rights reserved.
//

import UIKit

class NoteViewController: UIViewController {
    
    fileprivate var observer: ManagedObjectObserver?
    
    var note: Note! {
        didSet {
            observer = ManagedObjectObserver(object: note) { [unowned self] type in
                guard type == .delete else { return }
                self.invalidateView()
                _ = self.navigationController?.popViewController(animated: true)
                
            }
            setupView()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    private func setupView() {
        title = note.title
    }
    
    private func invalidateView() {
        self.title = ""
    }

}
