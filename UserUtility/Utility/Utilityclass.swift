//
//  Utilityclass.swift
//  UserUtility
//
//  Created by IPS on 07/04/20.
//  Copyright © 2020 IPS. All rights reserved.
//

import Foundation
import UIKit
import SystemConfiguration

class CommonClass: NSObject {
    //SingleTon
       static let shared:CommonClass = {
          let common = CommonClass()
          return common
       }()
       var isConnectedToInternet:Bool{
           get{
               var zeroAddress = sockaddr_in()
               zeroAddress.sin_len = UInt8(MemoryLayout<sockaddr_in>.size)
               zeroAddress.sin_family = sa_family_t(AF_INET)
               
               guard let defaultRouteReachability = withUnsafePointer(to: &zeroAddress, {
                   $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {
                       SCNetworkReachabilityCreateWithAddress(nil, $0)
                   }
               }) else {
                   return false
               }
               
               var flags: SCNetworkReachabilityFlags = []
               if !SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags) {
                   return false
               }
               
               let isReachable = flags.contains(.reachable)
               let needsConnection = flags.contains(.connectionRequired)
               return (isReachable && !needsConnection)
           }
       }
}
extension String{
    func removeWhiteSpaces()->String
       {
           return self.replacingOccurrences(of: " ", with: "")
       }
    func isContainWhiteSpace()->Bool{
        guard self.rangeOfCharacter(from: NSCharacterSet.whitespacesAndNewlines) == nil else{
            return true
        }
        return false
    }
    func isValidEmail() -> Bool {
           let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
           return NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: self)
       }
}
class ShowToast: NSObject {
    static var lastToastLabelReference:UILabel?
    static var initialYPos:CGFloat = 0
    class func show(toatMessage:String,color:UIColor = kThemeColor)
    {
        DispatchQueue.main.async {
            guard toatMessage != kCommonError else{
                
               return
            }
            if let keyWindow = UIApplication.shared.keyWindowInConnectedScenes{
                   //if let app = UIApplication.shared.delegate as? AppDelegate, let keyWindow = app.window{
      
            ShowHud.hide()
            if lastToastLabelReference != nil
            {
                let prevMessage = lastToastLabelReference!.text?.replacingOccurrences(of: " ", with: "").lowercased()
                let currentMessage = toatMessage.replacingOccurrences(of: " ", with: "").lowercased()
                if prevMessage == currentMessage
                {
                    return
                }
            }
            
            let cornerRadious:CGFloat = 12
            let toastContainerView:UIView={
                let view = UIView()
                view.layer.cornerRadius = cornerRadious
                view.translatesAutoresizingMaskIntoConstraints = false
                view.backgroundColor = color//UIColor.init(hexString: "#808080")//UIColor.black//kSchoolThemeColor//UIColor.black.withAlphaComponent(0.8)
                view.alpha = 1
                return view
            }()
            let labelForMessage:UILabel={
                let label = UILabel()
                label.layer.cornerRadius = cornerRadious
                label.layer.masksToBounds = true
                label.textAlignment = .center
                label.numberOfLines = 0
                label.adjustsFontSizeToFitWidth = true
                label.translatesAutoresizingMaskIntoConstraints = false
                label.text = toatMessage
                label.textColor = .white
                label.backgroundColor = UIColor.init(white: 0, alpha: 0)
                return label
            }()
            
            keyWindow.addSubview(toastContainerView)
            
            let fontType = UIFont.boldSystemFont(ofSize: DeviceType.isIpad() ? 14 : 12)
            labelForMessage.font = fontType
            
            let sizeOfMessage = NSString(string: toatMessage).boundingRect(with: CGSize(width: keyWindow.frame.width, height: keyWindow.frame.height), options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font:fontType], context: nil)
            
//            let topAnchor = toastContainerView.topAnchor.constraint(equalTo: keyWindow.bottomAnchor, constant: 0)
            let topAnchor = toastContainerView.bottomAnchor.constraint(equalTo: keyWindow.topAnchor, constant: 0)
            keyWindow.addConstraint(topAnchor)
            
            toastContainerView.centerXAnchor.constraint(equalTo: keyWindow.centerXAnchor, constant: 0).isActive = true
            
            var extraHeight:CGFloat = 0
            if (keyWindow.frame.size.width) < (sizeOfMessage.width+20)
            {
                extraHeight = (sizeOfMessage.width+20) - (keyWindow.frame.size.width)
                toastContainerView.leftAnchor.constraint(equalTo: keyWindow.leftAnchor, constant: 5).isActive = true
                toastContainerView.rightAnchor.constraint(equalTo: keyWindow.rightAnchor, constant: -5).isActive = true
            }
            else
            {
                toastContainerView.widthAnchor.constraint(equalToConstant: sizeOfMessage.width+20).isActive = true
            }
            let totolHeight:CGFloat = sizeOfMessage.height+25+extraHeight
            toastContainerView.heightAnchor.constraint(equalToConstant:totolHeight).isActive = true
            toastContainerView.addSubview(labelForMessage)
            lastToastLabelReference = labelForMessage
            labelForMessage.topAnchor.constraint(equalTo: toastContainerView.topAnchor, constant: 0).isActive = true
            labelForMessage.bottomAnchor.constraint(equalTo: toastContainerView.bottomAnchor, constant: 0).isActive = true
            labelForMessage.leftAnchor.constraint(equalTo: toastContainerView.leftAnchor, constant: 5).isActive = true
            labelForMessage.rightAnchor.constraint(equalTo: toastContainerView.rightAnchor, constant: -5).isActive = true
            keyWindow.layoutIfNeeded()
            
            let padding:CGFloat = initialYPos == 0 ? (DeviceType.isIpad() ? 100 : 70) : 10 // starting position
            initialYPos += padding+totolHeight
            topAnchor.constant = initialYPos
            
            UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 0.4, initialSpringVelocity: 0.4, options: .curveEaseIn, animations: {
                keyWindow.layoutIfNeeded()
            }, completion: { (bool) in
                
                topAnchor.constant = 0
                UIView.animate(withDuration: 0.4, delay: 3, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveLinear, animations: {
                    keyWindow.layoutIfNeeded()
                }, completion: { (bool) in
                    if let lastToastShown = lastToastLabelReference,labelForMessage == lastToastShown
                    {
                        lastToastLabelReference = nil
                    }
                    initialYPos -= (padding+totolHeight)
                    toastContainerView.removeFromSuperview()
                })
            })
        }
    }
   }
}
let kThemeColor = UIColor.init(hexString: "000000")
let kCommonError = "Server Error"

class DeviceType{
    class func isIpad()->Bool
    {
        return UIDevice.current.userInterfaceIdiom == .pad ? true : false
    }
}
extension UIApplication{
     ///The app's key window taking into consideration apps that support multiple scenes.
       var keyWindowInConnectedScenes: UIWindow? {
           return windows.first(where: { $0.isKeyWindow })
       }
}
extension UIColor {
    convenience init(hexString: String) {
        let hex = hexString.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt32()
        Scanner(string: hex).scanHexInt32(&int)
        let a, r, g, b: UInt32
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(a) / 255)
    }
}
class ShowHud:NSObject{
    static let disablerView:UIView={
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.init(white: 0, alpha: 0.15)
        return view
    }()
    
    static let containerView:UIView={
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 16
        view.backgroundColor = UIColor.white//UIColor.init(white: 0.3, alpha: 0)
        return view
    }()
    static var loadingIndicator:UIActivityIndicatorView={
        let loading = UIActivityIndicatorView()
        loading.translatesAutoresizingMaskIntoConstraints = false
        loading.style = .whiteLarge
        loading.backgroundColor = .clear
        loading.color = .black
        loading.layer.cornerRadius = 16
        loading.layer.masksToBounds = true
        return loading
    }()
    static let loadingMsgLabel:UILabel={
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Please wait"//Vocabulary.getWordFromKey(key: "loading_hud_please_wait").capitalizingFirstLetter()
        label.textAlignment = .center
        let fontType = UIFont.systemFont(ofSize: DeviceType.isIpad() ? 16 : 14)
        label.font = fontType
        label.textColor = .white
        label.backgroundColor = .clear
        label.adjustsFontSizeToFitWidth = true
        label.alpha = 0
        return label
    }()
    
    static var timerToHideHud:Timer?
    static var timerToShowHud:Timer?
    
    class func show(loadingMessage:String = "Please wait"/*Vocabulary.getWordFromKey(key: "loading_hud_please_wait")*/)
    {
        ShowHud.timerToHideHud?.invalidate()
        UIApplication.shared.resignFirstResponder()
        
        ShowHud.timerToShowHud = Timer.scheduledTimer(timeInterval: 1, target: ShowHud.self, selector: #selector(ShowHud.showHudAfterOneSecond), userInfo: nil, repeats: false)
        
        
    }
    
    class func hide(){
        
        ShowHud.timerToShowHud?.invalidate()
        ShowHud.timerToHideHud = Timer.scheduledTimer(timeInterval: 1, target: ShowHud.self, selector: #selector(ShowHud.hideAfterOneSecond), userInfo: nil, repeats: false)
    }
    
    @objc class func hideAfterOneSecond(){
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
        ShowHud.loadingIndicator.stopAnimating()
        ShowHud.disablerView.removeFromSuperview()
        timerToHideHud?.invalidate()
    }
    @objc class func showHudAfterOneSecond(){
        if let keyWindow = UIApplication.shared.keyWindowInConnectedScenes{
        //if let app = UIApplication.shared.delegate as? AppDelegate, let keyWindow = app.window{
            if !ShowHud.loadingIndicator.isAnimating
            {
                //  loadingMsgLabel.text = loadingMessage
                UIApplication.shared.isNetworkActivityIndicatorVisible = true
                
                keyWindow.addSubview(disablerView)
                disablerView.rightAnchor.constraint(equalTo: keyWindow.rightAnchor).isActive = true
                disablerView.leftAnchor.constraint(equalTo: keyWindow.leftAnchor).isActive = true
                disablerView.topAnchor.constraint(equalTo: keyWindow.topAnchor).isActive = true
                disablerView.bottomAnchor.constraint(equalTo: keyWindow.bottomAnchor).isActive = true
                ShowHud.loadingIndicator.startAnimating()
                
                disablerView.addSubview(containerView)
                
                containerView.centerXAnchor.constraint(equalTo: disablerView.centerXAnchor).isActive = true
                containerView.centerYAnchor.constraint(equalTo: disablerView.centerYAnchor).isActive = true
                let squareSize:CGFloat = DeviceType.isIpad() ? 160 : 140
                containerView.widthAnchor.constraint(equalToConstant: squareSize).isActive = true
                containerView.heightAnchor.constraint(equalToConstant: squareSize).isActive = true
                
                
                containerView.addSubview(loadingMsgLabel)
                loadingMsgLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor ,constant:-10).isActive = true
                loadingMsgLabel.rightAnchor.constraint(equalTo: containerView.rightAnchor,constant:-6).isActive = true
                loadingMsgLabel.leftAnchor.constraint(equalTo: containerView.leftAnchor,constant:6).isActive = true
                
                containerView.addSubview(loadingIndicator)
                loadingIndicator.centerXAnchor.constraint(equalTo: containerView.centerXAnchor).isActive = true
                loadingIndicator.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
            }
            else
            {
                //  loadingMsgLabel.text = loadingMessage
            }
        }
    }
}
class RoundButton:UIButton{
    
    required init?(coder aDecoder: NSCoder) {
            super.init(coder: aDecoder)
            self.layer.cornerRadius = self.bounds.size.height/2
            self.layer.masksToBounds = true
            self.clipsToBounds = true
//            self.imageView?.contentMode = .scaleAspectFit
        
    }
}
