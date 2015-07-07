//
//  StartPagesViewController.swift
//  QooccHealth
//
//  Created by LiuYu on 15/4/13.
//  Copyright (c) 2015年 Liuyu. All rights reserved.
//

import UIKit

/**
*  @author LiuYu, 15-04-13
*
*  启动过度页
*/
class StartPagesWindow: UIWindow, UIScrollViewDelegate {
    
    var finished: (() -> Void)? // 完成的回掉
    var strongSelf: StartPagesWindow?
    
    private(set) var  pictureScrollView:UIScrollView?
    private(set) var  pageContrlolerView:UIPageControl?
    private(set) var  advertisementCurrent:NSInteger = 0
    
    private(set) var  enterButton:UIButton?

    private let  oneColor = UIColor(red: 24.0/255.0, green: 163.0/255.0, blue: 1, alpha: 1)
    private let  twoColor = UIColor(red: 255.0/255.0, green: 170.0/255.0, blue: 0, alpha: 1)
    private let  threeColor = UIColor(red: 3.0/255.0, green: 157.0/255.0, blue: 86.0/255.0, alpha: 1)

    private(set) var oneImageView:StartOneImageView!
    private(set) var twoImageView:StartTwoImageView!
    private(set) var threeImageView:StartThreeImageView!

    

    convenience init() {
        self.init(frame: UIScreen.mainScreen().bounds)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.windowLevel = UIWindowLevelAlert + 1
        self.hidden = false
        
        self.buildDataAndUI()
        //TEMP 测试跳转 {
        self.enterButton = UIButton(frame: CGRectMake(self.bounds.size.width/2 - 100, self.bounds.size.height - 84, 200, 44))
        self.enterButton!.setTitle("立即体验", forState: .Normal)
        self.enterButton?.setTitleColor(oneColor, forState: UIControlState.Normal)
        self.enterButton?.layer.masksToBounds = true
        self.enterButton?.layer.cornerRadius = 3
        self.enterButton?.layer.borderWidth = 1
        self.enterButton?.layer.borderColor = oneColor.CGColor
        self.enterButton!.backgroundColor = UIColor.whiteColor()
        self.enterButton!.addTarget(self, action: "enter", forControlEvents: .TouchUpInside)
        self.addSubview(self.enterButton!)
        
        self.strongSelf = self
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
       //MARK:- Delegate or DataSource
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        self.advertisementCurrent = NSInteger(scrollView.contentOffset.x / scrollView.bounds.size.width)
        switch self.advertisementCurrent {
        case 0:
            self.enterButton?.layer.borderColor = oneColor.CGColor
            self.enterButton?.setTitleColor(oneColor, forState: UIControlState.Normal)
            self.pageContrlolerView!.currentPageIndicatorTintColor = oneColor
        case 1:
            self.enterButton?.layer.borderColor = twoColor.CGColor
            self.enterButton?.setTitleColor(twoColor, forState: UIControlState.Normal)
            self.pageContrlolerView!.currentPageIndicatorTintColor = twoColor
            self.twoImageView.startTwoImageAnimation()
        case 2:
            self.enterButton?.layer.borderColor = threeColor.CGColor
            self.enterButton?.setTitleColor(threeColor, forState: UIControlState.Normal)
            self.pageContrlolerView!.currentPageIndicatorTintColor = threeColor
            self.threeImageView.startThreeImageAnimation()
        default:
            break
        }
        self.pageContrlolerView?.currentPage = self.advertisementCurrent
    }
    
    //MARK: 登录
    func enter() {
        UIView.animateWithDuration(0.5, animations: { () -> Void in
            self.transform = CGAffineTransformMakeScale(3.0, 3.0)
            self.alpha = 0
            }, completion: { (finished) -> Void in
                self.finished?()
                self.finished = nil
                self.strongSelf = nil
        })
    }
    
    //MARK:
    private func buildDataAndUI(){
        //数据
        
        //UIScrollView
        self.pictureScrollView = UIScrollView(frame: self.bounds)
        self.pictureScrollView!.bounces = false
        self.pictureScrollView!.pagingEnabled = true
        self.pictureScrollView!.delegate = self
        self.pictureScrollView!.showsVerticalScrollIndicator = false
        self.pictureScrollView!.showsHorizontalScrollIndicator = false
        self.pictureScrollView!.userInteractionEnabled = true
        self.addSubview(self.pictureScrollView!)
        self.pictureScrollView?.backgroundColor = UIColor.whiteColor()
        self.pictureScrollView?.contentSize = CGSizeMake(self.bounds.size.width * 3, 0)
        
        var  i:NSInteger = 1
        for  i in 0...3 {
            if i == 1 {
                self.oneImageView = StartOneImageView(frame: CGRectMake(self.bounds.size.width * CGFloat(i-1), 0, self.bounds.size.width, self.bounds.size.height))
                self.pictureScrollView?.addSubview(oneImageView)
            }else{
                if i == 2{
                    self.twoImageView = StartTwoImageView(frame: CGRectMake(self.bounds.size.width * CGFloat(i-1), 0, self.bounds.size.width, self.bounds.size.height))
                    self.pictureScrollView?.addSubview(self.twoImageView)
                }
                if i == 3{
                    //闪烁的星星
                    self.threeImageView = StartThreeImageView(frame: CGRectMake(self.bounds.size.width * CGFloat(i-1), 0, self.bounds.size.width, self.bounds.size.height))
                    self.pictureScrollView?.addSubview(self.threeImageView)
                }
            }
        }
        
        //UIPageControl
        self.pageContrlolerView = UIPageControl(frame: CGRectMake(0, self.bounds.size.height - 40, self.bounds.size.width, 40))
        self.pageContrlolerView!.numberOfPages = 3
        self.pageContrlolerView!.currentPage = 0
        self.pageContrlolerView!.pageIndicatorTintColor = UIColor.grayColor()
        self.pageContrlolerView!.currentPageIndicatorTintColor = oneColor
        self.addSubview(self.pageContrlolerView!)
    }
}
