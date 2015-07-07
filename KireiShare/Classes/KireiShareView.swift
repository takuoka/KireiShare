//
//  KireiShareView.swift
//  KireiShare
//
//  Created by Takuya Okamoto on 2015/07/07.
//  Copyright (c) 2015年 Uniface. All rights reserved.
//

// 🌱 TODO
// * exclude enumで

import UIKit


public class KireiShareView : UIViewController {

    private let text:String!
    private let url:String?
    private let image:UIImage?
    private var buttons:[UIButton] = []
    private var buttonActions:[()->()] = []
    private let defaultFont = UIFont(name: "HiraKakuProN-W6", size: 13)!

    private var maxSize:CGRect!
    private let buttonHeight:CGFloat = 60// TODO: あとで可変になるかも
    private let cancelButtonHeight:CGFloat = 50// TODO: あとで可変になるかも
    private let borderColor = UIColor(red: 246/255, green: 246/255, blue: 246/255, alpha: 1)
    private let cancelButtonColor = UIColor(red: 0.972549, green: 0.972549, blue: 0.972549, alpha: 1)
    private let cancelButtonTextColor = UIColor(red: 184/255, green: 184/255, blue: 184/255, alpha: 1)
    private let iconMarginLeft:CGFloat = 9

    public var copyFinishedMessage = "Succeed."
    
    private let backgroundSheet = UIView()
    private let buttonSheet = UIView()

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

    func setup() {
        maxSize = UIScreen.mainScreen().bounds

        backgroundSheet.frame = maxSize
        backgroundSheet.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.2)
        self.view.addSubview(backgroundSheet)
        
        buttonSheet.frame = maxSize
        self.view.addSubview(buttonSheet)

        addCancelButton {
            self.disappear()
        }
    }
    
    
    func initViews() {
        println("initViews")
        addButton(text:"その他", icon:nil) {
            println("そのた")
            ShareActions.openShareView(self, text: self.text, url: self.url, image: self.image) {
                self.disappear()
            }
        }
        addButton(text:"Copy Link", icon:nil) {
            println("こぴ")
            if self.url != nil {
                UIPasteboard.generalPasteboard().string = self.url
            }
        }
        addButton(text:"Facebook", icon:nil) {
            println("fb")
            ShareActions.openComposer(self, type: ComposerType.Facebook, text: self.text, url: self.url, image: self.image) {
                self.disappear()
            }
        }
        addButton(text:"Twitter", icon:UIImage(named: "twitter")) {
            println("twiた")
            ShareActions.openComposer(self, type: ComposerType.Twitter, text: self.text, url: self.url, image: self.image) {
                self.disappear()
            }
        }
    }
    
    
    
    func addCancelButton(onTapFunc:()->()) {
        addButton(
            text: "キャンセル",
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
        println("addButton")
        let btn = UIButton()
        let iconView = UIImageView(image: icon)
        let label = UILabel()

        iconView.frame = CGRect(x: iconMarginLeft, y: 0, width: height, height: height)
        label.frame = CGRect(x: 0, y: 0, width: maxSize.width, height: height)
        btn.frame = CGRect(x: 0, y: 0, width: maxSize.width, height: height)
        if buttons.last == nil {
            btn.bottom = maxSize.height
        }
        else {
            btn.bottom = buttons.last!.top
        }

        iconView.contentMode = UIViewContentMode.Center
        label.text = text
        label.textAlignment = NSTextAlignment.Center
        label.font = self.defaultFont
        label.textColor = textColor
        btn.backgroundColor = bgColor
        if borderColor != nil {
            if buttons.count >= 2 {
                let border = UIView()
                border.frame = CGRect(x: 0, y: 0, width: maxSize.width, height: 1)
                border.bottom = buttons.last!.top
                border.backgroundColor = borderColor!
                self.view.addSubview(border)
                btn.bottom = border.top
            }
        }
        btn.addTarget(self, action: "onTapButon:", forControlEvents: .TouchUpInside)
        
        btn.tag = buttons.count
        buttonActions.append(onTapFunc)
        buttons.append(btn)
        btn.addSubview(label)
        btn.addSubview(iconView)
        buttonSheet.addSubview(btn)
    }
    
    func onTapButon(btn:UIButton!) {
        buttonActions[btn.tag]()
    }
    
    
    
    public func show() {
        if UIApplication.sharedApplication().delegate == nil{
            println("Window is not found.")
            return
        }
        let window:UIWindow = UIApplication.sharedApplication().delegate!.window!!
        
        initViews()
        
        window.addSubview(self.view)
    }
    
    func disappear() {
        self.view.removeFromSuperview()
    }
}


