//
//  SelectedEmiOptionVC.swift
//  CoreDemo
//
//  Created by Rishabh Jaiswal on 05/07/22.
//

import UIKit
import CommonCrypto
import PayUBizCoreKit
class SelectedEmiOptionVC: UIViewController {
    var selectedItem:((EmiOptionListModel?)->Void)?
    var paymentParamForPassing = PayUModelPaymentParams()
    var paymentRelatedDetail = PayUModelPaymentRelatedDetail()
    var payuModelItem = [EmiOptionListModel]()
    
    @IBOutlet weak var optionTableVw: UITableView!
    @IBOutlet weak var actionVw: UIView!
    @IBOutlet weak var bgView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        initialiseTableVwAndDataSource()
       
    }
    
    
    func initialiseTableVwAndDataSource(){
        
        actionVw.roundCornersFinal(corners: [.topLeft,.topRight], radius: 5)
        optionTableVw.delegate = self
        optionTableVw.dataSource = self
        optionTableVw.separatorStyle = .none
        optionTableVw.rowHeight = UITableView.automaticDimension
        optionTableVw.estimatedRowHeight = 62
        optionTableVw.register(UINib(nibName: SelectedEmiOptionCell.identifier, bundle: nil), forCellReuseIdentifier: SelectedEmiOptionCell.identifier)
        self.optionTableVw.reloadData()
        
       
       
    }

    @IBAction func tapDismiss(_ sender: UITapGestureRecognizer) {
        
       // print("dismiss............")
        self.dismiss(animated: true, completion: nil)
    }
    

}
extension SelectedEmiOptionVC:UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  payuModelItem.count
    }
    
   
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SelectedEmiOptionCell.identifier, for: indexPath) as? SelectedEmiOptionCell else { return UITableViewCell() }
        cell.selectionStyle = .none
        let item = payuModelItem[indexPath.row]
        cell.model = item
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = payuModelItem[indexPath.row]
        self.dismiss(animated: true) {
            self.selectedItem?(item)
        }
    
    }
    

    
    
    
    
}
