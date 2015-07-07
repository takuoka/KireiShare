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

class KireiShareView : UIView {

    private let backgroundSheet = UIView()
    private let text:String!
    private let url:String!
    private let image:UIImage?
    private var buttons:[UIButton] = []
    private let defaultFont = UIFont(name: "HiraKakuProN-W6", size: 13)!

    private var maxSize:CGRect!
    private let buttonHeight:CGFloat = 60// TODO: あとで可変になるかも
    private let cancelButtonHeight:CGFloat = 50// TODO: あとで可変になるかも
    private let borderColor = UIColor(red: 246/255, green: 246/255, blue: 246/255, alpha: 1)
    private let cancelButtonColor = UIColor(red: 0.972549, green: 0.972549, blue: 0.972549, alpha: 1)
    private let cancelButtonTextColor = UIColor(red: 184/255, green: 184/255, blue: 184/255, alpha: 1)
    private let iconMarginLeft:CGFloat = 9
    
    init(text:String, url:String, image:UIImage?) {
        self.text = text
        self.url = url
        self.image = image
        super.init(frame: UIScreen.mainScreen().bounds)
    }
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    func initViews() {
        println("initViews")
        maxSize = UIScreen.mainScreen().bounds// TODO: 回転で変える
        
        backgroundSheet.frame = maxSize
        backgroundSheet.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.2)
        self.addSubview(backgroundSheet)
        
        addButton(
            text: "キャンセル",
            icon: nil,
            height: cancelButtonHeight,
            bgColor: cancelButtonColor,
            textColor: cancelButtonTextColor,
            borderColor: nil
        )
        
        addButton(text:"その他", icon:nil)
        addButton(text:"Copy Link", icon:nil)
        addButton(text:"Facebook", icon:nil)
        addButton(text:"Twitter", icon:UIImage(named: "twitter"))
    }
    
    
    func addButton(#text:String, icon:UIImage?) {
        addButton(
            text: text,
            icon: icon,
            height: buttonHeight,
            bgColor: UIColor.whiteColor(),
            textColor: UIColor.blackColor(),
            borderColor: borderColor
        )
    }
    func addButton(#text:String, icon:UIImage?, height:CGFloat, bgColor:UIColor, textColor:UIColor, borderColor:UIColor?) {
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
                self.addSubview(border)
                btn.bottom = border.top
            }
        }
        iconView.contentMode = UIViewContentMode.Center
        
        buttons.append(btn)
        btn.addSubview(label)
        btn.addSubview(iconView)
        self.addSubview(btn)
    }
    
    
    
    
    func show() {
        if UIApplication.sharedApplication().delegate == nil{
            println("Window is not found.")
            return
        }
        let window:UIWindow = UIApplication.sharedApplication().delegate!.window!!
        
        initViews()
        
        window.addSubview(self)
    }
    
    func disappear() {
        self.removeFromSuperview()
    }
}
