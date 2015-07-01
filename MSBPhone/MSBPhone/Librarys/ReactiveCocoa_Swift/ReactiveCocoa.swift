//
//  ReactiveCocoa.swift
//  QooccHealth
//
//  Created by LiuYu on 15/6/10.
//  Copyright (c) 2015年 Liuyu. All rights reserved.
//

import Foundation

/**
*  @author leiganzheng, 15-06-1
*
*  为方便ReativeCocoa框架在Swift中的支持，增加此文件
*  翻译一些Object-C中的宏定义，供Swift使用
*/

public struct RAC {
    var target : NSObject!
    var keyPath : String!
    var nilValue : AnyObject!
    
    init(_ target: NSObject!, _ keyPath: String, nilValue: AnyObject? = nil) {
        self.target = target
        self.keyPath = keyPath
        self.nilValue = nilValue
    }
    
    func assignSignal(signal : RACSignal) {
        signal.setKeyPath(self.keyPath, onObject: self.target, nilValue: self.nilValue)
    }
}

public func RACObserve(target: NSObject!, keyPath: NSString) -> RACSignal {
    return target.rac_valuesForKeyPath(keyPath as String, observer: target)
}

public func <= (rac: RAC, signal: RACSignal) {
    rac.assignSignal(signal)
}

public func >= (signal: RACSignal, rac: RAC) {
    rac.assignSignal(signal)
}

