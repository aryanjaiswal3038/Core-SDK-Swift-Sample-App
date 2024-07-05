//
//  OptionCell.swift
//  CoreDemo
//
//  Created by Rishabh Jaiswal on 01/07/22.
//

import UIKit

class OptionCell: UITableViewCell {
    static let identifier = "OptionCell"
    @IBOutlet weak var lblOption: UILabel!
    @IBOutlet weak var imgOption: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
