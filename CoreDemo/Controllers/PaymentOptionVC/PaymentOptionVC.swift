//
//  PaymentOptionVC.swift
//  CoreDemo
//
//  Created by Rishabh Jaiswal on 22/06/22.

import UIKit
import CommonCrypto
import PayUBizCoreKit
class PaymentOptionVC: UIViewController {
    var optionDict:[String:Any]?
    var ibiboDict = [String:Any]()
    var paymentParam = PayUModelPaymentParams()
    var paymentRelatedDetail = PayUModelPaymentRelatedDetail()
    var actualPaymentOption = [String]()
    var emiOptionListItem = [EmiOptionListModel]()
    @IBOutlet weak var optionTblVw: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        initialiseTable()
    }
    
    
    func initialiseTable(){
        optionTblVw.delegate = self
        optionTblVw.dataSource = self
        optionTblVw.register(UINib(nibName: OptionCell.identifier, bundle: nil), forCellReuseIdentifier: OptionCell.identifier)
        optionTblVw.separatorStyle = .none
        optionTblVw.rowHeight = UITableView.automaticDimension
        optionTblVw.estimatedRowHeight = 60
       
        if let optionArray = paymentRelatedDetail.availablePaymentOptionsArray{
            actualPaymentOption = optionArray  as! [String]
            actualPaymentOption.removeAll { item in
                if item == "Credit Card" || item == "Debit Card" || item == "Cash Card"{
                    return true
                }else{
                    return false
                }
            }
            print("actualPaymentOption.............\(actualPaymentOption)")
        }
        
       
        
        self.optionTblVw.reloadData()
        
        
    }
    
    
    

}


extension PaymentOptionVC:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return actualPaymentOption.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: OptionCell.identifier) as? OptionCell else { return UITableViewCell() }
        cell.selectionStyle = .none
        cell.lblOption.text = self.actualPaymentOption[indexPath.row]
       
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("credit.........\(actualPaymentOption[indexPath.row])")
        switch actualPaymentOption[indexPath.row] {
        case "Credit / Debit Cards":
            
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "PaymentVC") as! PaymentVC
            vc.paymentParamForPassing = paymentParam
            vc.paymentRelatedDetail = paymentRelatedDetail
            self.navigationController?.pushViewController(vc, animated: true)
            
            return
        case "Credit Card":
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "PaymentVC") as! PaymentVC
            vc.paymentParamForPassing = paymentParam
            vc.paymentRelatedDetail = paymentRelatedDetail
            self.navigationController?.pushViewController(vc, animated: true)
            return
        case "Debit Card":
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "PaymentVC") as! PaymentVC
            vc.paymentParamForPassing = paymentParam
            vc.paymentRelatedDetail = paymentRelatedDetail
            self.navigationController?.pushViewController(vc, animated: true)
            return
        case "Net Banking":
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "NetBankingVC") as! NetBankingVC
            vc.paymentParamForPassing = paymentParam
            vc.paymentRelatedDetail = paymentRelatedDetail
            self.navigationController?.pushViewController(vc, animated: true)
            return
        case "Cash Card":
            return
        case "EMI":
            
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "EmiOptionVC") as! EmiOptionVC
            vc.paymentParamForPassing = paymentParam
            vc.paymentRelatedDetail = paymentRelatedDetail
            vc.emiOptionListItem = self.emiOptionListItem
            self.navigationController?.pushViewController(vc, animated: true)
            
            return
        case "SODEXO":
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "PaymentVC") as! PaymentVC
            vc.paymentParamForPassing = paymentParam
            vc.paymentRelatedDetail = paymentRelatedDetail
            vc.isSodexo = true
            self.navigationController?.pushViewController(vc, animated: true)
            return
        case "UPI":
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "UpiVC") as! UpiVC
            vc.paymentParamForPassing = paymentParam
            vc.paymentRelatedDetail = paymentRelatedDetail
            self.navigationController?.pushViewController(vc, animated: true)
            return
        default:
            print("nothing......")
        }
        
    }
    
    
}
