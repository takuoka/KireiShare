//
//  ShareActions.swift
//  KireiShare
//
//  Created by Takuya Okamoto on 2015/07/07.
//  Copyright (c) 2015年 Uniface. All rights reserved.
//



import UIKit


class ShareActions {
    
    static func openShareView(text:String, url:String, viewController:UIViewController) {
        let shareText = text
        let shareWebsite = NSURL(string: url)!
        //let shareImage = UIImage(named: "shareSample.png")!
        let activityItems = [shareText, shareWebsite]//, shareImage]
        let activityVC = UIActivityViewController(
            activityItems: activityItems,
            applicationActivities: nil
        )
        activityVC.completionWithItemsHandler = {(activityType, completed:Bool, returnedItems:Array!, error:NSError!) in
            if (completed) {
                // ここに完了後の処理を書く
                println("完了！")
            }
        }
        viewController.presentViewController(activityVC, animated: true, completion: nil)
    }
}

