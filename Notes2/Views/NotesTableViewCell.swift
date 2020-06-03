//
//  NotesTableViewCell.swift
//  Notes2
//
//  Created by Srivinayak Chaitanya Eshwa on 03/06/20.
//  Copyright © 2020 Srivinayak Chaitanya Eshwa. All rights reserved.
//

import UIKit

class NotesTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func configure(for note: Note) {
        textLabel?.text = note.title
        detailTextLabel?.numberOfLines = 4
        detailTextLabel?.text = note.content
    }
    
}
