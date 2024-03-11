//
//  TableCell.swift
//  BeatOApp
//
//  Created by Devank on 05/03/24.
//

import Foundation
import UIKit

class TableCell: UITableViewCell {

    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var prepTimeLabel: UILabel!
    @IBOutlet var thumbnailImageView: UIImageView!

    override func prepareForReuse() {
        super.prepareForReuse()
       
    }
}
