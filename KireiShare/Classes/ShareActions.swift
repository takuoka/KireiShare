//
//  ShareActions.swift
//  KireiShare
//
//  Created by Takuya Okamoto on 2015/07/07.
//  Copyright (c) 2015年 Uniface. All rights reserved.
//



import UIKit
import Social


class ShareActions {
    
    static func openShareView(viewController:UIViewController, text:String, url:String?, image:UIImage?, completion:(()->())?) {
        var items:[AnyObject] = []

        items.append(text)
        if url != nil {
            if let urlObj = NSURL(string: url!) {
                items.append(urlObj)
            }
        }
        
        if image != nil {
            items.append(image!)
        }

        let activityVC = UIActivityViewController(
            activityItems: items,
            applicationActivities: nil
        )
        activityVC.completionWithItemsHandler = {(activityType, isCompleted:Bool, returnedItems:Array!, error:NSError!) in
            if (isCompleted) {
                completion?()
            }
        }
        viewController.presentViewController(activityVC, animated: true, completion: nil)
    }
    
    

    static func openComposer(viewController:UIViewController, type:ComposerType, text:String, url:String?, image:UIImage?, completion:(()->())?) {
        
        println("openComposer")
//        if SLComposeViewController.isAvailableForServiceType(type.value()) {
            let composeVC = SLComposeViewController(forServiceType: type.value())
            composeVC.setInitialText(text)
            if url != nil {
                if let urlObj = NSURL(string: url!) {
                    composeVC.addURL(urlObj)
                }
            }
            if image != nil {
                composeVC.addImage(image)
            }

            if completion != nil {
                composeVC.completionHandler = { (result:SLComposeViewControllerResult) -> () in
                    switch (result) {
                    case SLComposeViewControllerResult.Done:
                        println("SLComposeViewControllerResult.Done")
                        completion!()
                    case SLComposeViewControllerResult.Cancelled:
                        println("SLComposeViewControllerResult.Cancelled")
                        completion!()
                    }
                }
            }
            viewController.presentViewController(composeVC, animated: true, completion: nil)
//        }
//        else {
//            println("\(type.value()) is not available!")
//        }
    }
}


enum ComposerType {
    case Twitter
    case Facebook
    func value() -> String {
        switch self {
        case .Twitter:return SLServiceTypeTwitter
        case .Facebook:return SLServiceTypeFacebook
        }
    }
}

