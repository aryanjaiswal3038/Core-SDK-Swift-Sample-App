//
//  NetBankingCell.swift
//  CoreDemo
//
//  Created by Rishabh Jaiswal on 04/07/22.
//

import UIKit
import CommonCrypto
import PayUBizCoreKit
class EmiOptionCell: UITableViewCell {

   
    static let identifier = "EmiOptionCell"
   
    @IBOutlet weak var lblCard: UILabel!
    @IBOutlet weak var imgCard: UIImageView!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
       
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
