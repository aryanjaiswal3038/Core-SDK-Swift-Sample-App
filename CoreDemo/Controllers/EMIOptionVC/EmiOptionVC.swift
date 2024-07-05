//
//  EmiOptionVC.swift
//  CoreDemo
//
//  Created by Rishabh Jaiswal on 05/07/22.
//

import UIKit
import CommonCrypto
import PayUBizCoreKit
enum EmiCards:String{
    case Credit_Card = "Credit Card"
    case Debit_Card = "Debit Card"
}
class EmiOptionVC: UIViewController {
    
    var paymentParamForPassing = PayUModelPaymentParams()
    var paymentRelatedDetail = PayUModelPaymentRelatedDetail()
    var emiOptionListItem = [EmiOptionListModel]()
    var cerditItem = [PayUModelEMI]()
    var debitItem = [PayUModelEMI]()
    var cards = [EmiOptionCard]()
    var emiCreditItem = [EmiOptionListModel]()
    var emiDebitItem = [EmiOptionListModel]()
    @IBOutlet weak var emiOptionTblVw: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        initialiseTableVwAndDataSource()
    }
    
    func initialiseTableVwAndDataSource(){
        emiOptionTblVw.delegate = self
        emiOptionTblVw.dataSource = self
        emiOptionTblVw.separatorStyle = .none
        emiOptionTblVw.rowHeight = UITableView.automaticDimension
        emiOptionTblVw.estimatedRowHeight = 62
        emiOptionTblVw.register(UINib(nibName: EmiOptionCell.identifier, bundle: nil), forCellReuseIdentifier: EmiOptionCell.identifier)
//        if let item = paymentRelatedDetail.emiArray as? [PayUModelEMI] {
//            print("item................\(item)")
//            for itemLocal in item{
//                if let code = itemLocal.bankName{
//                    if code.last == "D"{
//                        self.debitItem.append(itemLocal)
//                        print("code.........\(code)")
//                    }else{
//                        self.cerditItem.append(itemLocal)
//                    }
//                }
//            }
//
//        }
        
        if !emiOptionListItem.isEmpty {
            
            for itemLocal in emiOptionListItem{
                if let code = itemLocal.payuModelEmi?.bankName{
                    if code.last == "D"{
                        self.emiDebitItem.append(itemLocal)
                        print("code.........\(code)")
                    }else{
                        self.emiCreditItem.append(itemLocal)
                    }
                }
            }
            
        }
        
        cards.append(EmiOptionCard(title: .Credit_Card, item: emiCreditItem))
        cards.append(EmiOptionCard(title: .Debit_Card, item: emiDebitItem))
        
    }
  

}

extension EmiOptionVC:UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cards.count
    }
    
   
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: EmiOptionCell.identifier, for: indexPath) as? EmiOptionCell else { return UITableViewCell() }
        cell.selectionStyle = .none
        let item = cards[indexPath.row]
        print("item........\(item)")
        if let title = item.title?.rawValue{
            cell.lblCard.text = title
        }
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = cards[indexPath.row]
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "CardListVC") as! CardListVC
        vc.selectedCard = item.title
        vc.paymentRelatedDetail = paymentRelatedDetail
        vc.paymentParamForPassing = paymentParamForPassing
        if let item = item.item{
            vc.payuModelItem = item
        }
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    

    
    
    
    
}

struct EmiOptionCard{
    var title:EmiCards?
    var item:[EmiOptionListModel]?
    
}
