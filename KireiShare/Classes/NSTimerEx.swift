//
//  NSTimerEx.swift
//  KireiShare
//
//  Created by Takuya Okamoto on 2015/07/07.
//  Copyright (c) 2015年 Uniface. All rights reserved.
//


import Foundation

extension NSTimer {
    /**
    Creates and schedules a one-time `NSTimer` instance.
    
    - parameter delay: The delay before execution.
    - parameter handler: A closure to execute after `delay`.
    
    - returns: The newly-created `NSTimer` instance.
    */
    class func schedule(delay: NSTimeInterval, handler: NSTimer! -> Void) -> NSTimer {
        let fireDate = delay + CFAbsoluteTimeGetCurrent()
        let timer = CFRunLoopTimerCreateWithHandler(kCFAllocatorDefault, fireDate, 0, 0, 0, handler)
        CFRunLoopAddTimer(CFRunLoopGetCurrent(), timer, kCFRunLoopCommonModes)
        return timer
    }
    
    /**
    Creates and schedules a repeating `NSTimer` instance.
    
    - parameter repeatInterval: The interval between each execution of `handler`. Note that individual calls may be delayed; subsequent calls to `handler` will be based on the time the `NSTimer` was created.
    - parameter handler: A closure to execute after `delay`.
    
    - returns: The newly-created `NSTimer` instance.
    */
    class func schedule(repeatInterval interval: NSTimeInterval, handler: NSTimer! -> Void) -> NSTimer {
        let fireDate = interval + CFAbsoluteTimeGetCurrent()
        let timer = CFRunLoopTimerCreateWithHandler(kCFAllocatorDefault, fireDate, interval, 0, 0, handler)
        CFRunLoopAddTimer(CFRunLoopGetCurrent(), timer, kCFRunLoopCommonModes)
        return timer
    }
}


