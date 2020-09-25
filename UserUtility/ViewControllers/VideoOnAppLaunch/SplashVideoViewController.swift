//
//  SplashVideoViewController.swift
//  UserUtility
//
//  Created by IPS on 23/09/20.
//  Copyright © 2020 IPS. All rights reserved.
//


/* =============================
 Important steps
 Project -> General -> App Icon and Launch images
 - Set Main storyboard as Launch
 On Main storyboard set this ViewController as initial ViewController
=============================
 */

import UIKit
import AVKit

class SplashVideoViewController: UIViewController {

    @IBOutlet var lblUtility:UILabel!
    
    var player: AVPlayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.lblUtility.isHidden = !UIDevice.isSimulator
        
        if UIDevice.isSimulator{ // app run on simulator
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                self.pushtoLoginViewController()
            }
        }else{ //App run in device
            //LoadVideo On App launch
            self.loadVideo()
        }
       
    }

    //Stroke Animation Function
    func strokeAnimationFunction(isFirst:Int = 1){ // for int 1 2 same path color change 3 4 same path color change
        let objCAShapeLayer = CAShapeLayer()
            
        let objBezierpathSecond = UIBezierPath.init(arcCenter: CGPoint.init(x: UIScreen.main.bounds.width/2, y: UIScreen.main.bounds.height/2), radius: UIScreen.main.bounds.width/4, startAngle: CGFloat(Double.pi), endAngle: CGFloat(Double.pi*2), clockwise: true)
        
         let objBezierpathFirst = UIBezierPath.init(arcCenter: CGPoint.init(x: UIScreen.main.bounds.width/2, y: UIScreen.main.bounds.height/2), radius: UIScreen.main.bounds.width/4, startAngle: 0, endAngle: CGFloat(Double.pi*2), clockwise: true)
        if isFirst == 1 || isFirst == 2{
            objCAShapeLayer.path =  objBezierpathFirst.cgPath
        }else{
            objCAShapeLayer.path =  objBezierpathSecond.cgPath
        }
        objCAShapeLayer.path =  objBezierpathFirst.cgPath
        
        if isFirst == 1 || isFirst == 3{
            //objCAShapeLayer.lineWidth = 5.0
            objCAShapeLayer.strokeColor = UIColor.red.cgColor
        }else{
            //objCAShapeLayer.lineWidth = 10.0
            objCAShapeLayer.strokeColor = UIColor.white.cgColor
        }
        
        objCAShapeLayer.fillColor = UIColor.white.cgColor
        //Add Animation to shape layer
        let objAnimation = CABasicAnimation.init(keyPath: "strokeEnd")
        objAnimation.delegate = self
        objAnimation.fromValue = 0.0
        objAnimation.toValue = 1.0
        objAnimation.duration = 0.5
        objAnimation.fillMode = .forwards
        objAnimation.isRemovedOnCompletion = false
        objCAShapeLayer.add(objAnimation, forKey: "drawLineAnimation")
        objCAShapeLayer.name = "Progress"
        objCAShapeLayer.accessibilityValue = "\(isFirst)"
        
        self.view.layer.addSublayer(objCAShapeLayer)
    }

    
    private func loadVideo() {
           
           //dp// this line is important to prevent background music stop
           do {
               try AVAudioSession.sharedInstance().setCategory(.ambient, mode: .default, options: .defaultToSpeaker) // setCategory(AVAudioSession.Category.ambient)
           } catch { }
           
           
           NotificationCenter.default.addObserver(self, selector: #selector(itemDidFinishPlaying(_:)), name: .AVPlayerItemDidPlayToEndTime, object: player?.currentItem)

           let path = Bundle.main.path(forResource: "test", ofType:"mp4")
           
           let filePathURL = NSURL.fileURL(withPath: path!)
        
           
           player = AVPlayer(url: filePathURL)
           /*
           let playerViewController = AVPlayerViewController()
           playerViewController.player = player
           self.present(playerViewController, animated: true) {
              playerViewController.player?.play()
           }
           */
           let playerLayer = AVPlayerLayer(player: player)
           playerLayer.frame = UIScreen.main.bounds
           playerLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
           playerLayer.zPosition = -1
           self.view.layer.addSublayer(playerLayer)
           player?.seek(to: CMTime.zero)
           player?.play()
        
       }
      @objc func itemDidFinishPlaying(_ notification: Notification?) {
        //Push to application if not login then login or home for already logged in user
        self.pushtoLoginViewController()
      }
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    //PushToLogInViewController
    func pushtoLoginViewController(){
        if let loginViewController = self.storyboard?.instantiateViewController(identifier: "LogInViewController") as? LogInViewController{
            self.navigationController?.pushViewController(loginViewController, animated: true)
        }
    }
    
}
extension SplashVideoViewController:CAAnimationDelegate{
    
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        
        //self.view.layer.sublayers?.forEach{ ($0.name == "Progress"}.removeFromSuperlayer()}
        if let animationLayer = self.view.layer.sublayers?.filter({ $0.name == "Progress"}),let currentLayer = animationLayer.last{
            
            
            
            if let currentAccessibilityValue = currentLayer.accessibilityValue,let objInt = Int(currentAccessibilityValue){
                if objInt == 2 ||  objInt == 4 {
                    animationLayer.forEach { $0.removeFromSuperlayer()}
                }
                if objInt == 1{
                    self.strokeAnimationFunction(isFirst: 2)
                }else if objInt == 2{
                    self.strokeAnimationFunction(isFirst: 3)
                }else if objInt == 3{
                    self.strokeAnimationFunction(isFirst: 4)
                }else if objInt == 4{
                    self.strokeAnimationFunction(isFirst: 1)
                }
            }
            
        }
    }
}
