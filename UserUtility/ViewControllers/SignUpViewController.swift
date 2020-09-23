//
//  SignUpViewController.swift
//  UserUtility
//
//  Created by IPS on 07/04/20.
//  Copyright © 2020 IPS. All rights reserved.
//

import UIKit
import MobileCoreServices

class SignUpViewController: UIViewController {
    
    @IBOutlet var buttonBack:UIButton!
    @IBOutlet var buttonAddImage:UIButton!
    @IBOutlet var buttonUploadImage:RoundButton!
    @IBOutlet var buttonSignUp:UIButton!
    @IBOutlet var buttonCheck:UIButton!
    
    
    @IBOutlet var lblTermsAndCondition:UILabel!
    
    @IBOutlet var txtDisplayName:UITextField!
    @IBOutlet var txtEmail:UITextField!
    @IBOutlet var txtPassword:UITextField!
    @IBOutlet var txtConfirmPassword:UITextField!
    
    @IBOutlet var buttonCamera:UIButton!
    
    
    let text = "I agree to the Terms and Conditions."
    let termsConditionsURL = "https://www.google.com"
    var isPasswordShow:Bool = false
    var isConfirmPasswordShow:Bool = false
    var userProfileImage:UIImage?
    var objPassword:UIButton?
    var objConfirmPassword:UIButton?
    var addUserParameters:[String:Any] = [:]
    private var isterms:Bool = false
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

        // Do any additional setup after loading the view.
        self.setUp()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.hideKeyBoard()
        self.configureBackSelector()
        self.configureSignUpSelector()
        self.configureTermsAndCondition()
        self.configurePasswordTextField()
        self.configureConfirmPasswordTextField()
    }
    func setUp(){
        self.txtDisplayName.placeholder = "UserName"
        self.txtEmail.placeholder = "Email"
        self.txtPassword.placeholder = "Password"
        self.txtConfirmPassword.placeholder = "Confirm Password"
         self.txtDisplayName.delegate = self
         self.txtEmail.delegate = self
         self.txtPassword.delegate = self
         self.txtConfirmPassword.delegate = self
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
          self.buttonBack.setImage(objIMage, for: .normal)
          self.buttonBack.tintColor = UIColor.label
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
            self.present(actionSheetController, animated: true, completion: nil)
        }
    func presentImagePickerController(){
        self.view.endEditing(true)
        self.present(self.objImagePickerController, animated: true, completion: nil)
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
            if let objURL = URL.init(string:termsConditionsURL){
                if UIApplication.shared.canOpenURL(objURL){
                    UIApplication.shared.open(objURL, options: [:], completionHandler: nil)
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
extension SignUpViewController:UITextFieldDelegate{
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let typpedString = ((textField.text)! as NSString).replacingCharacters(in: range, with: string)
        
        if textField != self.txtDisplayName{
            guard !typpedString.isContainWhiteSpace() else{
                return false
            }
        }
        if textField == self.txtDisplayName{
            self.addUserParameters["name"] = "\(typpedString)"
        }else if textField == self.txtEmail{
            self.addUserParameters["email"] = "\(typpedString)"
        }else if textField == self.txtPassword{
            self.addUserParameters["password"] = "\(typpedString)"
        }else if textField == self.txtConfirmPassword{
            self.addUserParameters["confirm_password"] = "\(typpedString)"
        }else{
           
        }
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
