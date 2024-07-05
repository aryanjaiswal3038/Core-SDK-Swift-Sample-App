//
//  EMICardVC.swift
//  CoreDemo
//
//  Created by Rishabh Jaiswal on 22/06/22.

import UIKit
import CommonCrypto
import PayUBizCoreKit
import PayUCustomBrowser
class EMICardVC: UIViewController, PUCBWebVCDelegate {

    let createRequest = PayUCreateRequest()
    var paymentParamForPassing = PayUModelPaymentParams()
    var paymentRelatedDetail = PayUModelPaymentRelatedDetail()
    var selectedCard : EmiCards?
    var payuModelItem = [EmiOptionListModel]()
    var txn = ViewController()
    var alert = PaymentVC()
    var cardName = String()
    var payUModelEMI:EmiOptionListModel?
    @IBOutlet weak var btnProceedToPay: UIButton!
    @IBOutlet weak var txtYear: UITextField!
    @IBOutlet weak var expiryYearVw: UIView!
    @IBOutlet weak var txtMonth: UITextField!
    @IBOutlet weak var expiryMonthVw: UIView!
    @IBOutlet weak var txtCVV: UITextField!
    @IBOutlet weak var cvvVw: UIView!
    @IBOutlet weak var emiPlanVw: UIView!
    @IBOutlet weak var carNumberVw: UIView!
    @IBOutlet weak var txtEmiPlan: UITextField!
    @IBOutlet weak var lblCardWarning: UILabel!
    @IBOutlet weak var txtCardNumber: UITextField!
    @IBOutlet weak var lblCardName: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        setupInitialViews()
        // Do any additional setup after loading the view.
    }
    

    func setupInitialViews(){
        btnProceedToPay.makeRoundCorner(5)
        expiryYearVw.makeRoundCorner(5)
        expiryYearVw.makeBorder(1, color:.lightGray)
        expiryMonthVw.makeRoundCorner(5)
        expiryMonthVw.makeBorder(1, color:.lightGray)
        cvvVw.makeRoundCorner(5)
        cvvVw.makeBorder(1, color:.lightGray)
        emiPlanVw.makeRoundCorner(5)
        emiPlanVw.makeBorder(1, color:.lightGray)
        carNumberVw.makeRoundCorner(5)
        carNumberVw.makeBorder(1, color:.lightGray)
        self.lblCardWarning.isHidden = true
        self.lblCardName.text = "\(cardName) Card"
        
        
    }
    
    
    @IBAction func tapProceedToPay(_ sender: UIButton) {
        validationCheck()
    }
    
    func validationCheck(){
        guard let cardNumber = txtCardNumber.text,!cardNumber.isEmpty else { return  }
        guard let month = txtMonth.text,!month.isEmpty else { return  }
        guard let year = txtYear.text,!year.isEmpty else { return  }
        guard let cvv = txtCVV.text,!cvv.isEmpty else { return  }
       
        let emiDuration = self.payUModelEMI?.tenure ?? ""
        paymentParamForPassing.cardNumber = cardNumber
        paymentParamForPassing.expiryMonth = month
        paymentParamForPassing.expiryYear = year
        paymentParamForPassing.cvv = cvv
        paymentParamForPassing.transactionID = txn.getTxnID()
        paymentParamForPassing.cardName = payUModelEMI?.payuModelEmi?.bankCode ?? ""
        paymentParamForPassing.bankCode = payUModelEMI?.payuModelEmi?.bankCode ?? ""
       
        
        
        getHashFromTxnParams(paymentParamForPassing, salt: kSalt) {[weak self] hash in
            if let generatedHash = hash{
                self?.createRequestAfterHash(hash: generatedHash)
            }
        }
    
       
    }
    
    
    
    @IBAction func tapSelectEmiOption(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "SelectedEmiOptionVC") as! SelectedEmiOptionVC
        vc.payuModelItem = payuModelItem
        vc.paymentRelatedDetail = paymentRelatedDetail
        vc.paymentParamForPassing = paymentParamForPassing
        vc.selectedItem = { [weak self] item in
            self?.payUModelEMI = item
            self?.txtEmiPlan.text = item?.tenure ?? ""
        }
        
        self.navigationController?.present(vc, animated: true, completion: nil)
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
       
       //MARK:- CREATE REQUEST AFTER HASH
       
       func createRequestAfterHash(hash:String){
         
           paymentParamForPassing.hashes.paymentHash = hash
           
           print("setPaymentParam.........\(self.paymentParamForPassing)")
           createRequest.createRequest(withPaymentParam: paymentParamForPassing, forPaymentType: PAYMENT_PG_EMI, withCompletionBlock: { request, postParam, error in
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
           
           
//           createRequest.createRequest(withPaymentParam: paymentParamForPassing, forPaymentType: PAYMENT_PG_EMI, withCompletionBlock: { [weak self] request, postParam, error in
//               if error == nil {
//                   print("request...........\(request.hashValue)")
//
//                   let vc = self?.storyboard?.instantiateViewController(withIdentifier: "WebkitVC") as! WebkitVC
//                   vc.requestUrl = request
//                   self?.navigationController?.pushViewController(vc, animated: true)
//               } else {
//
//                   print("error...........\(error)")
//               }
//           })
       }
    
}
