//
//  LyActivityView.swift
//  QooccShow
//
//  Created by LiuYu on 14/11/12.
//  Copyright (c) 2014年 Qoocc. All rights reserved.
//

import UIKit

let textLabelLeftSpace:CGFloat = 20.0
let size = CGSizeMake(100, 100)

class LyActivityView : UIView {
    //MARK: 提示文本
    let textLabel: UILabel
    //转动圈
    let activityView:UIActivityIndicatorView
    
    var text: String? {
        get {
            return self.textLabel.text
        }
        set {
            if newValue != nil{
                self.textLabel.text = newValue
                self.textLabel.sizeToFit()
                var center = self.center
                self.bounds = CGRectMake(0, 0, self.textLabel.bounds.width + textLabelLeftSpace*2, size.height)
                self.center = center
                
                self.textLabel.frame = CGRectMake(textLabelLeftSpace, self.textLabel.frame.origin.y, self.textLabel.frame.width, self.textLabel.frame.height)
            }else{
                self.bounds = CGRectMake(0, 0, size.width/2, size.height/2)
                self.activityView.center = CGPointMake(size.width/4, size.height/4)
            }
        }
    }
    
    convenience init() {
        self.init(frame: CGRectMake(0, 0, size.width, size.height))
    }
    
    override init(frame: CGRect) {
        self.textLabel = UILabel(frame: CGRectMake(textLabelLeftSpace, 72, size.width - textLabelLeftSpace*2, 20))
        self.textLabel.textColor = UIColor.whiteColor()
        self.textLabel.font = UIFont.systemFontOfSize(14)
        
        self.activityView = UIActivityIndicatorView(activityIndicatorStyle: .WhiteLarge)
        self.activityView.center = CGPointMake(size.width/2.0, size.height/2.0 - 10)
        self.activityView.autoresizingMask = UIViewAutoresizing.FlexibleLeftMargin | UIViewAutoresizing.FlexibleRightMargin
        self.activityView.startAnimating()

        super.init(frame: frame)

        self.layer.masksToBounds = true
        self.layer.cornerRadius = 3
        self.backgroundColor = UIColor(white:40/255.0, alpha: 0.8)
        
        self.addSubview(self.textLabel)
        self.addSubview(self.activityView)

    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
