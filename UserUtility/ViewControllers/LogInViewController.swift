//
//  LogInViewController.swift
//  UserUtility
//
//  Created by IPS on 07/04/20.
//  Copyright © 2020 IPS. All rights reserved.
//

import UIKit

class LogInViewController: UIViewController {

    @IBOutlet var buttonLogIn:UIButton!
    @IBOutlet var buttonHideKeyboard:UIButton!
    @IBOutlet var txtUserName:UITextField!
    @IBOutlet var txtPassword:UITextField!
    
    var objButton:UIButton?
    var isPasswordShow:Bool = false
    var userLogInParameters:[String:Any] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //setup login view
        self.setup()
        
        
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.hideKeyBoard()
        //configure login selector
        self.configureLogInSelector()
    }
    // MARK: - SetUp Methods
    func setup(){
        self.buttonHideKeyboard.addTarget(self, action: #selector(hideKeyBoard), for: .touchUpInside)
        
        //configure textfield
        self.configureTextField()
        
       
    }
    func configureTextField(){
        self.txtUserName.placeholder = "UserName"
        self.txtPassword.placeholder = "Password"
        self.txtUserName.delegate = self
        self.txtPassword.delegate = self
        
        self.configurePasswordTextField()
    }
    func configurePasswordTextField(){
        
        objButton = UIButton.init(frame: CGRect.init(x: 0, y: 0, width: 30, height: 30))
        self.objButton!.tintColor = UIColor.label
        let objImage = UIImage.init(named: "ic_eye_off")?.withRenderingMode(.alwaysTemplate)
        objButton!.setImage(objImage, for: .normal)
        objButton!.addTarget(self, action: #selector(buttonPasswordEyeSelector(sender:)), for: .touchUpInside)
        self.txtPassword.rightViewMode = .always
        self.txtPassword.rightView = objButton
    }
   
    func configureLogInSelector(){
        self.buttonLogIn.layer.cornerRadius = 8.0
        self.buttonLogIn.clipsToBounds = true
        self.buttonLogIn.addTarget(self, action: #selector(buttonLogInSelector(sender:)), for: .touchUpInside)
        self.buttonLogIn.layer.borderColor = UIColor.label.cgColor
        self.buttonLogIn.layer.borderWidth = 0.7
        self.buttonLogIn.setTitle("Log In", for: .normal)
        self.buttonLogIn.setTitleColor(UIColor.label, for: .normal)
    }
    func isValidLogIn()->Bool{
        guard "\(self.userLogInParameters["email"] ?? "")".count > 0 else {
                   DispatchQueue.main.async {
                        ShowToast.show(toatMessage: "Please enter valid email address.")
                   }
                   return false
               }
               if let emailText:String = self.userLogInParameters["email"] as? String,!emailText.isValidEmail(){
                   DispatchQueue.main.async {
                        ShowToast.show(toatMessage: "Please enter valid email address.")
                   }
                   return false
               }
               
               guard "\(self.userLogInParameters["password"] ?? "")".count > 0 else {
                   DispatchQueue.main.async {
                        ShowToast.show(toatMessage: "Please enter valid password.")
                   }
                   return false
               }
        return true
    }
    // MARK: - Selector Methods
    @IBAction func buttonLogInSelector(sender:UIButton){
        self.userLogInAPIRequest()
    }
    @IBAction func hideKeyBoard(){
           DispatchQueue.main.async {
              self.txtUserName.resignFirstResponder()
              self.txtPassword.resignFirstResponder()
           }
    }
    @IBAction func buttonPasswordEyeSelector(sender:UIButton){
          self.txtPassword.becomeFirstResponder()
          self.isPasswordShow = !self.isPasswordShow
          if let currentText = self.txtPassword.text{
              self.txtPassword.text = ""
              self.txtPassword.isSecureTextEntry = !self.isPasswordShow
              self.txtPassword.text = currentText
          }
          if self.isPasswordShow{
               let objImage = UIImage.init(named: "ic_eye_on")?.withRenderingMode(.alwaysTemplate)
              objButton!.setImage(objImage, for: .normal)
          }else{
               let objImage = UIImage.init(named: "ic_eye_off")?.withRenderingMode(.alwaysTemplate)
              objButton!.setImage(objImage, for: .normal)
          }
    }
    @IBAction func buttonForgotPasswordSelector(sender:UIButton){
        self.navigateToForgotPasswordScreen()
    }
    @IBAction func buttonSignUpSelector(sender:UIButton){
        self.navigateToSignUpScreen()
    }
    // MARK: - API Request Methods
    func userLogInAPIRequest(){
        if self.isValidLogIn(){
              APIRequestClient.shared.sendRequest(requestType: .POST, queryString: kUserLogin, parameter: self.userLogInParameters as [String : AnyObject], isHudeShow: true, success: { (responseSuccess) in
                            if let objSuccess = responseSuccess as? [String:Any],let _ :String = objSuccess["message"] as? String,let successData = objSuccess["data"] as? [String:Any]{
                                let currentUser = User.init(userDetail: successData)
                                currentUser.setuserDetailToUserDefault()
                               
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
    //navigate to forgotpassword screen
    func navigateToForgotPasswordScreen(){
        if let forgotScreen = self.storyboard?.instantiateViewController(identifier: "ForgotPasswordViewController") as? ForgotPasswordViewController{
            self.navigationController?.pushViewController(forgotScreen, animated: true)
        }
    }
    //navigate to signup screen
    func navigateToSignUpScreen(){
           if let signUpScreen = self.storyboard?.instantiateViewController(identifier: "SignUpViewController") as? SignUpViewController{
               self.navigationController?.pushViewController(signUpScreen, animated: true)
           }
       }

}
extension LogInViewController:UITextFieldDelegate{
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let typpedString = ((textField.text)! as NSString).replacingCharacters(in: range, with: string)
        
        guard !typpedString.isContainWhiteSpace() else{
            return false
        }
        if textField == self.txtUserName{
            self.userLogInParameters["email"] = "\(typpedString)"
        }else{
            self.userLogInParameters["password"] = "\(typpedString)"
        }
        return true
    }
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        if textField == self.txtUserName{
            self.userLogInParameters["email"] = ""
        }else{
            self.userLogInParameters["password"] = ""
        }
        return true
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        if textField == self.txtUserName{
            self.txtPassword.becomeFirstResponder()
        }else{
            self.userLogInAPIRequest()
        }
        return true
    }
}
