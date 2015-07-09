//
//  KireiShareView.swift
//  KireiShare
//
//  Created by Takuya Okamoto on 2015/07/07.
//  Copyright (c) 2015年 Uniface. All rights reserved.
//

import Foundation
import UIKit
import Social


class KireiShareInfo {
    let text:String!
    let url:String?
    let image:UIImage?

    init(text:String, url:String?, image:UIImage?) {
        self.text = text
        self.url = url
        self.image = image
    }
}




public enum KireiShareType {
    case Twitter
    case Facebook
    case CopyLink
    case Other
    case Custom(title:String, icon:UIImage?, onTap:()->())

    func value() -> String {
        switch self {
        case .Twitter  : return SLServiceTypeTwitter
        case .Facebook : return SLServiceTypeFacebook
        case .CopyLink : return "CopyLink"
        case .Other : return "Other"
        case .Custom : return "Custom"
        }
    }

    func imageName() -> String {
        switch self {
        case .Twitter  : return "twitter"
        case .Facebook : return "facebook"
        case .CopyLink : return "link"
        case .Other : return "other"
        default : return "bugfuck"
        }
    }
}

// type behaver
extension KireiShareView {
    func buttonText(#type:KireiShareType) -> String {
        switch type {
        case .Twitter  : return "Twitter"
        case .Facebook : return "Facebook"
        case .Other : return otherButtonTitle
        case .CopyLink : return copyLinkButtonTitle
        case let .Custom(title, icon, onTap): return title
        }
    }

    func buttonIcon(#type:KireiShareType)-> UIImage? {
        switch type {
        case let .Custom(title, icon, onTap): return icon
        default: return imageNamed(type.imageName())
        }
    }

    func typeBehave(type:KireiShareType) {
        switch type {
        case .Twitter, .Facebook, .Other:
            self.openComposer(type) {
                self.dismiss()
            }
        case .CopyLink:
            self.copyLink()
            self.dismiss()
        case let .Custom(title, icon, onTap):
            onTap()
        }
    }

    func addButton(type:KireiShareType) {
        addButton(text: buttonText(type: type), icon: buttonIcon(type:type)) {
            self.typeBehave(type)
        }
    }
}






public class KireiShareView : UIViewController, UIGestureRecognizerDelegate {
    
    public var buttonList:[KireiShareType] = []
    public var otherButtonTitle = "Other"
    public var cancelButtonTitle = "Cancel"
    public var copyFinishedMessage = "Copy Succeed."
    public var copyFaildedMessage = "Copy Failed."
    public var copyLinkButtonTitle = "Copy Link"
    public var animationDuration: NSTimeInterval = 0.2

    private let defaultFont = UIFont(name: "HiraKakuProN-W6", size: 13)!
    private var maxSize:CGRect!
    private let buttonHeight:CGFloat = 60// TODO: あとで可変になるかも
    private let cancelButtonHeight:CGFloat = 52// TODO: あとで可変になるかも
    private let borderColor = UIColor(red: 246/255, green: 246/255, blue: 246/255, alpha: 1)
    private let cancelButtonColor = UIColor(red: 0.972549, green: 0.972549, blue: 0.972549, alpha: 1)
    private let cancelButtonTextColor = UIColor(red: 184/255, green: 184/255, blue: 184/255, alpha: 1)
    private let iconMarginLeft:CGFloat = 9
    private var backgroundAlpha:CGFloat = 0.8
    private let copiedMessageViewHeight:CGFloat = 50
    private let copiedMessageLabelMarginLeft:CGFloat = 12
    private let copiedMessageLabelTextColor = UIColor.whiteColor()
    private let copiedMessageViewColor = UIColor(white: 0.275, alpha: 1)
    private let copiedMessageFont = UIFont(name: "HiraKakuProN-W3", size: 12)!
    private var buttonsHeight:CGFloat {
        get { return maxSize.height - buttons.last!.top }
    }
    
    private var buttons:[UIButton] = []
    private var labels:[UILabel] = []
    private var icons:[UIImageView] = []
    private var borders:[UIView?] = []
    private var buttonActions:[()->()] = []

    var shareInfo: KireiShareInfo!
    let backgroundSheet = UIView()
    let buttonSheet = UIView()
    let copiedMessageView = UIView()
    let copiedMessageLabel = UILabel()
    

    
    
    public init(text:String, url:String?, image:UIImage?) {
        self.shareInfo = KireiShareInfo(text: text, url: url, image: image)
        super.init(nibName: nil, bundle: nil)
        self.setup()
    }
    required public init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup() {
        backgroundSheet.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(backgroundAlpha)
        copiedMessageView.backgroundColor = copiedMessageViewColor
        copiedMessageView.hidden = true
        copiedMessageLabel.font = copiedMessageFont
        copiedMessageLabel.textColor = copiedMessageLabelTextColor
        copiedMessageView.addSubview(copiedMessageLabel)
        
        self.view.addSubview(backgroundSheet)
        self.view.addSubview(buttonSheet)

        let tapGesture = UITapGestureRecognizer(target:self, action:"didTapBackgroundSheet")
        tapGesture.delegate = self
        buttonSheet.userInteractionEnabled = true
        buttonSheet.addGestureRecognizer(tapGesture)

        NSNotificationCenter.defaultCenter().addObserver(self, selector: "orientationDidChanged", name:UIDeviceOrientationDidChangeNotification, object: nil)
    }
    
    public func show() {
        viewWillShow()
        showAnimation()
    }
    
    public func dismiss() {
        disapperAnimation()
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }

    private func viewWillShow() {
        
        if buttonList.count == 0 {
            buttonList = [.Other, .CopyLink, .Facebook, .Twitter]
        }
        
        addCancelButton {
            self.dismiss()
        }

        for buttonType in buttonList {
            addButton(buttonType)
        }
        
        layoutViews()
    }
    
    func onTapButon(btn:UIButton!) {
        buttonActions[btn.tag]()
    }
    
    func didTapBackgroundSheet() {
        dismiss()
    }
    
    
    var orientation:UIInterfaceOrientation!
    func orientationDidChanged() {
        let newOrientation = getOrientation()
        switch newOrientation {
        case .Portrait, .PortraitUpsideDown:
            if orientation == nil || orientation != .Portrait {
                didPortrait()
            }
        case .LandscapeLeft, .LandscapeRight:
            didLandScape()
        default:
            print("")
        }
        orientation = getOrientation()
    }
    private func didPortrait() {
        self.layoutViews()
    }
    private func didLandScape() {
        self.layoutViews()
    }

}




// add button
extension KireiShareView {
    private func addCancelButton(onTapFunc:()->()) {
        addButton(
            text: cancelButtonTitle,
            icon: nil,
            height: cancelButtonHeight,
            bgColor: cancelButtonColor,
            textColor: cancelButtonTextColor,
            borderColor: nil,
            onTapFunc: onTapFunc
        )
    }
    private func addButton(#text:String, icon:UIImage?, onTapFunc:()->()) {
        addButton(
            text: text,
            icon: icon,
            height: buttonHeight,
            bgColor: UIColor.whiteColor(),
            textColor: UIColor.blackColor(),
            borderColor: borderColor,
            onTapFunc: onTapFunc
        )
    }
    private func addButton(#text:String, icon:UIImage?, height:CGFloat, bgColor:UIColor, textColor:UIColor, borderColor:UIColor?, onTapFunc:()->()) {
        let btn = UIButton()
        let iconView = UIImageView(image: icon)
        let label = UILabel()
        
        btn.tag = buttons.count
        buttons.append(btn)
        icons.append(iconView)
        labels.append(label)
        buttonActions.append(onTapFunc)
        
        var preBtn:UIButton? = nil
        if btn.tag != 0 {
            preBtn = buttons[(btn.tag - 1)]
        }
        
        iconView.contentMode = UIViewContentMode.Center
        label.text = text
        label.textAlignment = NSTextAlignment.Center
        label.font = self.defaultFont
        label.textColor = textColor
        btn.backgroundColor = bgColor
        
        var border: UIView? = nil
        if borderColor != nil {
            if btn.tag >= 2 {
                border = UIView()
                border!.backgroundColor = borderColor!
                buttonSheet.addSubview(border!)
            }
        }
        btn.addTarget(self, action: "onTapButon:", forControlEvents: .TouchUpInside)
        borders.append(border)
        
        btn.addSubview(label)
        btn.addSubview(iconView)
        buttonSheet.addSubview(btn)
    }
}




// layout
extension KireiShareView {
    private func imageNamed(name:String)->UIImage? {
        return UIImage(named: name, inBundle: NSBundle(forClass: KireiShareView.self), compatibleWithTraitCollection: nil)
    }
    
    private func showAnimation() {
        if UIApplication.sharedApplication().delegate == nil{
            println("window is not found.")
            return
        }
        buttonSheet.top = buttonSheet.top + buttonsHeight
        backgroundSheet.alpha = 0

        let window:UIWindow = UIApplication.sharedApplication().delegate!.window!!
        window.addSubview(copiedMessageView)
        window.addSubview(self.view)
        
        UIView.animateWithDuration(animationDuration, delay: 0, options: UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in
            self.backgroundSheet.alpha = 1
            self.buttonSheet.top = self.buttonSheet.top - self.buttonsHeight
            },
            completion: { _ in
        })
    }
    
    private func disapperAnimation() {
        UIView.animateWithDuration(animationDuration, delay: 0, options: UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in
            self.backgroundSheet.alpha = 0
            self.buttonSheet.top = self.buttonSheet.top + self.buttonsHeight
            },
            completion: { _ in
                self.view.removeFromSuperview()
                if self.copiedMessageView.hidden == true {
                    self.copiedMessageView.removeFromSuperview()
                }
                else {
                    NSTimer.schedule(delay: 1) { timer in
                        UIView.animateWithDuration(self.animationDuration, delay: 0, options: UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in
                            self.copiedMessageView.alpha = 0
                            },
                            completion: { _ in
                                self.copiedMessageView.removeFromSuperview()
                        })
                    }
                }
            }
        )
    }
    
    
    private func layoutViews() {
        maxSize = UIScreen.mainScreen().bounds
        buttonSheet.frame = maxSize
        backgroundSheet.frame = maxSize
        
        copiedMessageView.frame = CGRect(
            x: 0,
            y: maxSize.height - copiedMessageViewHeight,
            width: maxSize.width,
            height: copiedMessageViewHeight
        )
        
        copiedMessageLabel.frame = CGRect(
            x: copiedMessageLabelMarginLeft, y: 0,
            width: maxSize.width, height: copiedMessageViewHeight
        )
        
        for btn in buttons {
            let iconView = icons[btn.tag]
            let label = labels[btn.tag]
            var preBtn:UIButton? = nil
            if btn.tag != 0 {
                preBtn = buttons[(btn.tag - 1)]
            }
            
            var height = buttonHeight
            if btn.tag == 0 {
                height = cancelButtonHeight
            }
            
            iconView.frame = CGRect(x: iconMarginLeft, y: 0, width: height, height: height)
            label.frame = CGRect(x: 0, y: 0, width: maxSize.width, height: height)
            btn.frame = CGRect(x: 0, y: 0, width: maxSize.width, height: height)
            
            if preBtn == nil {
                btn.bottom = maxSize.height
            }
            else {
                btn.bottom = preBtn!.top
            }
            
            if borders[btn.tag] != nil {
                let brdr:UIView = borders[btn.tag]!
                brdr.frame = CGRect(x: 0, y: 0, width: maxSize.width, height: 1)
                brdr.bottom = preBtn!.top//borderがあるならpreBtnはある
                btn.bottom = brdr.top
            }
        }
    }

}

