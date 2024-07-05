//
//  NetBankingCell.swift
//  CoreDemo
//
//  Created by Asif Hussain on 04/07/22.
//

import UIKit
import CommonCrypto
import PayUBizCoreKit
class CardListCell: UITableViewCell {

    @IBOutlet weak var btnHeight: NSLayoutConstraint!
    static let identifier = "CardListCell"
    @IBOutlet weak var btnProceedAndPay: UIButton!
    @IBOutlet weak var lblBank: UILabel!
    @IBOutlet weak var imgBank: UIImageView!
    
    var modelItem:PayUModelEMI?{
        didSet{
            guard let item = modelItem else { return  }
            lblBank.text = item.bankName
            
           
        }
       
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
