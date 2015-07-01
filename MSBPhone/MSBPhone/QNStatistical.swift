//
//  QNStatistical.swift
//  QooccHealth
//
//  Created by LiuYu on 15/6/11.
//  Copyright (c) 2015年 Liuyu. All rights reserved.
//

import Foundation

/*
    所有要统计的行为统计，目前的行为只统计次数，没有时长的统计
*/
enum QNStatisticalName: String {
    case JBQ = "QN_XT_9_JBQ"            // 9项体征的按钮_计步器
    case HXL = "QN_XT_9_HXL"            // 9项体征的按钮_呼吸率
    case XT = "QN_XT_9_XT"              // 9项体征的按钮_血糖
    case ML = "QN_XT_9_ML"              // 9项体征的按钮_脉率
    case XY = "QN_XT_9_XY"              // 9项体征的按钮_血压
    case XD = "QN_XT_9_XD"              // 9项体征的按钮_心电
    case TW = "QN_XT_9_TW"              // 9项体征的按钮_体温
    case XYang = "QN_XT_9_XYang"        // 9项体征的按钮_血氧
    case NJ = "QN_XT_9_NJ"              // 9项体征的按钮_尿检
    
    case YM_HXL = "QN_XT_9_YM_HXL"      // 9项体征详情页_呼吸率
    case YM_JBQ = "QN_XT_9_YM_JBQ"      // 9项体征详情页_计步器
    case YM_ML = "QN_XT_9_YM_ML"        // 9项体征详情页_脉率
    case YM_NJ = "QN_XT_9_YM_NJ"        // 项体征详情页_尿检
    case YM_TW = "QN_XT_9_YM_TW"        // 9项体征详情页_体温
    case YM_XD = "QN_XT_9_YM_XD"        // 9项体征详情页_心电
    case YM_XT = "QN_XT_9_YM_XT"        // 9项体征详情页_血糖
    case YM_XY = "QN_XT_9_YM_XY"        // 9项体征详情页_血压
    case YM_XYang = "QN_XT_9_YM_XYang"  // 9项体征详情页_血氧
    
    case EWMSMDL = "QN_XT_EWMSMDL"      // 二维码扫描登录
    
    case BDDHAN = "QN_XT_BDDHAN"        // 拨打电话按钮
    
    case JYTX = "QN_XT_JYTX"            // 建议提醒
    case GPS = "QN_XT_GPS"              // GPS
    
    case RLAN = "QN_XT_RLAN"            // 日历按钮
    
    case FXAN = "QN_XT_FXAN"            // 分享按钮
    
    case YE = "QN_XT_YE"                // 余额
    case SCAN = "QN_XT_SCAN"            // 商城按钮
    case WDXX = "QN_XT_WDXX"            // 我的消息界面
    
    case SZSOSHM = "QN_XT_SZSOSHM"      // 设置sos号码
    case TJSOSHM = "QN_XT_TJSOSHM"      // 提交sos号码
    
    case TX = "QN_XT_TX"                // 头像
    case NC = "QN_XT_NC"                // 昵称
    
    case ZZTX = "QN_XT_ZZTX"            // 转账（提现）
    
    case JTXX = "QN_XT_JTXX"            // 家庭消息
    case JCTX = "QN_XT_JCTX"            // 检测提醒
    case XTTZ = "QN_XT_XTTZ"            // 系统通知
}

/**
*  @author LiuYu, 15-06-11
*
*  所有的统计功能
*/
class QNStatistical {
    class func statistical(name: QNStatisticalName) {
        MobClick.event(name.rawValue)
    }
}




