//
//  ViewController.swift
//  CoreDemo
//
//  Created by Rishabh Jaiswal on 22/06/22.
//

import UIKit
import CommonCrypto
import PayUBizCoreKit
let kSalt = "CMKta5xB"
let kKey = "rM5M43"
let kSurl: String = "https://payu.herokuapp.com/ios_success"
let kFurl: String = "https://payu.herokuapp.com/ios_failure"
class ViewController: UIViewController {
    var emiResult = [AnyHashable : Any]()
    var vasForMobile = PayUModelVAS()
    var modelPayment: PayUModelPaymentRelatedDetail?
    let createRequest = PayUCreateRequest()
    let paymentParamForPassing = PayUModelPaymentParams()
    let checkoutStoryboardID = "PUUIMainStoryBoard"
    var emiOptionListItem = [EmiOptionListModel]()
    @IBOutlet weak var btnPay: UIButton!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.isShowActivity(false)
        setUpPaymentParam()
//        btnPay.addTarget(self, action: #selector(tapPay), for: .touchUpInside)
        btnPay.layer.cornerRadius = 5
        btnPay.layer.masksToBounds = true
        
        getAllOfferDetails(bizPaymentParam: paymentParamForPassing) { offerDetail, error in
            print("offerDetails......\(offerDetail)")

        }
        validateOfferDetails(bizPaymentParam: paymentParamForPassing) { offerDetail, error in
            
        }
      
    }
    
    func getAllOfferDetails(
        bizPaymentParam: PayUModelPaymentParams,
        onCompletion: @escaping (_ offerDetail: PayUModelAllOfferDetail?, _ error: Error?) -> Void){
            let webServiceResponse = PayUWebServiceResponse()
            webServiceResponse?.getAllOfferDetails(paymentParamForPassing, completionBlockForHashGeneration: { json, hashcompletion in
                print(self.paymentParamForPassing)
                if let hashDict = json as? [String: String] {
                let hashName = hashDict["hashName"] ?? ""
                let hashStringWithoutSalt = hashDict["hashString"] ?? ""
                    let hashWithSalt = hashStringWithoutSalt.appending(kSalt)
                    print("hashWithSalt3......\(hashWithSalt)")
                    let hash = hashWithSalt.sha512()
                    print("json3......\(hash)")
                    print("json4......\(hashName)")
                    hashcompletion!([hashName : hash])
                }
            },
            completionBlockForAPIResponse: { [weak self] offerDetails, errorMsg, _ in
                //  guard let self = self else { return }
                //  if var offerDetails = offerDetails {
                print("offerDetails......\(offerDetails)")
                //                    onCompletion(offerDetails, nil)
                //                } else {
                //                    onCompletion(nil, getErrorObjectFor(msg: errorMsg))
                //                }
            })

    }
    
    func validateOfferDetails(bizPaymentParam : PayUModelPaymentParams, onCompletion : @escaping (_ offerDetail: PayUModelOfferDetail?, _ error: Error?) -> Void){
        
        let webServiceResponse = PayUWebServiceResponse()
        webServiceResponse?.validateOfferDetails(paymentParamForPassing, completionBlockForHashGeneration: { json, hashcompletion in
            if let hashDict = json as? [String: String] {
            let hashName = hashDict["hashName"] ?? ""
            let hashStringWithoutSalt = hashDict["hashString"] ?? ""
                let hashWithSalt = hashStringWithoutSalt.appending(kSalt)
                print("hashWithSalt......\(hashWithSalt)")
                let hash = hashWithSalt.sha512()
                print("json1......\(hash)")
                print("json......\(hashName)")
                hashcompletion!([hashName : hash])
                
            }
        }, completionBlockForAPIResponse: { [weak self] offerDetails, errorMsg, json in
            print("offerDetails......\(offerDetails)")
            print("offerValidation......\(json)")
            print("offerError......\(errorMsg)")

        })
        
    }
 
    func getErrorObjectFor(code: Int? = nil, msg: String?) -> NSError {
        let errorObj = NSError(
            domain: getBundleIdentifier(),
            code: code ?? 9999,
            userInfo: [NSLocalizedDescriptionKey: NSLocalizedString("", value: msg ?? "Something went wrong", comment: "")]
        )
        return errorObj
    }
    func getBundleIdentifier() -> String {
        let bundle = Bundle(for: ViewController.self)
        return bundle.bundleIdentifier ?? ""
    }
    @IBAction func tapPay(_ sender: UIButton) {
        generateHashLocally()
//        print("genertae hash locally........\(generateHashLocally())")
    }
    

    
    //MARK:- SETUP PAYMENT PARAM
    
    func setUpPaymentParam(){
        
        paymentParamForPassing.key = kKey
        paymentParamForPassing.transactionID = getTxnID()
        paymentParamForPassing.amount = "10000"
        paymentParamForPassing.productInfo = "Product Information"
        paymentParamForPassing.firstName = "Abhishek"
        paymentParamForPassing.email = "admi@gmail.com"
        paymentParamForPassing.userCredentials = ""
        paymentParamForPassing.phoneNumber = "9044271025"
        paymentParamForPassing.surl = "https://payu.herokuapp.com/ios_success"
        paymentParamForPassing.furl = "https://payu.herokuapp.com/ios_failure"
        paymentParamForPassing.udf1 = ""
        paymentParamForPassing.udf2 = ""
        paymentParamForPassing.udf3 = ""
        paymentParamForPassing.udf4 = ""
        paymentParamForPassing.udf5 = ""
        paymentParamForPassing.environment = ENVIRONMENT_PRODUCTION
        paymentParamForPassing.offerParams = PayUModelOfferParams()
        paymentParamForPassing.offerParams?.userToken = "anshul_bajpai_token"
        paymentParamForPassing.cardNumber = "4012001037141112"
        paymentParamForPassing.isSIInfo = true
        paymentParamForPassing.offerParams?.offerKeys = ["iOSWalletOffer@0zUM5cZOG66g"]
        paymentParamForPassing.category = "CREDITCARD"
        paymentParamForPassing.bankCode = "CC"
        paymentParamForPassing.offerParams?.paymentCode = "CC"
        paymentParamForPassing.offerParams?.clientId = ""

    
    
        
//        paymentParamForPassing.offerKey = "offertest@1411"
//        paymentParamForPassing.cardNumber = "5123456789012346"
//        paymentParamForPassing.nameOnCard = "Demo"
//        paymentParamForPassing.expiryYear = "2023"
//        paymentParamForPassing.expiryMonth = "11"
//        paymentParamForPassing.cvv = "123"
//        paymentParamForPassing.storeCardName = "My TestCard"
       
        
    }
    
    
    
    
    //MARK:- GENERATE HASH LOCALLY
    func generateHashLocally(){
        getHashFromTxnParams(self.paymentParamForPassing, salt: kSalt) { [weak self] hash in
            if let generatedHash = hash{
                self?.createRequestAfterHash(hash: generatedHash)
            }
        }
        

    }
    

    func isShowActivity(_ show:Bool){
        DispatchQueue.main.async {
            if show{
                self.activityIndicator.startAnimating()
                self.activityIndicator.isHidden = false
            }else{
                self.activityIndicator.stopAnimating()
                self.activityIndicator.isHidden = true
            }
        }
    }
    
    //MARK:- CREATE REQUEST AFTER HASH
    
    func createRequestAfterHash(hash:String){
      
        isShowActivity(true)
        let group = DispatchGroup()
        let queue = DispatchQueue(label: "myqueue", qos: .utility, attributes: .concurrent)
            group.enter()
            self.paymentParamForPassing.hashes.paymentHash = hash
            self.getPaymentDetailsrelatedHash(self.paymentParamForPassing, salt: kSalt) { hash in
                if let localHash = hash{
                    self.paymentParamForPassing.hashes.paymentRelatedDetailsHash = localHash
                }
                group.leave()
            }
            group.enter()
            self.fetchApiServices(paymentParamForPassing: self.paymentParamForPassing) { [weak self] modelPayment, errorMessage, extraParam in
                
                if let error = errorMessage {
                    print("Error occured in fetching payment related details: \(error)")
                } else {
                    
                    if let json = extraParam as? [String:Any]{
                        
                        self?.modelPayment = modelPayment
                        
                        if let jsonResponse = json["JsonResponse"] as? [String:Any]{
                         
                            let ibiboCode = jsonResponse["ibiboCodes"] as? [String:Any]
    
                        }
                        
                        
                        
                        
                    }
                }
                group.leave()
            }
        group.enter()
        self.vasForMobileSDK(self.paymentParamForPassing, salt: kSalt) { hash in
            if let localHash = hash{
                self.paymentParamForPassing.hashes.vasForMobileSDKHash = localHash
            }
            group.leave()
        }
        group.enter()
        self.vasForMobileSDK(paymentParamForPassing: self.paymentParamForPassing) { modelPayment, errorMessage, json in
            
            if let error = errorMessage {
                print("Error occured in fetching payment related details: \(error)")
            } else {
                
                if let json1 = json as? [String:Any]{
                    
                    if let jsonResponse = json1["JsonResponse"] as? [String:Any]{
                        
                        let ibiboCode = jsonResponse["sbiMaesBins"] as? [Any]
                        print(ibiboCode)
                    }
  
                }
            }
            group.leave()
        }
        
        group.enter()
        
        self.verifyPayment(self.paymentParamForPassing, salt: kSalt) { hash in
            if let localHash = hash{
                self.paymentParamForPassing.hashes.verifyTransactionHash = localHash
            }
            group.leave()
        }
        group.enter()
        self.verfyPayment(paymentParamForPassing: self.paymentParamForPassing) { modelPayment, errorMessage, json in
            print(modelPayment)
            group.leave()
        }
        
        group.enter()
        self.checkIsDomestic(self.paymentParamForPassing, salt: kSalt) { hash in
            if let localHash = hash{
                self.paymentParamForPassing.hashes.checkIsDomesticHash = localHash
            }
            group.leave()
        }
        group.enter()
        self.checkIsDomestic(paymentParamForPassing: paymentParamForPassing) { modelPayment, errorMessage, json in
            print(json)
            group.leave()
        }
        
        group.enter()
        self.getBinInfo(paymentParamForPassing, salt: kSalt) { hash in
            if let localHash = hash{
                self.paymentParamForPassing.hashes.getBinInfoHash = localHash
            }
            group.leave()
        }
        group.enter()
        self.getBinInfo(paymentParamForPassing: paymentParamForPassing) { modelPayment, errorMessage, json in
            print(json)
            group.leave()
        }
      
            group.enter()
            self.getEmiAmountAccordingToInterestHash(self.paymentParamForPassing, salt: kSalt) { hash in
                if let localHash = hash{
                    self.paymentParamForPassing.hashes.emiDetailsHash = localHash
                }
                group.leave()
            }
        
       
            group.enter()
            getEmiAmountAccordingToInterest(paymentParamForPassing: paymentParamForPassing) { result, status, json in
                if let result = result{
                    self.emiResult = result
                    
                }
                group.leave()
//                print("result.........\(result)")
//                print("status.........\(status)")
//                print("json.........\(json)")
                
            }
            
        group.notify(queue: queue) {
            
            DispatchQueue.main.async {
                if let item = self.modelPayment?.emiArray as? [PayUModelEMI] {
                    for payuModel in item{
                        
                        if let value = self.emiResult[payuModel.bankCode] as? PayUModelEMIDetails {
                            self.emiOptionListItem.append(EmiOptionListModel(payuModelEmi: payuModel, amount: value.amount, bankCharge: value.bankCharge, bankRate: value.bankRate, emiAmount: value.emiAmount, emiBankInterest: value.emiBankInterest, tenure: value.tenure, transactionAmount: value.transactionAmount,emiInterestPaid: value.emiInterestPaid))
                            print("value in ........\(value.bankCharge)")
                        }
                    }
                }
                self.isShowActivity(false)
                let storyBoard = UIStoryboard.init(name: "Main", bundle: nil)
                let optionVc = storyBoard.instantiateViewController(withIdentifier: "PaymentOptionVC") as! PaymentOptionVC
                //optionVc.optionDict = ibiboCode
                if let details = self.modelPayment{
                    optionVc.paymentRelatedDetail = details
                }
                optionVc.emiOptionListItem = self.emiOptionListItem
                optionVc.paymentParam = self.paymentParamForPassing
                self.navigationController?.pushViewController(optionVc, animated: true)
            }
            print("emiResult...........\(self.emiResult)")
            
            
            
//            for (key,value) in self.emiResult{
//                if let localValue = value as? PayUModelEMIDetails{
//                    print("localValue..............\(localValue)")
//                    print("key..............\(key)")
//                }
//
//            }
//            print("modelPaymen...........\(self.modelPayment)")
        }
//        createRequest.createRequest(withPaymentParam: paymentParamForPassing, forPaymentType: PAYMENT_PG_EMI, withCompletionBlock: { [weak self] request, postParam, error in
//            if error == nil {
//                print("postParam...........\(postParam)")
//
////                let vc = self?.storyboard?.instantiateViewController(withIdentifier: "WebkitVC") as! WebkitVC
////                vc.requestUrl = request
////                self?.navigationController?.pushViewController(vc, animated: true)
//            } else {
//
//                print("error...........\(error)")
//            }
//        })
    }
    
    
    //MARK:- FETCH PAYMENT DETAILS
    func fetchApiServices(paymentParamForPassing:PayUModelPaymentParams,completion:@escaping((_ modelPayment:PayUModelPaymentRelatedDetail?,_ errorMessage:String?,_ json:Any?)->Void)){
        let webServiceResponse = PayUWebServiceResponse()
        webServiceResponse?.getPayUPaymentRelatedDetail(forMobileSDK: paymentParamForPassing) { [weak self] (paymentRelatedDetails, errorMessage, extraParam) in
            
            completion(paymentRelatedDetails,errorMessage,extraParam)
            

            
        }
    }
    
    func vasForMobileSDK(paymentParamForPassing:PayUModelPaymentParams,completion:@escaping((_ modelPayment:PayUModelVAS?,_ errorMessage:String?,_ json:Any?)->Void)){
        let webServiceResponse = PayUWebServiceResponse()
        webServiceResponse?.callVASForMobileSDK(withPaymentParam: paymentParamForPassing, withCompletionBlock: { result, error, json in
            completion(result,error,json)
        })
    }
    
    func vasForMobileSDK1(paymentParamForPassing:PayUModelPaymentParams,completion:@escaping((_ modelPayment:Any?,_ errorMessage:String?,_ json:Any?)->Void)){
        let webServiceResponse = PayUWebServiceResponse()
        webServiceResponse?.getVASStatus(forCardBinOrBankCode: "AXIB", withCompletionBlock: { result, error, json in
            completion(result,error,json)
        })
    }
    
    func verfyPayment(paymentParamForPassing: PayUModelPaymentParams, completion:@escaping((_ modelPayment:Any?,_ errorMessage:String?,_ json:Any?)->Void)){
        let webServiceResponse = PayUWebServiceResponse()
        webServiceResponse?.verifyPayment(paymentParamForPassing, withCompletionBlock: { result, error, json in
            completion(result,error,json)
        })
    }
    func checkIsDomestic(paymentParamForPassing: PayUModelPaymentParams, completion:@escaping((_ modelPayment:Any?,_ errorMessage:String?,_ json:Any?)->Void)){
        let webServiceResponse = PayUWebServiceResponse()
        webServiceResponse?.checkIsDomestic(paymentParamForPassing, withCompletionBlock: { result, error, json in completion(result, error, json)
            
        })
    }
    
    func getBinInfo(paymentParamForPassing: PayUModelPaymentParams, completion:@escaping((_ modelPayment:Any?,_ errorMessage:String?,_ json:Any?)->Void)){
        let webServiceResponse = PayUWebServiceResponse()
        webServiceResponse?.getBinInfo(paymentParamForPassing, withCompletionBlock: { result, error, json in
            completion(result, error, json)
        })
    }
    
    
    func getEmiAmountAccordingToInterest(paymentParamForPassing:PayUModelPaymentParams,completion:@escaping((_ result:[AnyHashable : Any]?,_ status:String?,_ json:Any?)->Void)){
        let webServiceResponse = PayUWebServiceResponse()
        webServiceResponse?.getEMIAmount(accordingToInterest: paymentParamForPassing, withCompletionBlock: { result, statusStr, json in
           
            completion(result,statusStr,json)
            
        })
    }
    
    
    //MARK:- GET TRANSACTION_ID
    public func getTxnID()->String{
            let length = 5
            let letters:NSString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
            let randomString = NSMutableString(capacity: length)
            for _ in 0..<length{
                randomString.appendFormat("%C", letters.character(at:Int(arc4random_uniform(UInt32(letters.length)))))
            }
            return randomString as String
            
        }
    
    //MARK:- GENERATE HASH
    
    
    private func getHashFromTxnParams(_ txnParam: PayUModelPaymentParams?, salt: String?,completion:@escaping((String?)->Void)){
        
        var hashSequence: String? = nil
        if let key = txnParam?.key, let txnID = txnParam?.transactionID, let amount = txnParam?.amount, let productInfo = txnParam?.productInfo, let firstname = txnParam?.firstName, let email = txnParam?.email, let udf1 = txnParam?.udf1, let udf2 = txnParam?.udf2, let udf3 = txnParam?.udf3, let udf4 = txnParam?.udf4, let udf5 = txnParam?.udf5{
            hashSequence = "\(key)|\(txnID)|\(amount)|\(productInfo)|\(firstname)|\(email)|\(udf1)|\(udf2)|\(udf3)|\(udf4)|\(udf5)||||||\(salt ?? "")"
        }
       // print("hashSequence............\(hashSequence)")
        let hash = hashSequence?.sha512()
        completion(hash)
    }
    
    private func getPaymentDetailsrelatedHash(_ txnParam:PayUModelPaymentParams?,salt:String?,completion:@escaping((String?)->Void)){
        let hashName = "payment_related_details_for_mobile_sdk"
        var hashSequence: String? = nil
        if let key = txnParam?.key, let userCredential = txnParam?.userCredentials, let amount = txnParam?.amount, let productInfo = txnParam?.productInfo, let firstname = txnParam?.firstName, let email = txnParam?.email, let udf1 = txnParam?.udf1, let udf2 = txnParam?.udf2, let udf3 = txnParam?.udf3, let udf4 = txnParam?.udf4, let udf5 = txnParam?.udf5{
            hashSequence = "\(key)|\(hashName)|\(userCredential)|\(salt ?? "")"
        }
       // print("hashSequence............\(hashSequence)")
        let hash = hashSequence?.sha512()
        completion(hash)
    }
    
    private func getfetchPaymentOption(_ txnParam:PayUModelPaymentParams?,salt:String?,completion:@escaping((String?)->Void)){
        let hashName = "payment_related_details_for_mobile_sdk"
        var hashSequence: String? = nil
        if let key = txnParam?.key, let userCredential = txnParam?.userCredentials, let amount = txnParam?.amount, let productInfo = txnParam?.productInfo, let firstname = txnParam?.firstName, let email = txnParam?.email, let udf1 = txnParam?.udf1, let udf2 = txnParam?.udf2, let udf3 = txnParam?.udf3, let udf4 = txnParam?.udf4, let udf5 = txnParam?.udf5{
            hashSequence = "\(key)|\(hashName)|\(userCredential)|\(salt ?? "")"
        }
       // print("hashSequence............\(hashSequence)")
        let hash = hashSequence?.sha512()
        completion(hash)
    }
    
    private func vasForMobileSDK(_ txnParam:PayUModelPaymentParams?,salt:String?,completion:@escaping((String?)->Void)){
           let hashName = "vas_for_mobile_sdk"
           var hashSequence: String? = nil
           if let key = txnParam?.key, let userCredential = txnParam?.userCredentials, let amount = txnParam?.amount, let productInfo = txnParam?.productInfo, let firstname = txnParam?.firstName, let email = txnParam?.email, let udf1 = txnParam?.udf1, let udf2 = txnParam?.udf2, let udf3 = txnParam?.udf3, let udf4 = txnParam?.udf4, let udf5 = txnParam?.udf5{
               hashSequence = "\(key)|\(hashName)|default|\(salt ?? "")"
           }
           print("hashSequence............\(hashSequence)")
           let hash = hashSequence?.sha512()
           completion(hash)
       }
    
    private func verifyPayment(_ txnParam:PayUModelPaymentParams?,salt:String?,completion:@escaping((String?)->Void)){
           let hashName = "verify_payment"
           var hashSequence: String? = nil
        if let key = txnParam?.key,let txnId = txnParam?.transactionID, let userCredential = txnParam?.userCredentials, let amount = txnParam?.amount, let productInfo = txnParam?.productInfo, let firstname = txnParam?.firstName, let email = txnParam?.email, let udf1 = txnParam?.udf1, let udf2 = txnParam?.udf2, let udf3 = txnParam?.udf3, let udf4 = txnParam?.udf4, let udf5 = txnParam?.udf5{
               hashSequence = "\(key)|\(hashName)|\(txnId)|\(salt ?? "")"
           }
           print("hashSequence............\(hashSequence)")
           let hash = hashSequence?.sha512()
           completion(hash)
       }
    
    private func checkIsDomestic(_ txnParam:PayUModelPaymentParams?,salt:String?,completion:@escaping((String?)->Void)){
           let hashName = "check_isDomestic"
           var hashSequence: String? = nil
        if let key = txnParam?.key,let txnId = txnParam?.transactionID, let userCredential = txnParam?.userCredentials, let amount = txnParam?.amount, let productInfo = txnParam?.productInfo, let firstname = txnParam?.firstName, let email = txnParam?.email, let udf1 = txnParam?.udf1, let udf2 = txnParam?.udf2, let udf3 = txnParam?.udf3, let udf4 = txnParam?.udf4, let udf5 = txnParam?.udf5{
               hashSequence = "\(key)|\(hashName)|4012001037141112|\(salt ?? "")"
           }
           print("hashSequence............\(hashSequence)")
           let hash = hashSequence?.sha512()
           completion(hash)
       }
    private func getBinInfo(_ txnParam:PayUModelPaymentParams?,salt:String?,completion:@escaping((String?)->Void)){
           let hashName = "getBinInfo"
           var hashSequence: String? = nil
        if let key = txnParam?.key,let txnId = txnParam?.transactionID, let userCredential = txnParam?.userCredentials, let amount = txnParam?.amount, let productInfo = txnParam?.productInfo, let firstname = txnParam?.firstName, let email = txnParam?.email, let udf1 = txnParam?.udf1, let udf2 = txnParam?.udf2, let udf3 = txnParam?.udf3, let udf4 = txnParam?.udf4, let udf5 = txnParam?.udf5{
               hashSequence = "\(key)|\(hashName)|1|\(salt ?? "")"
           }
           print("hashSequence............\(hashSequence)")
           let hash = hashSequence?.sha512()
           completion(hash)
       }
    
    private func getEmiAmountAccordingToInterestHash(_ txnParam:PayUModelPaymentParams?,salt:String?,completion:@escaping((String?)->Void)){
           let hashName = "getEmiAmountAccordingToInterest"
           var hashSequence: String? = nil
           if let key = txnParam?.key, let userCredential = txnParam?.userCredentials, let amount = txnParam?.amount, let productInfo = txnParam?.productInfo, let firstname = txnParam?.firstName, let email = txnParam?.email, let udf1 = txnParam?.udf1, let udf2 = txnParam?.udf2, let udf3 = txnParam?.udf3, let udf4 = txnParam?.udf4, let udf5 = txnParam?.udf5{
               hashSequence = "\(key)|\(hashName)|\(amount)|\(salt ?? "")"
           }
           print("hashSequence............\(hashSequence)")
           let hash = hashSequence?.sha512()
           completion(hash)
       }
    
    
}


//MARK:- CONVERT INTO SHA512
extension String {

    func sha512() -> String {
        let data = self.data(using: .utf8)!
        var digest = [UInt8](repeating: 0, count: Int(CC_SHA512_DIGEST_LENGTH))
        data.withUnsafeBytes({
            _ = CC_SHA512($0, CC_LONG(data.count), &digest)
        })
        return digest.map({ String(format: "%02hhx", $0) }).joined(separator: "")
    }

}


struct EmiOptionListModel
{
    var payuModelEmi:PayUModelEMI?
    var amount:String?
    var bankCharge:String?
    var bankRate:String?
    var emiAmount:String?
    var emiBankInterest:String?
    var tenure:String?
    var transactionAmount:String?
    var emiInterestPaid:String?
}
