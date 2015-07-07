//
//  StartImageView.swift
//  QooccHealth
//
//  Created by 肖小丰 on 15/5/25.
//  Copyright (c) 2015年 Liuyu. All rights reserved.
//

import Foundation

private let skewingWidth = (Screen_Width - 320)/2
private let skewingHeight = (Screen_Height - 568)/2


class StartOneImageView: UIView {
    
    private let sunImageViewSize:CGFloat = 218.0
    private let sunImageViewOrginY:CGFloat = 156.0 + skewingHeight
    private let cloudImageViewSize:CGSize = CGSizeMake(195.0, 133.0)
    private let cloudLineSize:CGSize = CGSizeMake(250.0, 5.0)
    private let serversImage = ["start_healthTravel","start_doctorServer","start_heathCheck","start_sosIcon","start_heathReport","start_healthCathedra"]
    private let serversFrame = [CGRectMake(32 + skewingWidth, 250 + skewingHeight, 40, 40),CGRectMake(152 + skewingWidth, 130 + skewingHeight, 57, 57),CGRectMake(108 + skewingWidth, 195 + skewingHeight, 57, 57),CGRectMake(246 + skewingWidth, 280 + skewingHeight, 40, 40),CGRectMake(47 + skewingWidth, 204 + skewingHeight, 35, 35),CGRectMake(219 + skewingWidth, 190 + skewingHeight, 57, 57)]
    private let blinkViewFrame = [CGRectMake(30 + skewingWidth, 135 + skewingHeight, 15, 20),CGRectMake(260 + skewingWidth, 80 + skewingHeight, 15, 20),CGRectMake(232 + skewingWidth, 190 + skewingHeight, 15, 20),CGRectMake(190 + skewingWidth, 350 + skewingHeight, 25, 25),CGRectMake(10 + skewingWidth, 304 + skewingHeight, 10, 10)]
    private let subServersFrame = [CGRectMake(120 + skewingWidth, 157 + skewingHeight, 15, 15),CGRectMake(216 + skewingWidth, 175 + skewingHeight, 15, 15),CGRectMake(127 + skewingWidth, 282 + skewingHeight, 6, 6),CGRectMake(73 + skewingWidth, 330 + skewingHeight, 15, 15),CGRectMake(220 + skewingWidth, 175 + skewingHeight, 20, 20)]
    
    override init(frame:CGRect){
        super.init(frame: frame)
        self.buildUI()
    }
    
    override func awakeFromNib(){
        super.awakeFromNib()
        self.buildUI()
    }
    
    required init(coder aDecoder: NSCoder) {
        //        fatalError("init(coder:) has not been implemented")
        super.init(coder: aDecoder)
    }
    
    
    //MARK:- Delegate or DataSource
    
    //MARK:- NSNotification Method
    
    //MARK:- Action Method
    
    //MARK:- Private Method
    private func buildUI(){
        
        self.clipsToBounds = true
        
        let sunImageView = UIImageView(frame: CGRectMake(0, 0, 0, 0))
        sunImageView.image = UIImage(named: "start_sunIcon")
        self.addSubview(sunImageView)
        
        let cloudImageView = UIImageView(frame: CGRectMake(-self.cloudImageViewSize.width, self.sunImageViewOrginY + self.sunImageViewSize/3, self.cloudImageViewSize.width, self.cloudImageViewSize.height))
        cloudImageView.image = UIImage(named: "start_cludeIcon")
        self.addSubview(cloudImageView)
        
        let cloudLine = UIImageView(frame: CGRectMake(0, 0, self.cloudLineSize.width, self.cloudLineSize.height))
        cloudLine.image = UIImage(named: "start_lineIcon")
        cloudLine.center = CGPointMake(Screen_Width/2.0, self.sunImageViewOrginY + self.sunImageViewSize - 10)
        cloudLine.alpha = 0
        self.addSubview(cloudLine)
        
        let titileImageView = UIImageView(frame: CGRectMake(0, 65*COEFFICIENT_OF_HEIGHT_ZOOM, Screen_Width, 40))
        titileImageView.contentMode = UIViewContentMode.ScaleAspectFit
        titileImageView.image = UIImage(named: "Login_Logo")
        titileImageView.alpha = 0
        self.addSubview(titileImageView)

        let animationsDuration: NSTimeInterval = 2
        UIView.animateKeyframesWithDuration(animationsDuration, delay: 0, options: UIViewKeyframeAnimationOptions.allZeros, animations: { () -> Void in
            UIView.addKeyframeWithRelativeStartTime(0/animationsDuration, relativeDuration: 0.68/animationsDuration) { () -> Void in
                sunImageView.frame.size = CGSizeMake(self.sunImageViewSize + 20, self.sunImageViewSize + 20)
                sunImageView.center = CGPointMake(Screen_Width/2.0 + 10, self.sunImageViewOrginY + self.sunImageViewSize/2)
                titileImageView.alpha = 1
            }
            UIView.addKeyframeWithRelativeStartTime(0.68/animationsDuration, relativeDuration: 1.32/animationsDuration) { () -> Void in
                sunImageView.frame.size = CGSizeMake(self.sunImageViewSize , self.sunImageViewSize )
            }
            UIView.addKeyframeWithRelativeStartTime(0/animationsDuration, relativeDuration: 1) { () -> Void in
                cloudImageView.center = CGPointMake(Screen_Width/2.0 + 10, self.sunImageViewOrginY + (self.sunImageViewSize * 2)/3 + 5)
            }
            UIView.addKeyframeWithRelativeStartTime(1.32/animationsDuration, relativeDuration: 0.5/animationsDuration) { () -> Void in
                cloudLine.alpha = 1
            }
        }, completion: { (finished) -> Void in
                self.serversShow()
        })
    }
    
    //相关服务显示
    private var serversIndex = 0
    private var serversItem = [UIImageView]()
    private func serversShow(){
        for i in 0...self.serversImage.count - 1{
            let serverItem = UIImageView(frame: self.serversFrame[i])
            serverItem.image = UIImage(named: self.serversImage[i])
            serverItem.alpha = 0
            serverItem.transform = CGAffineTransformMakeScale(0, 0)
            self.addSubview(serverItem)
            self.serversItem.append(serverItem)
        }
        self.serversAnimation()
    }
    func serversAnimation(){
        let serverOneItem = self.serversItem[self.serversIndex]
        let serverTwoItem = self.serversItem[self.serversIndex + 1]
        let animationsDuration: NSTimeInterval = 1
        UIView.animateKeyframesWithDuration(animationsDuration, delay: 0, options: UIViewKeyframeAnimationOptions.allZeros, animations: { () -> Void in
            //放大
            UIView.addKeyframeWithRelativeStartTime(0, relativeDuration: 0.48/animationsDuration, animations: { () -> Void in
                serverOneItem.transform = CGAffineTransformMakeScale(1.5, 1.5)
                serverOneItem.alpha = 1
                serverTwoItem.transform = CGAffineTransformMakeScale(1.5, 1.5)
                serverTwoItem.alpha = 1
            })
            //还原
            UIView.addKeyframeWithRelativeStartTime(0.48/animationsDuration, relativeDuration: 0.52/animationsDuration, animations: { () -> Void in
                serverOneItem.transform = CGAffineTransformMakeScale(1, 1)
                serverTwoItem.transform = CGAffineTransformMakeScale(1, 1)
            })
            }) { (end) -> Void in
                self.serversIndex += 2
                if self.serversIndex != self.serversImage.count{
                    //重复动画
                    self.serversAnimation()
                }else{
                    //出现星星动画
                    self.subTitleAnimation()
                }
        }
    }
    private func subTitleAnimation(){
        let subTitle = UIImageView(frame: CGRectMake(0, 405*COEFFICIENT_OF_HEIGHT_ZOOM + 50, Screen_Width, 50))
        subTitle.contentMode = UIViewContentMode.ScaleAspectFit
        subTitle.image = UIImage(named: "start_oneSubtitle")
        subTitle.alpha = 0
        self.addSubview(subTitle)
        
        for i in 0...self.subServersFrame.count - 1{
            let subServer = UIView(frame: self.subServersFrame[i])
            subServer.layer.cornerRadius = self.subServersFrame[i].width/2
            subServer.backgroundColor = UIColor.whiteColor()
            subServer.layer.masksToBounds = true
            subServer.layer.borderWidth = 1
            subServer.layer.borderColor = appThemeColor.CGColor
            subServer.transform = CGAffineTransformMakeScale(0, 0)
            self.addSubview(subServer)
            UIView.animateWithDuration(0.68, animations: { () -> Void in
                subServer.transform = CGAffineTransformMakeScale(1, 1)
            })
        }

        UIView.animateWithDuration(0.68, animations: { () -> Void in
            subTitle.frame = CGRectMake(0, 405*COEFFICIENT_OF_HEIGHT_ZOOM, Screen_Width, 50)
            subTitle.alpha = 1
        })
        //闪烁的星星
        self.addBlinkImageView(self.blinkViewFrame, blinkImage: "start_blink")
        //散落的星星
//        self.addFallImageView("start_blink")
    }
}

class StartTwoImageView: UIView {
    
    private let twoImageViewSize:CGFloat = 218.0
    private let twoImageViewOrginY:CGFloat = 146.0 + skewingHeight

    private var twoImageView:UIImageView!
    private var startAnimation:Bool = true

    override init(frame:CGRect){
        super.init(frame: frame)
        self.buildUI()
    }
    
    override func awakeFromNib(){
        super.awakeFromNib()
        self.buildUI()
    }
    
    required init(coder aDecoder: NSCoder) {
        //        fatalError("init(coder:) has not been implemented")
        super.init(coder: aDecoder)
    }
    
    //MARK:- Delegate or DataSource
    
    //MARK:- NSNotification Method
    
    //MARK:- Action Method
    
    //MARK:- Private Method
    private func buildUI(){
        self.clipsToBounds = true
        let titileImageView = UIImageView(frame: CGRectMake(0, 65*COEFFICIENT_OF_HEIGHT_ZOOM, Screen_Width, 40))
        titileImageView.contentMode = UIViewContentMode.ScaleAspectFit
        titileImageView.image = UIImage(named: "start_twoTitle")
        self.addSubview(titileImageView)

        self.twoImageView = UIImageView(frame: CGRectMake(0,self.twoImageViewOrginY , 0, 0))
        self.twoImageView.image = UIImage(named: "start_twoImage")
        self.addSubview(self.twoImageView)
        
        let subTitle = UIImageView(frame: CGRectMake(0, 405*COEFFICIENT_OF_HEIGHT_ZOOM, Screen_Width, 50))
        subTitle.contentMode = UIViewContentMode.ScaleAspectFit
        subTitle.image = UIImage(named: "start_twoSubtitle")
        self.addSubview(subTitle)
        
    }
    //
    func startTwoImageAnimation(){
        if self.startAnimation{
            self.startAnimation = false
            UIView.animateWithDuration(1.2, animations: { () -> Void in
                self.twoImageView.frame.size = CGSizeMake(self.twoImageViewSize, self.twoImageViewSize)
                self.twoImageView.center = CGPointMake(Screen_Width/2, self.twoImageViewOrginY + self.twoImageViewSize/2)
                }) { (end) -> Void in
            }
            self.addFallImageView("start_goldIcon")
        }
    }
}
class StartThreeImageView: UIView {
    
    private let threeImageViewSize:CGFloat = 218.0
    private let threeImageViewOrginY:CGFloat = 146.0 + skewingHeight
    
    private var threeImageView:UIImageView!
    
    private var bloodImageView:UIImageView!
    private var bloodLabel:UIImageView!
    private var pedometerImageView:UIImageView!
    private var moreImageView:UIImageView!

    
    private let blinkViewFrame = [CGRectMake(30 + skewingWidth, 135 + skewingHeight, 15, 20),CGRectMake(260 + skewingWidth, 80 + skewingHeight, 15, 20),CGRectMake(232 + skewingWidth, 190 + skewingHeight, 15, 20),CGRectMake(190 + skewingWidth, 380 + skewingHeight, 25, 25),CGRectMake(10 + skewingWidth, 304 + skewingHeight, 10, 10),CGRectMake(30 + skewingWidth, 50 + skewingHeight, 15, 20)]
    
     private let subImageViewFrame = [CGRectMake(22, 56, 35, 13),CGRectMake(78, 30, 35, 20),CGRectMake(136, -5, 35, 20)]
     private let subImageArray = ["start_blood","start_pedometer","start_more"]
     private let subLabelFrame = [CGRectMake(33, 65, 20, 80),CGRectMake(88, 40, 20, 80),CGRectMake(148, 15, 20, 100)]
     private let subLabelArray = ["血压三次","计步器","其他测试两次"]
     private var subViewIndex = 0
     private var startAnimation:Bool = true

    override init(frame:CGRect){
        super.init(frame: frame)
        self.buildUI()
    }
    
    override func awakeFromNib(){
        super.awakeFromNib()
        self.buildUI()
    }
    
    required init(coder aDecoder: NSCoder) {
        //        fatalError("init(coder:) has not been implemented")
        super.init(coder: aDecoder)
    }
    
    //MARK:- Delegate or DataSource
    
    //MARK:- NSNotification Method
    
    //MARK:- Action Method
    
    //MARK:- Private Method
    private func buildUI(){
        self.clipsToBounds = true
        let titileImageView = UIImageView(frame: CGRectMake(0, 65*COEFFICIENT_OF_HEIGHT_ZOOM, Screen_Width, 40))
        titileImageView.contentMode = UIViewContentMode.ScaleAspectFit
        titileImageView.image = UIImage(named: "start_threeTitle")
        self.addSubview(titileImageView)
        
        self.threeImageView = UIImageView(frame: CGRectMake(-self.threeImageViewSize,self.threeImageViewOrginY , self.threeImageViewSize, self.threeImageViewSize))
        self.threeImageView.center = CGPointMake(Screen_Width/2, self.threeImageViewOrginY + self.threeImageViewSize/2)
        self.threeImageView.image = UIImage(named: "start_threeImage")
        self.threeImageView.transform = CGAffineTransformMakeScale(0, 0)
        self.addSubview(self.threeImageView)
        
        
        
        let subTitle = UIImageView(frame: CGRectMake(0, 405*COEFFICIENT_OF_HEIGHT_ZOOM, Screen_Width, 50))
        subTitle.contentMode = UIViewContentMode.ScaleAspectFit
        subTitle.image = UIImage(named: "start_threeSubTitle")
        self.addSubview(subTitle)
    }
    //
    func startThreeImageAnimation(){
        if self.startAnimation {
            self.startAnimation = false
            UIView.animateWithDuration(1.2, animations: { () -> Void in
                self.threeImageView.transform = CGAffineTransformMakeScale(1, 1)
                }) { (end) -> Void in
                    self.subViewAnimation()
            }
        }
    }
    private func subViewAnimation(){
        let subImage = UIImageView(frame: self.subImageViewFrame[self.subViewIndex])
        subImage.contentMode = UIViewContentMode.ScaleAspectFit
        subImage.image = UIImage(named: self.subImageArray[self.subViewIndex])
        subImage.transform = CGAffineTransformMakeScale(0, 0)
        self.threeImageView.addSubview(subImage)
        
        let subLabel = UILabel(frame: self.subLabelFrame[self.subViewIndex])
        subLabel.textColor = UIColor.whiteColor()
        subLabel.numberOfLines = 0
        subLabel.font = UIFont.systemFontOfSize(12)
        subLabel.alpha = 0
        subLabel.text = self.subLabelArray[self.subViewIndex]
        self.threeImageView.addSubview(subLabel)
        
        UIView.animateWithDuration(0.68, animations: { () -> Void in
            subImage.transform = CGAffineTransformMakeScale(1, 1)
            subLabel.alpha = 1
            }) { (end) -> Void in
                self.subViewIndex++
                if self.subViewIndex != self.subLabelFrame.count{
                    self.subViewAnimation()
                }else{
                    self.addBlinkImageView(self.blinkViewFrame, blinkImage: "icon_star_yellow")
                }
        }
    }
}