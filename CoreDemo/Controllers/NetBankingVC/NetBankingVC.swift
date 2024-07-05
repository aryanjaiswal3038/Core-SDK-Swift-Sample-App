//
//  NetBankingVC.swift
//  CoreDemo
//
//  Created by Rishabh Jaiswal on 04/07/22.
//

import UIKit
import CommonCrypto
import PayUBizCoreKit
import PayUCustomBrowser

class NetBankingVC: UIViewController, PUCBWebVCDelegate {
    
    let createRequest = PayUCreateRequest()
    var paymentParamForPassing = PayUModelPaymentParams()
    var paymentRelatedDetail = PayUModelPaymentRelatedDetail()
    var netBankingItem = [NetBankingModel]()
    var txn = ViewController()
    @IBOutlet weak var netBankingTableVw: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        registerCellAndDataSource()
        
    }
    

    func registerCellAndDataSource(){
        netBankingTableVw.register(UINib(nibName: NetBankingCell.identifier, bundle: nil), forCellReuseIdentifier: NetBankingCell.identifier)
        netBankingTableVw.delegate = self
        netBankingTableVw.dataSource = self
        netBankingTableVw.separatorStyle = .none
        netBankingTableVw.rowHeight = UITableView.automaticDimension
        netBankingTableVw.estimatedRowHeight = 65
        netBankingTableVw.estimatedSectionHeaderHeight = 65
        netBankingTableVw.sectionHeaderHeight = UITableView.automaticDimension
        
        if let item = paymentRelatedDetail.netBankingArray as? [PayUModelNetBanking]{
            if !self.netBankingItem.isEmpty{
                self.netBankingItem.removeAll()
            }
            item.forEach { netModel in
                self.netBankingItem.append(NetBankingModel(netBanking: netModel, isOpen: false))
            }
            self.netBankingTableVw.reloadData()
        }
        
        
    }

}

extension NetBankingVC:UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return netBankingItem.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let header = Bundle.main.loadNibNamed(NetBankingHeader.identifier, owner: self, options: nil)?.first as? NetBankingHeader else { return UIView() }
        return header
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: NetBankingCell.identifier, for: indexPath) as? NetBankingCell else { return UITableViewCell() }
        let itemToSend = netBankingItem[indexPath.row]
        cell.netBankingItem = itemToSend
        cell.btnProceedAndPay.tag = indexPath.row
        cell.btnProceedAndPay.addTarget(self, action: #selector(tapPay), for: .touchUpInside)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        UIView.animate(withDuration: 0.45) {
            for (index,value) in self.netBankingItem.enumerated(){
                var value = value
                value.isOpen = false
                self.netBankingItem[index] = value
                
            }
            self.netBankingItem[indexPath.row].isOpen = !self.netBankingItem[indexPath.row].isOpen
            DispatchQueue.main.async {
                self.netBankingTableVw.reloadData()
            }
           
            
        }
        
        
    }
    
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    func payUTransactionCancel() {
        print("error")
    }
    
    func payUSuccessResponse(_ response: Any!) {
        navigationController?.popToViewController(self, animated: true)
        self.showAlert(title: "Success", message: "\(response ?? "")")
        print("error1.....   \(response)")

    }
    
    func payUFailureResponse(_ response: Any!) {
        navigationController?.popToViewController(self, animated: true)
        self.showAlert(title: "Failure", message: "\(response ?? "")")
        print("error1.....   \(response)")

    }
    
    
    func payUSuccessResponse(_ payUResponse: Any!, surlResponse: Any!) {
        print("error1.....   \(payUResponse)")
        self.showAlert(title: "Success", message: "\(payUResponse ?? "")")
    }
    
    func payUFailureResponse(_ payUResponse: Any!, furlResponse: Any!) {
        print("error1.....   \(payUResponse)")
        self.showAlert(title: "Failure", message: "\(payUResponse ?? "")")
    }
    func payUConnectionError(_ notification: [AnyHashable : Any]!) {
        print("error3.....   \(notification)")
    }
    
    @objc func tapPay(_ sender:UIButton){
        let itemToSend = netBankingItem[sender.tag]
        
        if let netBanking = itemToSend.netBanking{
            paymentParamForPassing.transactionID = txn.getTxnID()
            paymentParamForPassing.bankCode = netBanking.bankCode
            getHashFromTxnParams(paymentParamForPassing, salt: kSalt) { [self] hash in
                
                if let hashLocal = hash{
                    
                    self.paymentParamForPassing.hashes.paymentHash = hashLocal
                    
                    print("setPaymentParam.........\(self.paymentParamForPassing)")
                    
                    createRequest.createRequest(withPaymentParam: paymentParamForPassing, forPaymentType: PAYMENT_PG_NET_BANKING, withCompletionBlock: { request, postParam, error in
                        if error == nil {
                            print("Success")
                            print("PostParam......\(postParam)")
                            //It is good to go state. You can use request parameter in webview to open Payment Page
                            var err: Error? = nil
                            let webVC = try? PUCBWebVC(postParam: postParam, url: URL(string: "https://test.payu.in/_payment"), merchantKey: self.paymentParamForPassing.key)
                            
                            webVC!.cbWebVCDelegate = self
                            webVC!.view.frame = CGRect(x: 0, y: 0, width: self.view.frame.width,
                                                       height: self.view.frame.height - 100)
                            
                            
                            if err == nil {
                                //self.present(webVC!, animated: true, completion: nil)
                                //self.navigationController?.pushViewController(webVC!, animated: true)
                                self.navigationController?.pushViewController(webVC!, animated: true)
                            }
                            else{
                                print("fjvjkf...\(err)")
                            }
                            
                        } else {
                            print("failure")
                            //Something went wrong with Parameter, error contains the error Message string
                        }
                    })
//                    self.createRequest.createRequest(withPaymentParam: self.paymentParamForPassing, forPaymentType: PAYMENT_PG_NET_BANKING, withCompletionBlock: { [weak self] request, postParam, error in
//                        if error == nil {
//                            print("request...........\(request)")
//                            let vc = self?.storyboard?.instantiateViewController(withIdentifier: "WebkitVC") as! WebkitVC
//                            vc.requestUrl = request
//                            self?.navigationController?.pushViewController(vc, animated: true)
//                        } else {
//
//                            print("error...........\(error)")
//                        }
//                    })
                    
                    
                }
            }
        }
        
    }
    
    
    private func getHashFromTxnParams(_ txnParam: PayUModelPaymentParams?, salt: String?,completion:@escaping((String?)->Void)){
           
           var hashSequence: String? = nil
           if let key = txnParam?.key, let txnID = txnParam?.transactionID, let amount = txnParam?.amount, let productInfo = txnParam?.productInfo, let firstname = txnParam?.firstName, let email = txnParam?.email, let udf1 = txnParam?.udf1, let udf2 = txnParam?.udf2, let udf3 = txnParam?.udf3, let udf4 = txnParam?.udf4, let udf5 = txnParam?.udf5{
               hashSequence = "\(key)|\(txnID)|\(amount)|\(productInfo)|\(firstname)|\(email)|\(udf1)|\(udf2)|\(udf3)|\(udf4)|\(udf5)||||||\(salt ?? "")"
           }
          // print("hashSequence............\(hashSequence)")
           let hash = hashSequence?.sha512()
           completion(hash)
       }
    
}

struct NetBankingModel{
    var netBanking:PayUModelNetBanking?
    var isOpen = false
}
