//
//  ViewController.swift
//  KireiShare
//
//  Created by Takuya Okamoto on 2015/07/07.
//  Copyright (c) 2015年 Uniface. All rights reserved.
//

import UIKit
import Pods_KireiShare

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let testView = UIButton()
        testView.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        testView.setTitle("open", for: .normal)
        testView.setTitleColor(.white, for: .normal)
        testView.frame = CGRect(x: 100, y: 100, width: 100, height: 100)
        self.view.addSubview(testView)
        testView.addTarget(self, action: #selector(ViewController.onTapButton), for: .touchUpInside)
        
    }

    @objc func onTapButton() {
        
        let shareView = KireiShareView(
            text: "Simple & Beautiful ShareView!",
            url: "http://uniface.in/",
            image: nil
        )

        shareView.otherButtonTitle = "Other"
        shareView.cancelButtonTitle = "Cancel"
        shareView.copyLinkButtonTitle = "Copy link"
        shareView.copyFinishedMessage = "Finished message"
        shareView.animationDuration = 0.2
        
        shareView.buttonList = [
            .Other,
            .CopyLink,
            .Facebook,
            .Twitter,                       
        ]

        shareView.show()
    }
}
