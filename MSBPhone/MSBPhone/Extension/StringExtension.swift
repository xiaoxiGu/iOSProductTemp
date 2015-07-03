//
//  StringExtension.swift
//  QooccHealth
//
//  Created by 肖小丰 on 15/4/17.
//  Copyright (c) 2015年 Liuyu. All rights reserved.
//

import Foundation

extension String{
    func sizeWithFont(font:UIFont, maxWidth:CGFloat) -> CGSize{
        let attributedString = NSAttributedString(string: self, attributes: [NSFontAttributeName : font])
        let rect = attributedString.boundingRectWithSize(CGSizeMake(maxWidth, CGFloat.max), options: NSStringDrawingOptions.UsesLineFragmentOrigin, context: nil)
        return rect.size
    }
    
    func sizeWithFont(font:UIFont, maxWidth:CGFloat, lines:Int) -> CGSize{
        var size = self.sizeWithFont(font, maxWidth: maxWidth)
        let simple = "a你".sizeWithAttributes([NSFontAttributeName : font])
        size.height = min(simple.height * CGFloat(lines), size.height)
        return size
    }
    //判断手机号码
    func checkStingIsPhone() -> Bool{
        //手机号码
        let  phoneRegex = "^((13[0-9])|(147)|(15[^4,\\D])|(18[0,5-9]))\\d{8}$"
        let phonePred = NSPredicate(format: "SELF MATCHES %@", phoneRegex)
        let phoneIsMatch = phonePred.evaluateWithObject(self)
        //固定电话大陆）
        let  telRegex = "^0\\d{2,3}(\\-)?\\d{7,8}$"
        let telPred = NSPredicate(format: "SELF MATCHES %@", telRegex)
        let telIsMatch = telPred.evaluateWithObject(self)
        
        return phoneIsMatch || telIsMatch
    }
}