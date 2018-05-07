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
        return UIApplication.shared.statusBarOrientation
    }
    
    func setOrientation(orientation: UIInterfaceOrientation) {
        let orientationNum: NSNumber = NSNumber(value: orientation.rawValue)
        UIDevice.current.setValue(orientationNum, forKey: "orientation")
    }
    
    func isLandscape() -> Bool {
        if (UIInterfaceOrientationIsLandscape(UIApplication.shared.statusBarOrientation)) {
            return true
        } else {
            return false
        }
    }
}

