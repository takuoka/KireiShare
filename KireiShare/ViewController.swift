//
//  ViewController.swift
//  KireiShare
//
//  Created by Takuya Okamoto on 2015/07/07.
//  Copyright (c) 2015年 Uniface. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let testView = UIButton()
        testView.backgroundColor = UIColor.redColor()
        testView.frame = CGRect(x: 100, y: 100, width: 100, height: 100)
        self.view.addSubview(testView)
        testView.addTarget(self, action: "onTapButton", forControlEvents: .TouchUpInside)
        
        NSTimer.schedule(delay: 1) { timer in
            self.onTapButton()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func onTapButton() {
        let shareView = KireiShareView(
            text : "tstee",
            url  : "http://fjie.com",
            image: UIImage()
        )
        shareView.show()
    }

}

