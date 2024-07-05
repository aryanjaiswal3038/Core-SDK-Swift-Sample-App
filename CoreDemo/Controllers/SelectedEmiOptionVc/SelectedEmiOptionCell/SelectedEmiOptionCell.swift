//
//  SelectedEmiOptionCell.swift
//  CoreDemo
//
//  Created by Asif Hussain on 05/07/22.
//

import UIKit
import CommonCrypto
import PayUBizCoreKit
class SelectedEmiOptionCell: UITableViewCell {
    
    
    @IBOutlet weak var lblEmiInterestRate: UILabel!
    @IBOutlet weak var lblEmiHeader: UILabel!
    @IBOutlet weak var btnRadio: UIButton!
    static let identifier = "SelectedEmiOptionCell"
    
    var model:EmiOptionListModel?{
        didSet{
            guard let item = model else { return  }
            lblEmiHeader.text = "Pay ₹ \(item.emiAmount ?? "")*\(item.tenure ?? "") @\(item.emiBankInterest ?? "")% pa"
            lblEmiInterestRate.text = "Total interest charged = ₹\(item.bankCharge ?? "")"
          
            
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
//        self.lblEmiInterestRate.isHidden = true
        // Initialization codel
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
