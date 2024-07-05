//
//  CardListVC.swift
//  CoreDemo
//
//  Created by Rishabh Jaiswal on 05/07/22.
//

import UIKit
import CommonCrypto
import PayUBizCoreKit
class CardListVC: UIViewController {
    var paymentParamForPassing = PayUModelPaymentParams()
    var paymentRelatedDetail = PayUModelPaymentRelatedDetail()
    var selectedCard : EmiCards?
    var payuModelItem = [EmiOptionListModel]()
    var headerData = [String]()
    var bankData = [String:[EmiOptionListModel]]()
    @IBOutlet weak var cardListTblVw: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        initialiseTableVwAndDataSource()
    }
    
    func initialiseTableVwAndDataSource(){
        cardListTblVw.delegate = self
        cardListTblVw.dataSource = self
        cardListTblVw.separatorStyle = .none
        cardListTblVw.rowHeight = UITableView.automaticDimension
        cardListTblVw.estimatedRowHeight = 62
        cardListTblVw.register(UINib(nibName: CardListCell.identifier, bundle: nil), forCellReuseIdentifier: CardListCell.identifier)
        self.cardListTblVw.reloadData()
        if selectedCard == .Debit_Card{
            for localData in payuModelItem{
                if var name = localData.payuModelEmi?.bankName{
                    let nameAfterRemove = name.dropLast()
                    if self.bankData.keys.contains("\(nameAfterRemove)"){
                        self.bankData["\(nameAfterRemove)"]?.append(localData)
                    }else{
                        self.bankData["\(nameAfterRemove)"] = [localData]
                        self.headerData.append("\(nameAfterRemove)")
                    }
                }
               
            }
        }else{
            for localData in payuModelItem{
                if self.bankData.keys.contains(localData.payuModelEmi?.bankName ?? ""){
                    self.bankData[localData.payuModelEmi?.bankName ?? ""]?.append(localData)
                }else{
                    self.bankData[localData.payuModelEmi?.bankName ?? ""] = [localData]
                    self.headerData.append(localData.payuModelEmi?.bankName ?? "")
                }
            }
        }
       
       
    }
   

}

extension CardListVC:UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  self.headerData.count
    }
    
   
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CardListCell.identifier, for: indexPath) as? CardListCell else { return UITableViewCell() }
        cell.selectionStyle = .none
        let item =  self.headerData[indexPath.row]
      
        cell.lblBank.text = item
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
        tapSelectedOption(indexPath: indexPath)
        
        
    }
    
    
    func tapSelectedOption(indexPath:IndexPath){
        let item = self.headerData[indexPath.row]
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "EMICardVC") as! EMICardVC
        if let value = self.bankData[item]{
            vc.payuModelItem = value
        }
        vc.paymentParamForPassing = paymentParamForPassing
        vc.paymentRelatedDetail = paymentRelatedDetail
        vc.cardName = item
        self.navigationController?.pushViewController(vc, animated: true)
    }

    
    
    
    
}


struct CardData{
    var title:String?
    var item:[PayUModelEMI]?
}
