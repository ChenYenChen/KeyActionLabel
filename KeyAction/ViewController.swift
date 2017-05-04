//
//  ViewController.swift
//  KeyAction
//
//  Created by 陳彥辰 on 2017/5/1.
//  Copyright © 2017年 Ray. All rights reserved.
//

import UIKit
import AudioToolbox

class ViewController: UIViewController {
    
    @IBOutlet weak var actionLabel: KeyActionLabel!

    @IBAction func sound(_ sender: Any) {
        let soundID: SystemSoundID = 2000
        
        //let path = Bundle.main.path(forResource: "SentMessage", ofType: "caf")
        
        
        
        AudioServicesPlaySystemSound(soundID)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.actionLabel.creatTabAction(title: "這是一個觸發點擊關鍵字的Label  線上       再幫忙到粉絲團            swift 讀書會           破2000人了(撒花 ～ 如果喜歡讀書會 再幫忙到粉絲團給個 5 star ", fontSize: 17, color: UIColor.brown, keyword: ["關鍵字", "5 star"], keywordColor: UIColor.red) { (index) in
            
            let alert = UIAlertController(title: "觸發", message: index == 0 ? "關鍵字" : "5 star", preferredStyle: .alert)
            let button = UIAlertAction(title: "確定", style: .default, handler: nil)
            alert.addAction(button)
            self.present(alert, animated: true, completion: nil)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

