//
//  ForgotPasswordViewController.swift
//  UserUtility
//
//  Created by IPS on 07/04/20.
//  Copyright © 2020 IPS. All rights reserved.
//

import UIKit

class ForgotPasswordViewController: UIViewController {

    @IBOutlet var buttonBack:UIButton!
    @IBOutlet var txtUserName:UITextField!
    @IBOutlet var buttonForgot:UIButton!
    
    var userForgotParameters:[String:Any] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        //setup methods
        self.setup()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        DispatchQueue.main.async {
            self.hideKeyBoard()
        }
        //forgot selector
        self.configureForgotSelector()
        //back selector
        self.configureBackSelector()
    }

    // MARK: - SetUp Methods
    func setup(){
        self.txtUserName.placeholder = "UserName"
        let objIMage = UIImage.init(named: "back")?.withRenderingMode(.alwaysTemplate)
        self.buttonBack.setImage(objIMage, for: .normal)
        self.buttonBack.tintColor = UIColor.label
        self.txtUserName.delegate = self
        
    }
    func isValidForgotPassword()->Bool{
        guard "\(self.userForgotParameters["email"] ?? "")".count > 0 else {
                   DispatchQueue.main.async {
                        ShowToast.show(toatMessage: "Please enter valid email address.")
                   }
                   return false
               }
               if let emailText:String = self.userForgotParameters["email"] as? String,!emailText.isValidEmail(){
                   DispatchQueue.main.async {
                        ShowToast.show(toatMessage: "Please enter valid email address.")
                   }
                   return false
               }
               
               
        return true
    }
    func configureBackSelector(){
       let objIMage = UIImage.init(named: "back")?.withRenderingMode(.alwaysTemplate)
       self.buttonBack.setImage(objIMage, for: .normal)
       self.buttonBack.tintColor = UIColor.label
       self.txtUserName.delegate = self
    }
    func configureForgotSelector(){
        self.buttonForgot.layer.cornerRadius = 8.0
        self.buttonForgot.clipsToBounds = true
        self.buttonForgot.addTarget(self, action: #selector(buttonForgotPasswordSelector(sender:)), for: .touchUpInside)
        self.buttonForgot.layer.borderColor = UIColor.label.cgColor
        self.buttonForgot.layer.borderWidth = 0.7
        self.buttonForgot.setTitle("Forgot Password", for: .normal)
        self.buttonForgot.setTitleColor(UIColor.label, for: .normal)
    }
    // MARK: - Selector Methods
    @IBAction func buttonForgotPasswordSelector(sender:UIButton){
        self.userForgotPasswordAPIRequest()
    }
    @IBAction func buttonBackSelector(sender:UIButton){
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func hideKeyBoard(){
              DispatchQueue.main.async {
                 self.txtUserName.resignFirstResponder()
              }
       }
    // MARK: - API Request Methods
    func userForgotPasswordAPIRequest(){
        if self.isValidForgotPassword(){
            APIRequestClient.shared.sendRequest(requestType: .POST, queryString: kUserForgot, parameter: self.userForgotParameters as [String : AnyObject], isHudeShow: true, success: { (responseSuccess) in
                if let objSuccess = responseSuccess as? [String:Any],let _ :String = objSuccess["message"] as? String,let successData = objSuccess["data"] as? [String:Any]{
                   print(successData)
                }
            }) { (responseFail) in
                DispatchQueue.main.async {
                    ShowHud.hide()
                }
                if let objFail = responseFail as? [String:Any],let message:String = objFail["message"] as? String{
                    DispatchQueue.main.async {
                        ShowToast.show(toatMessage: message)
                    }
                }
            }
        }
    }
    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    

}
extension ForgotPasswordViewController:UITextFieldDelegate{
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let typpedString = ((textField.text)! as NSString).replacingCharacters(in: range, with: string)
        
        guard !typpedString.isContainWhiteSpace() else{
            return false
        }
        if textField == self.txtUserName{
            self.userForgotParameters["email"] = "\(typpedString)"
        }
        return true
    }
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        if textField == self.txtUserName{
            self.userForgotParameters["email"] = ""
        }
        return true
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true
    }
}
