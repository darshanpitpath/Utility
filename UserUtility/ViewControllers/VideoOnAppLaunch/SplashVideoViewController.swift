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

    
    var player: AVPlayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //LoadVideo On App launch
        self.loadVideo()
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
