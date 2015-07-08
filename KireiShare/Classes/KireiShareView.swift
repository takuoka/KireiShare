//
//  KireiShareView.swift
//  KireiShare
//
//  Created by Takuya Okamoto on 2015/07/07.
//  Copyright (c) 2015年 Uniface. All rights reserved.
//

// 🌱 TODO
// * exclude enumで
import Foundation
import UIKit


public class KireiShareView : UIViewController, UIGestureRecognizerDelegate {

    
    public var otherButtonText = "Other"
    public var cancelText = "Cancel"
    public var copyFinishedMessage = "Copy Succeed."
    public var copyFaildedMessage = "Copy Failed."
    public var copyLinkText = "Copy Link"
    
    private let text:String!
    private let url:String?
    private let image:UIImage?
    private var buttons:[UIButton] = []
    private var labels:[UILabel] = []
    private var icons:[UIImageView] = []
    private var borders:[UIView?] = []
    private var buttonActions:[()->()] = []
    private let defaultFont = UIFont(name: "HiraKakuProN-W6", size: 13)!

    private var maxSize:CGRect!
    private let buttonHeight:CGFloat = 60// TODO: あとで可変になるかも
    private let cancelButtonHeight:CGFloat = 50// TODO: あとで可変になるかも
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

    private let backgroundSheet = UIView()
    private let buttonSheet = UIView()
    private let copiedMessageView = UIView()
    private let copiedMessageLabel = UILabel()
    

    
    
    
    public init(text:String, url:String?, image:UIImage?) {
        self.text = text
        self.url = url
        self.image = image
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
    
    
    private func imageNamed(name:String)->UIImage? {
        return UIImage(named: name, inBundle: NSBundle(forClass: KireiShareView.self), compatibleWithTraitCollection: nil)
    }
    
    
    private func viewWillShow() {
        addCancelButton {
            self.disappear()
        }
        addButton(text:otherButtonText, icon: imageNamed("other")) {
            ShareActions.openShareView(self, text: self.text, url: self.url, image: self.image) {
                self.disappear()
            }
        }
        addButton(text:copyLinkText, icon: imageNamed("link")) {
            if self.url != nil {
                UIPasteboard.generalPasteboard().string = self.url
                if (UIPasteboard.generalPasteboard().string == self.url) {
                    self.copiedMessageLabel.text = self.copyFinishedMessage
                }
                else {
                    self.copiedMessageLabel.text = self.copyFaildedMessage
                }
                self.copiedMessageView.hidden = false
                self.disappear()
            }
        }
        addButton(text:"Facebook", icon: imageNamed("facebook")) {
            ShareActions.openComposer(self, type: ComposerType.Facebook, text: self.text, url: self.url, image: self.image) {
                self.disappear()
            }
        }
        addButton(text:"Twitter", icon: imageNamed("twitter")) {
            ShareActions.openComposer(self, type: ComposerType.Twitter, text: self.text, url: self.url, image: self.image) {
                self.disappear()
            }
        }
        
        layoutViews()
    }
    
    
    
    private func addCancelButton(onTapFunc:()->()) {
        addButton(
            text: cancelText,
            icon: nil,
            height: cancelButtonHeight,
            bgColor: cancelButtonColor,
            textColor: cancelButtonTextColor,
            borderColor: nil,
            onTapFunc: onTapFunc
        )
    }
    func addButton(#text:String, icon:UIImage?, onTapFunc:()->()) {
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
    func addButton(#text:String, icon:UIImage?, height:CGFloat, bgColor:UIColor, textColor:UIColor, borderColor:UIColor?, onTapFunc:()->()) {
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
    
    
    func layoutViews() {
        println("layoutViews")
        
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
    
    
    
    func onTapButon(btn:UIButton!) {
        buttonActions[btn.tag]()
    }
    
    func didTapBackgroundSheet() {
        disappear()
    }
    
    
    var orientation:UIInterfaceOrientation!
    func orientationDidChanged() {
        let newOrientation = getOrientation()
        switch newOrientation {
        case .Portrait, .PortraitUpsideDown:
            if orientation != nil && orientation != .Portrait {
                didPortrait()
            }
        case .LandscapeLeft, .LandscapeRight:
            didLandScape()
        default:
            print("")
        }
        orientation = getOrientation()
    }
    func didPortrait() {
        println("👉portrait")
        self.layoutViews()
    }
    func didLandScape() {
        println("👉landscape")
        self.layoutViews()
    }

    
    
    public func show() {
        if UIApplication.sharedApplication().delegate == nil{
            println("window is not found.")
            return
        }
        let window:UIWindow = UIApplication.sharedApplication().delegate!.window!!
        viewWillShow()
        
        buttonSheet.top = buttonSheet.top + buttonsHeight
        backgroundSheet.alpha = 0
        
        window.addSubview(copiedMessageView)
        window.addSubview(self.view)
        
        UIView.animateWithDuration(0.2, delay: 0, options: UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in
            self.backgroundSheet.alpha = 1
            self.buttonSheet.top = self.buttonSheet.top - self.buttonsHeight
        },
        completion: { _ in
        })
    }
    
    func disappear() {
        UIView.animateWithDuration(0.2, delay: 0, options: UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in
            self.backgroundSheet.alpha = 0
            self.buttonSheet.top = self.buttonSheet.top + self.buttonsHeight
        },
        completion: { _ in
            self.view.removeFromSuperview()
            if self.copiedMessageView.hidden == false {
                NSTimer.schedule(delay: 1) { timer in
                    UIView.animateWithDuration(0.2, delay: 0, options: UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in
                        self.copiedMessageView.alpha = 0
                    },
                    completion: { _ in
                        self.copiedMessageView.removeFromSuperview()
                    })
                }
            }
            else {
                self.copiedMessageView.removeFromSuperview()
            }
        })
        
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
}


