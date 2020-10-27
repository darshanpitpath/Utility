//
//  SignUpViewController.swift
//  UserUtility
//
//  Created by IPS on 07/04/20.
//  Copyright © 2020 IPS. All rights reserved.
//

import UIKit
import MobileCoreServices
import MaterialTextField

class SignUpViewController: UIViewController {
    
    @IBOutlet var buttonBack:UIButton!
    @IBOutlet var buttonAddImage:UIButton!
    @IBOutlet var buttonUploadImage:RoundButton!
    @IBOutlet var buttonSignUp:UIButton!
    @IBOutlet var buttonCheck:UIButton!
    
    
    @IBOutlet var lblTermsAndCondition:UILabel!
    
    @IBOutlet var txtDisplayName:MFTextField!
    @IBOutlet var txtEmail:MFTextField!
    @IBOutlet var txtPassword:MFTextField!
    @IBOutlet var txtConfirmPassword:MFTextField!
    @IBOutlet weak var txtPhoneNumber:MFTextField!
    @IBOutlet weak var imageViewCountryCode:UIImageView!
    @IBOutlet weak var lblCountryCode:UILabel!
    
    
    @IBOutlet var buttonCamera:UIButton!
    
    
    let text = "I agree to the Terms and Conditions."
    let termsConditionsURL = "https://www.google.com"
    var isPasswordShow:Bool = false
    var isConfirmPasswordShow:Bool = false
    var userProfileImage:UIImage?
    var objPassword:UIButton?
    var objConfirmPassword:UIButton?
    
    var addUserParameters:[String:Any] = [:]
    var arrayOfCountryCode:[Country] = []
    var currentSelectedCountry:Country?
    
    
    private var isterms:Bool = true
       var istermsAccepted:Bool{
           get{
               return isterms
           }
           set{
               self.isterms = newValue
               DispatchQueue.main.async {
                   //UpdateTerms and Conditions
                   self.updateTermsAndConditioins()
               }
           }
       }
    lazy var objImagePickerController = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.hideKeyBoard()
        self.configureBackSelector()
        self.configureSignUpSelector()
        self.configureTermsAndCondition()
        self.configurePasswordTextField()
        self.configureConfirmPasswordTextField()
        // Do any additional setup after loading the view.
        self.setUp()
    }
    func setUp(){
        self.txtDisplayName.setUpWithPlaceHolder(strPlaceHolder: "UserName", isWhiteBackground:  UITraitCollection.current.userInterfaceStyle != .dark, errorColor: UIColor.red)
        self.txtPhoneNumber.setUpWithPlaceHolder(strPlaceHolder: "Phone Number", isWhiteBackground:  UITraitCollection.current.userInterfaceStyle != .dark, errorColor: UIColor.red)
        self.txtEmail.setUpWithPlaceHolder(strPlaceHolder: "Email", isWhiteBackground:  UITraitCollection.current.userInterfaceStyle != .dark, errorColor: UIColor.red)
        self.txtPassword.setUpWithPlaceHolder(strPlaceHolder: "Password", isWhiteBackground:  UITraitCollection.current.userInterfaceStyle != .dark, errorColor: UIColor.red)
        self.txtConfirmPassword.setUpWithPlaceHolder(strPlaceHolder: "Confirm Password", isWhiteBackground:  UITraitCollection.current.userInterfaceStyle != .dark, errorColor: UIColor.red)
        self.txtDisplayName.delegate = self
        self.txtPhoneNumber.delegate = self
        self.txtEmail.delegate = self
        self.txtPassword.delegate = self
        self.txtConfirmPassword.delegate = self
        
        //NAVIGATION BAR SETUP
        self.title = "Sign Up"
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationItem.largeTitleDisplayMode = .always
         //loadCountry JSON
        self.loadCountryJSON()
    }
    //MARK: - Read COUNTRY JSON file
    func loadCountryJSON(){
        if let filePath = Bundle.main.path(forResource: "country", ofType: "json"){
            do {
                let objJSONData = try Data.init(contentsOf: URL.init(fileURLWithPath: filePath), options: .dataReadingMapped)
                
                if let arrayCountryJSON = try JSONSerialization.jsonObject(with: objJSONData, options: .mutableContainers) as? [Any]{
                            self.arrayOfCountryCode.removeAll()
                            for objCountryJSON in arrayCountryJSON{
                               let objJSONData = try JSONSerialization.data(withJSONObject: objCountryJSON, options: .fragmentsAllowed)
                               let objCountry = try JSONDecoder().decode(Country.self, from: objJSONData)
                                self.arrayOfCountryCode.append(objCountry)
                            }
                    print("======= \(self.arrayOfCountryCode.count) =======")
                    //"US" "+1"
                    let filterArray = self.arrayOfCountryCode.filter{ $0.code == "US" && $0.dialcode == "+1"}
                    if filterArray.count > 0{
                        self.configureSelectedCountryCode(objCountry: filterArray.first!)
                    }
                    print(filterArray)
                }
            }catch{
                print(error.localizedDescription)
            }
            
        }
    }
    func configurePasswordTextField(){
        self.txtPassword.isSecureTextEntry = true
        objPassword = UIButton.init(frame: CGRect.init(x: 0, y: 0, width: 30, height: 30))
        self.objPassword!.tintColor = UIColor.label
        objPassword!.setImage(UIImage.init(named: "ic_eye_off")?.withRenderingMode(.alwaysTemplate), for: .normal)
        objPassword!.addTarget(self, action: #selector(buttonPasswordEyeSelector(sender:)), for: .touchUpInside)
        self.txtPassword.rightViewMode = .always
        self.txtPassword.rightView = objPassword
    }
    func configureConfirmPasswordTextField(){
        self.txtConfirmPassword.isSecureTextEntry = true
        objConfirmPassword = UIButton.init(frame: CGRect.init(x: 0, y: 0, width: 30, height: 30))
        self.objConfirmPassword!.tintColor = UIColor.label
        objConfirmPassword!.setImage(UIImage.init(named: "ic_eye_off")?.withRenderingMode(.alwaysTemplate), for: .normal)
        objConfirmPassword!.addTarget(self, action: #selector(buttonConfirmPasswordEyeSelector(sender:)), for: .touchUpInside)
        self.txtConfirmPassword.rightViewMode = .always
        self.txtConfirmPassword.rightView = objConfirmPassword
    }
    func configureBackSelector(){
          let objIMage = UIImage.init(named: "back")?.withRenderingMode(.alwaysTemplate)
//          self.buttonBack.setImage(objIMage, for: .normal)
//          self.buttonBack.tintColor = UIColor.label
    }
    func configureSignUpSelector(){
        self.buttonSignUp.layer.cornerRadius = 8.0
               self.buttonSignUp.clipsToBounds = true
               self.buttonSignUp.addTarget(self, action: #selector(buttonSignUpSelector(sender:)), for: .touchUpInside)
               self.buttonSignUp.layer.borderColor = UIColor.label.cgColor
               self.buttonSignUp.layer.borderWidth = 0.7
               self.buttonSignUp.setTitle("Sign Up", for: .normal)
               self.buttonSignUp.setTitleColor(UIColor.label, for: .normal)
    }
    func configureTermsAndCondition(){
        lblTermsAndCondition.text = text
        self.lblTermsAndCondition.textColor =  UIColor.label
        let underlineAttriString = NSMutableAttributedString(string: text)
        let range1 = (text as NSString).range(of: "Terms and Conditions.")
        underlineAttriString.addAttribute(NSAttributedString.Key.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: range1)
        underlineAttriString.addAttribute(NSAttributedString.Key.font, value: UIFont.systemFont(ofSize: 14), range: range1)
        
        lblTermsAndCondition.attributedText = underlineAttriString
        lblTermsAndCondition.isUserInteractionEnabled = true
        lblTermsAndCondition.addGestureRecognizer(UITapGestureRecognizer(target:self, action: #selector(tapLabel(gesture:))))
        
    }
    func updateTermsAndConditioins(){
        let objImage = (self.istermsAccepted) ? UIImage.init(named: "checkbox") : UIImage.init(named: "Uncheck")
        self.buttonCheck.setImage(objImage, for: .normal)
    }
    func presentUploadImageActionSheet(){
            let actionSheetController = UIAlertController.init(title: "", message:"Upload Profile Image", preferredStyle: .actionSheet)
            let cancelSelector = UIAlertAction.init(title: "Cancel", style: .cancel, handler:nil)
            actionSheetController.addAction(cancelSelector)
            let cameraSelector = UIAlertAction.init(title: "Camera", style: .default) { (_) in
                
                DispatchQueue.main.async {
                    self.objImagePickerController = UIImagePickerController()
                    self.objImagePickerController.sourceType = .camera
                    self.objImagePickerController.delegate = self
                    self.objImagePickerController.allowsEditing = false
                    self.objImagePickerController.mediaTypes = [kUTTypeImage as String]
                    self.view.endEditing(true)
                    self.presentImagePickerController()
                }
            }
            actionSheetController.addAction(cameraSelector)
            
            let photosSelector = UIAlertAction.init(title: "Photos", style: .default) { (_) in
                DispatchQueue.main.async {
                    self.objImagePickerController = UIImagePickerController()
                    self.objImagePickerController.sourceType = .savedPhotosAlbum
                    self.objImagePickerController.delegate = self
                    self.objImagePickerController.allowsEditing = false
                    self.objImagePickerController.mediaTypes = [kUTTypeImage as String]
                    self.view.endEditing(true)
                    self.presentImagePickerController()
                    
                }
            }
            actionSheetController.addAction(photosSelector)
            self.view.endEditing(true)
    //        actionSheetController.view.tintColor = kThemeColor
            if let popoverController = actionSheetController.popoverPresentationController {
                popoverController.sourceRect = self.buttonCamera.bounds
                popoverController.sourceView = self.buttonCamera
                
            }
            actionSheetController.view.tintColor = UIColor.label
            self.present(actionSheetController, animated: true, completion: nil)
        }
    func presentImagePickerController(){
        self.view.endEditing(true)
        self.present(self.objImagePickerController, animated: true, completion: nil)
    }
    //Configure Selected Country
    func configureSelectedCountryCode(objCountry:Country){
        self.currentSelectedCountry = objCountry
        DispatchQueue.main.async {
            self.imageViewCountryCode.image = UIImage.init(named: "\(objCountry.code)")
            self.lblCountryCode.text = "\(objCountry.dialcode)"
        }
    }
    //Sign up screen validation
    func isValidSignUp()-> Bool{
       guard self.istermsAccepted else {
                //self.view.showToast(message:"Please select terms and conditions.", isBlack:false)
                ShowToast.show(toatMessage: "Please select terms and conditions.")
                return false
            }
        guard let _ = self.userProfileImage else {
            DispatchQueue.main.async {
                self.buttonAddImage.invalideField()
                //self.buttonParentImage.invalideField()
                //self.view.showToast(message:"Please select profile image.", isBlack:false)
                ShowToast.show(toatMessage: "Please select profile image.")
            }
            return false
        }
        guard "\(self.addUserParameters["name"] ?? "")".count > 0 else {
            DispatchQueue.main.async {
                self.txtDisplayName.invalideFieldWithError(strError: "Please enter valid name")
            }
            return false
        }
        guard "\(self.addUserParameters["phone"] ?? "")".count > 0 else {
            DispatchQueue.main.async {
                self.txtPhoneNumber.invalideFieldWithError(strError: "Please enter valid phone number")
            }
            return false
        }
        guard "\(self.addUserParameters["email"] ?? "")".count > 0 else {
            DispatchQueue.main.async {
                self.txtEmail.invalideFieldWithError(strError: "Please enter valid email address.")
            }
            return false
        }
        if let emailText:String = self.addUserParameters["email"] as? String,!emailText.isValidEmail(){
            DispatchQueue.main.async {
                self.txtEmail.invalideFieldWithError(strError: "Please enter valid email address.")
            }
            return false
        }
        
        guard "\(self.addUserParameters["password"] ?? "")".count > 0 else {
            DispatchQueue.main.async {
                self.txtPassword.invalideFieldWithError(strError: "Please enter valid password")
            }
            return false
        }
        guard "\(self.addUserParameters["confirm_password"] ?? "")".count > 0 else {
            DispatchQueue.main.async {
                self.txtConfirmPassword.invalideFieldWithError(strError: "Please enter valid confirm password")
            }
            return false
        }
        guard "\(self.addUserParameters["confirm_password"] ?? "")" == "\(self.addUserParameters["password"] ?? "")"  else {
            DispatchQueue.main.async {
                self.txtConfirmPassword.invalideFieldWithError(strError: "Confirm password not match to password")
            }
            return false
        }
        guard "\(self.addUserParameters["phone"] ?? "")".count > 0 else {
            DispatchQueue.main.async {
                self.txtPhoneNumber.invalideFieldWithError(strError: "Please enter valid phone number")
            }
            return false
        }
        guard self.istermsAccepted else {
            //self.view.showToast(message:"Please select terms and conditions.", isBlack:false)
            ShowToast.show(toatMessage: "Please select terms and conditions.")
            return false
        }
        self.txtDisplayName.validateField()
        self.txtEmail.validField()
        self.txtPassword.validField()
        self.txtConfirmPassword.validateField()
        self.txtPhoneNumber.validateField()
        
        return true
    }
    // MARK: - Selector Methods
    @IBAction func hideKeyBoard(){
           DispatchQueue.main.async {
                self.view.endEditing(true)
           }
    }
    @IBAction func buttonBackSelector(sender:UIButton){
           self.navigationController?.popViewController(animated: true)
    }
    @IBAction func buttonCheckSelector(sender:UIButton){
        self.istermsAccepted = !self.istermsAccepted
    }
    @IBAction func buttonSignUpSelector(sender:UIButton){
        //Check for Sing up validation
        if self.isValidSignUp(){
            //Request sign up API
        }
    }
    @IBAction func buttonUploadImageSelector(sender:UIButton){
           self.presentUploadImageActionSheet()
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
            objPassword!.setImage(UIImage.init(named: "ic_eye_on")?.withRenderingMode(.alwaysTemplate), for: .normal)
           }else{
               objPassword!.setImage(UIImage.init(named: "ic_eye_off")?.withRenderingMode(.alwaysTemplate), for: .normal)
           }
       }
       @IBAction func buttonConfirmPasswordEyeSelector(sender:UIButton){
           self.txtConfirmPassword.becomeFirstResponder()
           self.isConfirmPasswordShow = !self.isConfirmPasswordShow
           if let currentText = self.txtConfirmPassword.text{
               self.txtConfirmPassword.text = ""
               self.txtConfirmPassword.isSecureTextEntry = !self.isConfirmPasswordShow
               self.txtConfirmPassword.text = currentText
           }
           if self.isConfirmPasswordShow{
               objConfirmPassword!.setImage(UIImage.init(named: "ic_eye_on"), for: .normal)
           }else{
               objConfirmPassword!.setImage(UIImage.init(named: "ic_eye_off"), for: .normal)
           }
       }
    @IBAction func tapLabel(gesture: UITapGestureRecognizer) {
        let termsRange = (text as NSString).range(of: "Terms and Conditions.")

        // comment for now
        //let privacyRange = (text as NSString).range(of: "Privacy Policy")
        
        if gesture.didTapAttributedTextInLabel(label: self.lblTermsAndCondition, inRange: termsRange) {
            print("Tapped terms")
            if let objWebURLController = self.storyboard?.instantiateViewController(withIdentifier: "WebURLLoaderViewController") as? WebURLLoaderViewController{
                objWebURLController.modalPresentationStyle = .fullScreen
                //self.navigationController?.modalPresentationStyle = .fullScreen
                self.navigationController?.present(objWebURLController, animated: true, completion: nil)
            }
            /*
            if let objURL = URL.init(string:termsConditionsURL){
                if UIApplication.shared.canOpenURL(objURL){
                    UIApplication.shared.open(objURL, options: [:], completionHandler: nil)
                }
            }*/
            
        }
    }
    @IBAction func buttonCountryCodeSelector(sender:UIButton){
        self.presentCountryPicker(arrayOfCountry: self.arrayOfCountryCode)
    }
    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    //PESENT COUNTRY PICKER
    func presentCountryPicker(arrayOfCountry:[Country]){
        //present country picker
         if let objCountrypickerViewController = self.storyboard?.instantiateViewController(withIdentifier: "CountryCodePickerViewController") as? CountryCodePickerViewController{
             objCountrypickerViewController.modalPresentationStyle = .overCurrentContext
             objCountrypickerViewController.arrayOfCountry = arrayOfCountry
            if let objCountry = self.currentSelectedCountry{
                objCountrypickerViewController.selectedCountry = objCountry
            }
            objCountrypickerViewController.delegate = self
            let objNavigationController = UINavigationController.init(rootViewController: objCountrypickerViewController)
            
//            self.present(objNavigationController, animated: true, completion: nil)
            self.navigationController?.present(objCountrypickerViewController, animated: true, completion: nil)
         }
    }
    

}
extension SignUpViewController:CountryCodePickerDelegate{
    func didSelectCountryCodePicker(countryCode: Country) {
        DispatchQueue.main.async {
            self.txtPhoneNumber.becomeFirstResponder()
            self.configureSelectedCountryCode(objCountry: countryCode)
        }
    }
}
extension SignUpViewController:UITextFieldDelegate{
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let typpedString = ((textField.text)! as NSString).replacingCharacters(in: range, with: string)
        
        if textField != self.txtDisplayName{
            guard !typpedString.isContainWhiteSpace() else{
                return false
            }
        }
        (textField as? MFTextField)?.validateField()
        if textField == self.txtDisplayName{
            self.addUserParameters["name"] = "\(typpedString)"
        }else if textField == self.txtPhoneNumber{
            self.addUserParameters["phone"] = "\(typpedString)"
        }else if textField == self.txtEmail{
            self.addUserParameters["email"] = "\(typpedString)"
        }else if textField == self.txtPassword{
            self.addUserParameters["password"] = "\(typpedString)"
        }else if textField == self.txtConfirmPassword{
            self.addUserParameters["confirm_password"] = "\(typpedString)"
        }else{
           
        }
        print(self.addUserParameters)
        return true
    }
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        
        return true
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        if textField == self.txtDisplayName{
            self.txtEmail.becomeFirstResponder()
        }else if textField == self.txtEmail{
            self.txtPassword.becomeFirstResponder()
        }else if textField == self.txtPassword{
            self.txtConfirmPassword.becomeFirstResponder()
        }else if textField == self.txtConfirmPassword{
          self.buttonSignUpSelector(sender: self.buttonSignUp)
        }else{
            
        }
        return true
    }
}
extension SignUpViewController:UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        guard let originalImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {
            dismiss(animated: false, completion: nil)
            return
        }
        guard let editedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {
            
            dismiss(animated: false, completion: nil)
            return
        }
        print(editedImage)
        picker.dismiss(animated: true, completion: nil)
        self.userProfileImage = originalImage
        self.buttonUploadImage.setImage(originalImage, for: .normal)
        
        
       //self.buttonParentImage.setBackgroundImage(originalImage, for: .normal)
       //self.presentImageEditor(image: originalImage)
    }
    @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            // we got back an error!
            let ac = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        
        picker.dismiss(animated: true, completion: nil)
        
    }
}
extension UITapGestureRecognizer {
    
    func didTapAttributedTextInLabel(label: UILabel, inRange targetRange: NSRange) -> Bool {
        // Create instances of NSLayoutManager, NSTextContainer and NSTextStorage
        let layoutManager = NSLayoutManager()
        let textContainer = NSTextContainer(size: CGSize.zero)
        let textStorage = NSTextStorage(attributedString: label.attributedText!)
        
        // Configure layoutManager and textStorage
        layoutManager.addTextContainer(textContainer)
        textStorage.addLayoutManager(layoutManager)
        
        // Configure textContainer
        textContainer.lineFragmentPadding = 0.0
        textContainer.lineBreakMode = label.lineBreakMode
        textContainer.maximumNumberOfLines = label.numberOfLines
        let labelSize = label.bounds.size
        textContainer.size = labelSize
        
        // Find the tapped character location and compare it to the specified range
        let locationOfTouchInLabel = self.location(in: label)
        let textBoundingBox = layoutManager.usedRect(for: textContainer)
        //let textContainerOffset = CGPointMake((labelSize.width - textBoundingBox.size.width) * 0.5 - textBoundingBox.origin.x,
        //(labelSize.height - textBoundingBox.size.height) * 0.5 - textBoundingBox.origin.y);
        let textContainerOffset = CGPoint(x: (labelSize.width - textBoundingBox.size.width) * 0.5 - textBoundingBox.origin.x, y: (labelSize.height - textBoundingBox.size.height) * 0.5 - textBoundingBox.origin.y)
        
        //let locationOfTouchInTextContainer = CGPointMake(locationOfTouchInLabel.x - textContainerOffset.x,
        // locationOfTouchInLabel.y - textContainerOffset.y);
        let locationOfTouchInTextContainer = CGPoint(x: locationOfTouchInLabel.x - textContainerOffset.x, y: locationOfTouchInLabel.y - textContainerOffset.y)
        let indexOfCharacter = layoutManager.characterIndex(for: locationOfTouchInTextContainer, in: textContainer, fractionOfDistanceBetweenInsertionPoints: nil)
        return NSLocationInRange(indexOfCharacter, targetRange)
    }
    
}
