//
//  UIVIewControllerEx.swift
//  KireiShare
//
//  Created by Takuya Okamoto on 2015/07/08.
//  Copyright (c) 2015年 Uniface. All rights reserved.
//

import UIKit

extension UIViewController {
    func getOrientation() -> UIInterfaceOrientation {
        return UIApplication.sharedApplication().statusBarOrientation
    }
    
    func setOrientation(orientation: UIInterfaceOrientation) {
        var orientationNum: NSNumber = NSNumber(integer: orientation.rawValue)
        UIDevice.currentDevice().setValue(orientationNum, forKey: "orientation")
    }
    
    func isLandscape() -> Bool {
        if (UIInterfaceOrientationIsLandscape(UIApplication.sharedApplication().statusBarOrientation)) {
            return true
        }
        else {
            return false
        }
    }
}

