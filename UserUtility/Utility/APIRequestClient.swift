//
//  APIRequestClient.swift
//  TeenageSafety
//
//  Created by user on 19/11/19.
//  Copyright © 2019 user. All rights reserved.
//

import UIKit
import Alamofire


let kNoInternetError = "No Internet Please check network connection"

let kBaseURL = "http://app.overridesafety.com/api/"

let kUserLogin = "user/login"
let kUserForgot = "user/forgot"
let kParentForgotPassword = "parent/forgotpassword"
let kParentLogin = "parent/login"

let kVersion = "v1/"

typealias SUCCESS = (_ response:Any)->()
typealias FAIL = (_ response:Any)->()
typealias SUCCESSFAILResult = (Result< Any, Error >) -> ()
class APIRequestClient: NSObject {
    enum RequestType {
        case POST
        case GET
        case PUT
        case DELETE
        case PATCH
        case OPTIONS
    }
    static let shared:APIRequestClient = APIRequestClient()
    
    //Send Request with ResultType<Success, Error>
    func fetch(queryString:String = "",requestType:RequestType,isHudeShow:Bool,parameter:[String:AnyObject]?,completion:@escaping SUCCESSFAILResult){
        //Check internet connection as per your convenience
        guard CommonClass.shared.isConnectedToInternet else{
            ShowToast.show(toatMessage: kNoInternetError)
            //fail(["Error":kNoInternetError])
            return
        }
        
        //Show Hud
        if isHudeShow{
            DispatchQueue.main.async {
                ShowHud.show()
            }
        }
        let urlString = kBaseURL + kVersion + queryString
        //Check URL whitespace validation as per your convenience
    
        guard let requestURL = URL.init(string: urlString)  else {
            let obj = NSError.init(domain: "UserUtility", code: 100, userInfo: [NSLocalizedDescriptionKey:"Invalid URL"])
            completion(.failure(obj))
            return
        }
        
        var urlRequest = URLRequest.init(url: requestURL)
        urlRequest.cachePolicy = .reloadIgnoringLocalCacheData
        urlRequest.timeoutInterval = 60
        urlRequest.httpMethod = String(describing: requestType)
        urlRequest.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        urlRequest.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Accept")
        
        //Post URL parameters set as URL body
        if let params = parameter{
            do{
                let parameterData = try JSONSerialization.data(withJSONObject:params, options:.prettyPrinted)
                urlRequest.httpBody = parameterData
            }catch{
                DispatchQueue.main.async {
                    ShowHud.hide()
                }
               //Hide hude and return error
                completion(.failure(error))
            }
        }
        //URL Task to get data
        URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            DispatchQueue.main.async {
                ShowHud.hide()
            }
            //Hide Hud
            //fail completion for Error
            if let objError = error{
                completion(.failure(objError))
            }
            if let objResponse = response as? HTTPURLResponse,let _ = data{
                print("\(objResponse.statusCode)")
            }else{
                print("Error")
            }
            //Validate for blank data and URL response status code
            if let _ = data,let objURLResponse = response as? HTTPURLResponse{
                //We have data validate for JSON and convert in JSON
                do{
                    let objResposeJSON = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers)
                    print(objURLResponse.statusCode)
                    print(objResposeJSON)
                    //Check for valid status code 200 else fail with error
                    if objURLResponse.statusCode == 200{
                        completion(.success(objResposeJSON))
                    }
                }catch{
                    print(error.localizedDescription)
                    completion(.failure(error))
                }
            }
        }.resume()
    }
    //Upload Image API
    func uploadImageAPI(requestType:RequestType,queryString:String?,parameters:[String:AnyObject],imageData:Data?,isPdf:Bool = false,isHudShow:Bool,completion:@escaping SUCCESSFAILResult){
        guard CommonClass.shared.isConnectedToInternet else{
           ShowToast.show(toatMessage: kNoInternetError)
           return
        }

        //Show Hud
        if isHudShow{
           DispatchQueue.main.async {
               ShowHud.show()
           }
        }
        let urlString = kBaseURL + kVersion + (queryString == nil ? "" : queryString!)
        
        var headers: HTTPHeaders = ["Content-type": "multipart/form-data"]//,"X-API-KEY":kXAPIKey,"roll_id":"\(rollId)"]
        if User.isUserLoggedIn,let objUser = User.getUserFromUserDefault(){
            
        }
      
        
        AF.upload(multipartFormData: { (multipartFormData) in
                for (key, value) in parameters {
                    multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key as String)
                }
                
                if let _ = imageData{
                    if isPdf{
                        multipartFormData.append(imageData!, withName: "file", fileName: "file.pdf", mimeType: "application/pdf")
                    }else{
                        multipartFormData.append(imageData!, withName: "image", fileName: "image.png", mimeType: "image/png")
                    }
                    
                }
            }, to: "\(urlString)")
            { (result) in
                print(result)
                /*
                switch result {
                case .success(let upload, _, _):
                    
                    upload.uploadProgress(closure: { (progress) in
                        //Print progress
                        print("uploading \(progress)")
                        
                    })
                    
                    upload.responseJSON { response in
                        //print response.result
                        
                    }
                case .failure( _): break
                    //print encodingError.description
                }*/
            }
        
                 
        
    }
    
    //Post API
    func sendRequest(requestType:RequestType,queryString:String?,parameter:[String:AnyObject]?,isHudeShow:Bool,success:@escaping SUCCESS,fail:@escaping FAIL){
        guard CommonClass.shared.isConnectedToInternet else{
            ShowToast.show(toatMessage: kNoInternetError)
            //fail(["Error":kNoInternetError])
            return
        }
        if isHudeShow{
            DispatchQueue.main.async {
                ShowHud.show()
            }
        }
        
        let urlString = kBaseURL + kVersion + (queryString == nil ? "" : queryString!)
        var request = URLRequest(url: URL(string: urlString.removeWhiteSpaces())!)
        request.cachePolicy = .reloadIgnoringLocalCacheData
        request.timeoutInterval = 60
        request.httpMethod = String(describing: requestType)
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Accept")
       
        if let params = parameter{
            do{
                let parameterData = try JSONSerialization.data(withJSONObject:params, options:.prettyPrinted)
                request.httpBody = parameterData
            }catch{
                DispatchQueue.main.async {
                    ShowHud.hide()
                }
                ShowToast.show(toatMessage: kCommonError)
                fail(["error":kCommonError])
            }
        }
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            DispatchQueue.main.async {
                ShowHud.hide()
            }
            if error != nil{
                ShowToast.show(toatMessage: "\(error!.localizedDescription)")
                //fail(["error":"\(error!.localizedDescription)"])
            }
            if let _ = data,let httpStatus = response as? HTTPURLResponse{
                do{
                    let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers)
                    
                    (httpStatus.statusCode == 200) ? success(json):fail(json)
                }
                catch{
                    //ShowToast.show(toatMessage: kCommonError)
                    //fail(["error":kCommonError])
                }
            }else{
                ShowToast.show(toatMessage: kCommonError)
                fail(["error":kCommonError])
            }
        }
        task.resume()
    }
    //Image Upload with Multipart Data
    
    //Multiple Image upload with Multipart Data
    
    
    
    
}
