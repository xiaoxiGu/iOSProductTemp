//
//  QNBaseTabViewController.h
//  QooccNews
//
//  Created by GuJinyou on 14-9-4.
//  Copyright (c) 2014年 . All rights reserved.
//

#import "MJRefreshHeaderView.h"
#import "MJRefreshFooterView.h"

@class QNBaseTableViewController;

@protocol QNBaseTableViewControllerDelegate <NSObject>
/**
 *  下拉回调
 *
 *  @param viewController
 *  @param header
 */
- (void)qnBaseTableViewController:(QNBaseTableViewController *)viewController didTriggerForHeader:(MJRefreshHeaderView *)header;
/**
 *  上拉回调
 *
 *  @param viewController
 *  @param footer
 */
- (void)qnBaseTableViewController:(QNBaseTableViewController *)viewController didTriggerForFooter:(MJRefreshFooterView *)footer;

@end


/**
 *  TableViewController基类  集成上拉下拉
 */
@interface QNBaseTableViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, QNBaseTableViewControllerDelegate>
/**
 *  初始方法
 *
 *  @param style tableview 样式
 *
 *  @return
 */
- (instancetype)initWithStyle:(UITableViewStyle)style;

//tableView
@property(nonatomic, strong) UITableView *tableView;
/**
 *  是否每次进入时清空selection 状态
 */
@property(nonatomic) BOOL clearsSelectionOnViewWillAppear;

/**
 * 该方法会移除前一次的下拉view
 */
- (void)addHeaderView;

/**
 * 移除下拉View
 */
- (void)removeHeaderView;

/**
 *添加上拉View   上拉View会监听tableview contentsize 自适应位置
 */
- (void)addFooterView;

/**
 * 移除上拉View
 */
- (void)removeFooterView;

/**
 * 下拉完成后需要调用此方法恢复
 */
- (void)didFinishRefreshHeader;

/**
 *  上拉完成后需要调用此方法恢复
 */
- (void)didFinishRefreshFooter;

/**
 *  模拟下拉
 */
- (void)simulateDragging;

//- (void)stopScrolling;
@end
