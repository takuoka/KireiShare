//
//  ShareActions.swift
//  KireiShare
//
//  Created by Takuya Okamoto on 2015/07/07.
//  Copyright (c) 2015年 Uniface. All rights reserved.
//

import UIKit
import Social

extension KireiShareView {
    
    public func copyLink() {
        UIPasteboard.general.string = shareInfo.url

        if (UIPasteboard.general.string == shareInfo.url) {
            self.copiedMessageLabel.text = self.copyFinishedMessage
        }
        else {
            self.copiedMessageLabel.text = self.copyFaildedMessage
        }

        self.copiedMessageView.isHidden = false
    }
    
    public func openComposer(type:KireiShareType, completion:(()->())?) {
        switch type {
        case .Other:
            openActivityView(completion: completion)

        default:
            //if SLComposeViewController.isAvailableForServiceType(type.value()) {
            let composeVC = SLComposeViewController(forServiceType: type.value())
            composeVC?.setInitialText(shareInfo.text)
            if shareInfo.url != nil {
                if let urlObj = NSURL(string: shareInfo.url!) {
                    composeVC?.add(urlObj as URL?)
                }
            }
            if shareInfo.image != nil {
                composeVC?.add(shareInfo.image!)
            }
            
            if completion != nil {
                composeVC?.completionHandler = { (result:SLComposeViewControllerResult) -> () in
                    switch (result) {
                    case SLComposeViewControllerResult.done:
                        completion!()
                    case SLComposeViewControllerResult.cancelled:
                        completion!()
                    }
                }
            }
            self.present(composeVC!, animated: true, completion: nil)
        }
    }
    
    private func openActivityView(completion:(()->())?) {
        var items:[AnyObject] = []

        items.append(shareInfo.text as AnyObject)

        if shareInfo.url != nil {
            if let urlObj = NSURL(string: shareInfo.url!) {
                items.append(urlObj)
            }
        }
        
        if shareInfo.image != nil {
            items.append(shareInfo.image!)
        }

        let activityVC = UIActivityViewController(
            activityItems: items,
            applicationActivities: nil
        )
        activityVC.completionWithItemsHandler = { activityType, isCompleted, returnedItems, error in
            if (isCompleted) {
                completion?()
            }
        }
        self.present(activityVC, animated: true, completion: nil)
    }
}
