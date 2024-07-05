//
//  NetBankingCell.swift
//  CoreDemo
//
//  Created by Asif Hussain on 04/07/22.
//

import UIKit
import CommonCrypto
import PayUBizCoreKit
class NetBankingCell: UITableViewCell {

    @IBOutlet weak var btnHeight: NSLayoutConstraint!
    static let identifier = "NetBankingCell"
    @IBOutlet weak var btnProceedAndPay: UIButton!
    @IBOutlet weak var lblBank: UILabel!
    @IBOutlet weak var imgBank: UIImageView!
    
    var netBankingItem:NetBankingModel?{
        didSet{
            guard let item = netBankingItem else { return  }
            lblBank.text = item.netBanking?.title
            if item.isOpen{
                self.btnProceedAndPay.isHidden = false
                self.btnHeight.constant = 50
                self.contentView.layoutIfNeeded()
                
            }else{
                self.btnProceedAndPay.isHidden = true
                self.btnHeight.constant = 0
                self.contentView.layoutIfNeeded()
            }
        }
       
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        btnProceedAndPay.layer.cornerRadius = 5
        btnProceedAndPay.layer.masksToBounds = true
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
