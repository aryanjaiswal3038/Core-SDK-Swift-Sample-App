//
//  PaymentVC.swift
//  CoreDemo
//
//  Created by Rishabh Jaiswal on 22/06/22.
//

import UIKit
import CommonCrypto
import PayUBizCoreKit
import PayUCustomBrowser
class PaymentVC: UIViewController, PUCBWebVCDelegate {
   
    
    
    var isSodexo = false
   
    @IBOutlet weak var lblWarning: UILabel!
    let createRequest = PayUCreateRequest()
    var paymentParamForPassing = PayUModelPaymentParams()
    var paymentRelatedDetail = PayUModelPaymentRelatedDetail()
    var txn = ViewController()
    @IBOutlet weak var expiryYearVw: UIView!
    @IBOutlet weak var cvvVw: UIView!
    @IBOutlet weak var expiryMonthVw: UIView!
    @IBOutlet weak var nameVw: UIView!
    @IBOutlet weak var cardNumberVw: UIView!
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var saveCardSwitch: UISwitch!
    @IBOutlet weak var txtMonth: UITextField!
    @IBOutlet weak var txtExpYear: UITextField!
    @IBOutlet weak var txtCVV: UITextField!
    @IBOutlet weak var txtCardNumber: UITextField!
    
    @IBOutlet weak var btnPay: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        initialViews()
        // Do any additional setup after loading the view.
    }
    
    
    func initialViews(){
        expiryYearVw.makeRoundCorner(5)
        expiryYearVw.makeBorder(1, color: .lightGray)
        cvvVw.makeRoundCorner(5)
        cvvVw.makeBorder(1, color: .lightGray)
        expiryMonthVw.makeRoundCorner(5)
        expiryMonthVw.makeBorder(1, color: .lightGray)
        cardNumberVw.makeRoundCorner(5)
        cardNumberVw.makeBorder(1, color: .lightGray)
        nameVw.makeRoundCorner(5)
        nameVw.makeBorder(1, color: .lightGray)
        btnPay.makeRoundCorner(5)
        txtCardNumber.delegate = self
        lblWarning.isHidden = true
        
    }

    func validationCheck(){
//        guard let name = txtName.text,!name.isEmpty else { return  }
//        guard let cardNumber = txtCardNumber.text,!cardNumber.isEmpty else { return  }
//        guard let month = txtMonth.text,!month.isEmpty else { return  }
//        guard let expYear = txtExpYear.text,!expYear.isEmpty else { return  }
//        guard let cvvCard = txtCVV.text,!cvvCard.isEmpty else { return  }
        
      //  paymentParamForPassing.offerKey = "499RsDiscountonVISAc@wJQdN0jMVLNL"
//        paymentParamForPassing.cardNumber = "4012001037141112"
//        paymentParamForPassing.nameOnCard = "Rishabh"
//        paymentParamForPassing.expiryYear = "2025"
//        paymentParamForPassing.expiryMonth = "05"
      //  paymentParamForPassing.shouldSaveCard = true
    
       
       // paymentParamForPassing.cvv = "123"
//      //  paymentParamForPassing.cardToken = "11abcf09ba3d4e69274950"
//        paymentParamForPassing.storeCardName = "Rishabh"
        paymentParamForPassing.transactionID = "12gbh35"
        paymentParamForPassing.bankCode = "UPI"
      //  paymentParamForPassing.userToken = "hvgxhsg"
        paymentParamForPassing.vpa = "7879357664@paytm"
    
        
        getHashFromTxnParams(paymentParamForPassing, salt: kSalt) {[weak self] hash in
            if let generatedHash = hash{
                self?.createRequestAfterHash(hash: generatedHash)
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
    
    //MARK:- CREATE REQUEST AFTER HASH
    
    func createRequestAfterHash(hash:String){
      
        paymentParamForPassing.hashes.paymentHash = hash
        if isSodexo{
            paymentParamForPassing.isNewSodexoCard = true
            createRequest.createRequest(withPaymentParam: paymentParamForPassing, forPaymentType: PAYMENT_PG_SODEXO, withCompletionBlock: { request, postParam, error in
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
                    //It is good to go state. You can use request parameter in webview to open Payment Page
                } else {
                    print("failure")
                    print("fjvjkf...\(error)")
                    //Something went wrong with Parameter, error contains the error Message string
                }
            })
        }
        else{
            print("setPaymentParam.........\(paymentParamForPassing)")
            createRequest.createRequest(withPaymentParam: paymentParamForPassing, forPaymentType: PAYMENT_PG_UPI, withCompletionBlock: { request, postParam, error in
                if error == nil {
                    print("Success")
                    print("PostParam......\(postParam)")
                    //It is good to go state. You can use request parameter in webview to open Payment Page
                    var err: Error? = nil
                    let webVC = try? PUCBWebVC(postParam: postParam, url: URL(string: "https://secure.payu.in/_payment"), merchantKey: self.paymentParamForPassing.key)
                    
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
        }
   
//
//        createRequest.createRequest(withPaymentParam: paymentParamForPassing, forPaymentType: PAYMENT_PG_CCDC, withCompletionBlock: { [weak self] request, postParam, error in
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
    
    
    
    
    @IBAction func saveCard(_ sender: UISwitch) {
    }
    @IBAction func tapPay(_ sender: UIButton) {
        validationCheck()
        
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

}
   



extension PaymentVC:UITextFieldDelegate{
    func textFieldDidEndEditing(_ textField: UITextField) {
        if isSodexo{
            if textField == self.txtCardNumber{
                if let item = paymentRelatedDetail.netBankingArray as? [PayUModelNetBanking]{
                   
                    item.forEach { netModel in
                        print("netModel...........\(netModel)")
                    }
                    
                }
                print("true........................\(textField.text!)")
            }
        }else{
            
        }
    }
}
