//
//  QNBaseTabViewController.m
//  QooccNews
//
//  Created by GuJinyou on 14-9-4.
//  Copyright (c) 2014年 . All rights reserved.
//

#import "QNBaseTableViewController.h"

@interface QNBaseTableViewController () <MJRefreshBaseViewDelegate>{
    UIEdgeInsets _edgeInsets;
}

// 上拉
@property (nonatomic, strong) MJRefreshHeaderView *header;
// 下拉
@property (nonatomic, strong) MJRefreshFooterView *footer;

@property (nonatomic, assign) UITableViewStyle tableViewStyle;
@end

@implementation QNBaseTableViewController

- (instancetype)initWithStyle:(UITableViewStyle)style{
    self = [super init];
    if (self) {
        self.tableViewStyle = style;
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.tableViewStyle = UITableViewStylePlain;
        self.clearsSelectionOnViewWillAppear = YES;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self loadTableView];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (self.clearsSelectionOnViewWillAppear) {
        [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
    }
}

-(void)viewDidLayoutSubviews {
    if ([self respondsToSelector:@selector(topLayoutGuide)]) {
        UIEdgeInsets currentInsets = self.tableView.contentInset;
        _edgeInsets = (UIEdgeInsets){
            .top = self.topLayoutGuide.length,
            .bottom = self.bottomLayoutGuide.length,
            .left = currentInsets.left,
            .right = currentInsets.right
        };
        self.tableView.contentInset = _edgeInsets;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark private function

- (void)loadTableView{
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:self.tableViewStyle];
    self.tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleRightMargin;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.tableView];
}

#pragma mark public function
/**
 * 该方法会移除前一次的下拉view
 */
- (void)addHeaderView{
    [self removeHeaderView];
    _header = [MJRefreshHeaderView header];
    _header.delegate = self;
    _header.scrollView = self.tableView;
}

/**
 * 移除下拉View
 */
- (void)removeHeaderView{
    if (_header) {
        [_header removeFromSuperview];
        _header.scrollView = nil;
        _header.delegate = nil;
        _header = nil;
        self.tableView.contentInset = _edgeInsets;
    }
}

/**
 * 添加上拉View   上拉View会监听tableview contentsize 自适应位置
 */
- (void)addFooterView{
    [self removeFooterView];
    _footer = [MJRefreshFooterView footer];
    _footer.scrollView = self.tableView;
    _footer.delegate = self;
}

/**
 * 移除上拉View
 */
- (void)removeFooterView{
    if (_footer) {
        [_footer removeFromSuperview];
        _footer.scrollView = nil;
        _footer = nil;
        self.tableView.contentInset = _edgeInsets;
    }
}

/**
 * 下拉完成后需要调用此方法恢复
 */
- (void)didFinishRefreshHeader{
    [self.header endRefreshing];
}

/**
 *  上拉完成后需要调用此方法恢复
 */
- (void)didFinishRefreshFooter{
    [self.footer endRefreshing];
}

/**
 *  模拟下拉
 */
- (void)simulateDragging{
    [self.header beginRefreshing];
}

#pragma mark - QNBaseTableViewControllerDelegate
/**
 *  下拉回调
 *
 *  @param viewController
 *  @param header
 */
- (void)qnBaseTableViewController:(QNBaseTableViewController *)viewController didTriggerForHeader:(MJRefreshHeaderView *)header{
    
}

/**
 *  上拉回调
 *
 *  @param viewController
 *  @param footer
 */
- (void)qnBaseTableViewController:(QNBaseTableViewController *)viewController didTriggerForFooter:(MJRefreshFooterView *)footer{
    
}

#pragma mark - UItableview DateSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    return nil;
}

#pragma mark - MJRefreshBaseViewDelegate
// 开始进入刷新状态就会调用
- (void)refreshViewBeginRefreshing:(MJRefreshBaseView *)refreshView{
    
}
// 刷新完毕就会调用
- (void)refreshViewEndRefreshing:(MJRefreshBaseView *)refreshView{
    
}
// 刷新状态变更就会调用
- (void)refreshView:(MJRefreshBaseView *)refreshView stateChange:(MJRefreshState)state{
    
}


@end
