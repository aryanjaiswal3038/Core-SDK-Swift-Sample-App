//
//  UpiVC.swift
//  CoreDemo
//
//  Created by Rishabh Jaiswal on 04/07/22.
//

import UIKit
import CommonCrypto
import PayUBizCoreKit
import PayUCustomBrowser

class UpiVC: UIViewController,PUCBWebVCDelegate {

    
    @IBOutlet weak var textContainerVw: UIView!
    let createRequest = PayUCreateRequest()
    var paymentParamForPassing = PayUModelPaymentParams()
    var paymentRelatedDetail = PayUModelPaymentRelatedDetail()
    var txn = ViewController()
    var alert = PaymentVC()
    
    @IBOutlet weak var btnVerify: UIButton!
    @IBOutlet weak var btnPay: UIButton!
    @IBOutlet weak var txtUPI: UITextField!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initialiseViews()

        
    }
    
    func initialiseViews() {
        self.txtUPI.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        textContainerVw.layer.cornerRadius = 5
        textContainerVw.layer.borderColor = UIColor.lightGray.cgColor
        textContainerVw.layer.borderWidth = 1
        textContainerVw.layer.masksToBounds = true
        btnPay.layer.cornerRadius = 5
        btnPay.layer.masksToBounds = true
    }
    
    @objc func textDidChange(_ textField:UITextField){
        guard let text = textField.text,!text.isEmpty else {return }
        
        if text.count > 0{
            btnPay.backgroundColor = .systemGreen
            btnPay.isUserInteractionEnabled = true
        }else{
            btnPay.backgroundColor = .lightGray
            btnPay.isUserInteractionEnabled = false
        }
    }
    
    @IBAction func tapPay(_ sender: UIButton) {
        validateCheck()
    }
    
    
    func validateCheck(){
        
        guard let upiId = txtUPI.text,!upiId.isEmpty else { return  }
        paymentParamForPassing.vpa = txtUPI.text
        paymentParamForPassing.transactionID = txn.getTxnID()
        getHashFromTxnParams(paymentParamForPassing, salt: kSalt) { hash in
            if let localHash = hash{
                self.createRequestAfterHash(hash: localHash)
            }
        }
        
    }

    @IBAction func tapVerify(_ sender: UIButton) {
        
    }
    
    func payUTransactionCancel() {
        print("error")
    }
    
    func payUSuccessResponse(_ response: Any!) {
        navigationController?.popToViewController(self, animated: true)
        self.alert.showAlert(title: "Success", message: "\(response ?? "")")
        print("error1.....   \(response)")

    }
    
    func payUFailureResponse(_ response: Any!) {
        navigationController?.popToViewController(self, animated: true)
        self.alert.showAlert(title: "Failure", message: "\(response ?? "")")
        print("error1.....   \(response)")

    }
    
    
    func payUSuccessResponse(_ payUResponse: Any!, surlResponse: Any!) {
        print("error1.....   \(payUResponse)")
        self.alert.showAlert(title: "Success", message: "\(payUResponse ?? "")")
    }
    
    func payUFailureResponse(_ payUResponse: Any!, furlResponse: Any!) {
        print("error1.....   \(payUResponse)")
        self.alert.showAlert(title: "Failure", message: "\(payUResponse ?? "")")
    }
    func payUConnectionError(_ notification: [AnyHashable : Any]!) {
        print("error3.....   \(notification)")
    }
    
    func createRequestAfterHash(hash:String){
      
        paymentParamForPassing.hashes.paymentHash = hash
        
        print("setPaymentParam.........\(self.paymentParamForPassing)")
        createRequest.createRequest(withPaymentParam: paymentParamForPassing, forPaymentType: PAYMENT_PG_UPI, withCompletionBlock: { request, postParam, error in
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
    
//        createRequest.createRequest(withPaymentParam: paymentParamForPassing, forPaymentType: PAYMENT_PG_UPI, withCompletionBlock: { [weak self] request, postParam, error in
//            if error == nil {
//                print("request...........\(request.hashValue)")
//
//                let vc = self?.storyboard?.instantiateViewController(withIdentifier: "WebkitVC") as! WebkitVC
//                vc.requestUrl = request
//                self?.navigationController?.pushViewController(vc, animated: true)
//            } else {
//
//                print("error...........\(error)")
//            }
//        })
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
