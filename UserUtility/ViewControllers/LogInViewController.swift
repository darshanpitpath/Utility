//
//  LogInViewController.swift
//  UserUtility
//
//  Created by IPS on 07/04/20.
//  Copyright © 2020 IPS. All rights reserved.
//

import UIKit
import MaterialTextField

class LogInViewController: UIViewController {

    @IBOutlet var buttonLogIn:UIButton!
    @IBOutlet var buttonHideKeyboard:UIButton!
    @IBOutlet var txtUserName:MFTextField!
    @IBOutlet var txtPassword:MFTextField!
    
    var objButton:UIButton?
    var isPasswordShow:Bool = false
    var userLogInParameters:[String:Any] = [:]
    
    let kUserName = "darshanp@itpathsolutions.in"
    let kPassword = "test12345"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
     
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.hideKeyBoard()
        
        //configure login selector
        self.configureLogInSelector()
        
        //setup login view
        self.setup()
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
        
        //Fill Default login data for simulator
        guard let currentDeviceUUID = UIDevice.current.identifierForVendor else {
                   return
               }
        print(currentDeviceUUID)
        if UIDevice.isSimulator || "\(currentDeviceUUID)" == "40E21EB2-434B-4775-8EA4-BF9FAC1198DC"{ //unique for IPS iPhone X only for this application
            self.txtUserName.text = kUserName
            self.txtPassword.text = kPassword
            self.userLogInParameters["email"]  = "\(kUserName)"
            self.userLogInParameters["password"] = "\(kPassword)" 
        }else{
            self.txtUserName.text = ""
            self.txtPassword.text = ""
        }
        
        
        self.txtUserName.setUpWithPlaceHolder(strPlaceHolder: "UserName", isWhiteBackground: UITraitCollection.current.userInterfaceStyle != .dark, errorColor: .red)
        self.txtPassword.setUpWithPlaceHolder(strPlaceHolder: "Password", isWhiteBackground: UITraitCollection.current.userInterfaceStyle != .dark, errorColor: .red)
        
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
                       self.txtUserName.invalideFieldWithError(strError: "Please enter valid email address.")
                        //ShowToast.show(toatMessage: "Please enter valid email address.")
                   }
                   return false
               }
               if let emailText:String = self.userLogInParameters["email"] as? String,!emailText.isValidEmail(){
                   DispatchQueue.main.async {
                        self.txtUserName.invalideFieldWithError(strError: "Please enter valid email address.")
                       // ShowToast.show(toatMessage: "Please enter valid email address.")
                   }
                   return false
               }
               
               guard "\(self.userLogInParameters["password"] ?? "")".count > 0 else {
                   DispatchQueue.main.async {
                        self.txtPassword.invalideFieldWithError(strError: "Please enter valid password.")
                        //ShowToast.show(toatMessage: "Please enter valid password.")
                   }
                   return false
               }
                
        guard "\(self.userLogInParameters["password"] ?? "")".count > 6 else {
            DispatchQueue.main.async {
                self.txtPassword.invalideFieldWithError(strError:"Please enter password at least 6 digit")
            }
            return false
        }
        
                
        
        
        
        self.txtUserName.validateField()
        self.txtPassword.validateField()
        return true
    }
    // MARK: - Selector Methods
    @IBAction func buttonLogInSelector(sender:UIButton){
        //Show Error on login email
        
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
            
            self.userLogInParameters["device_type"] = "ios"
            self.userLogInParameters["device_id"] = "\(UIDevice.current.identifierForVendor!.uuidString)"
            if let deviceToken = UserDefaults.standard.object(forKey: "currentDeviceToken") as? String{
                self.userLogInParameters["device_token"] = deviceToken
            }else{
                self.userLogInParameters["device_token"] = "iOS"
            }
            APIRequestClient.shared.fetch(queryString: kParentLogin, requestType: .POST, isHudeShow: true, parameter: self.userLogInParameters as [String:AnyObject]) { ( result ) in
                switch result {
                    case .success(let response):
                        
                        if let objResponse = response as? [String:Any],let objParentData = objResponse["data"] as? [String:Any]{
                            do {
                                let parentData = try JSONSerialization.data(withJSONObject: objParentData, options: .prettyPrinted)
                                if let userParent:ParentUser = try? JSONDecoder().decode(ParentUser.self, from: parentData){
                                    userParent.setuserDetailToUserDefault()
                                }
                                //For testing get current userParent from userdefault and display details
                                if let currentParent = ParentUser.getUserFromUserDefault(){
                                    //Push to Login screen
                                    self.navigateToLoginScreen()
                                    
                                }
                                
                            }catch {
                                print("\(error.localizedDescription)")
                            }
                            print(objParentData)
                        }
                        /*
                        do {
                            let jsondata = try JSONSerialization.data(withJSONObject:childJSON, options:.prettyPrinted)
                            
                            if let parentUserData = try? JSONDecoder().decode(ParentUser.self, from: jsondata){
                                print(parentUserData)
                            }
                        }catch{
                            
                        }*/
                        print("\(response)")
                    case .failure(let error):
                        print(error.localizedDescription)
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
    //navigate to login screen
    func navigateToLoginScreen(){
        if let loginScreen = self.storyboard?.instantiateViewController(identifier: "LogInViewController") as? LogInViewController{
            self.navigationController?.pushViewController(loginScreen, animated: true)
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
extension MFTextField{
    func setUpWithPlaceHolder(strPlaceHolder:String,isWhiteBackground:Bool = true,errorColor:UIColor = UIColor.red){
        
        
        
        if !isWhiteBackground{
            self.tintColor = UIColor.white
            self.textColor = UIColor.white
            self.placeholderColor = UIColor.white
            self.defaultPlaceholderColor = UIColor.white
        }else{
            self.tintColor = UIColor.black
            self.textColor = UIColor.black
            self.placeholderColor = UIColor.darkGray
            self.defaultPlaceholderColor = UIColor.darkGray
        }
        
        let myAttribute = [ NSAttributedString.Key.font: UIFont(name: "Verdana", size: 18.0)! ]
        self.attributedPlaceholder = NSAttributedString(string: strPlaceHolder, attributes: myAttribute)
        self.font = UIFont(name: "Verdana", size: 18.0)!
    }
    
    func invalideFieldWithError(strError:String){
        let obj = NSError.init(domain: "OverRide", code: 100, userInfo: [NSLocalizedDescriptionKey:strError])
        DispatchQueue.main.async {
            self.setError(obj, animated: true)
            self.setError(obj, animated: true)
        }
    }
    func validateField(){
        self.setError(nil, animated: true)
    }
}
