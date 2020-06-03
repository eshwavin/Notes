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
                
                _ = self.navigationController?.popViewController(animated: true)
                
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
