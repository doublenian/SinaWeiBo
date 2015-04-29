//
//  WBHomeViewController.m
//  WeiBo
//
//  Created by Doublenian on 15/3/21.
//  Copyright (c) 2015年 com.doublenian. All rights reserved.
//

#import "WBHomeViewController.h"
#import "UIImage+Extension.h"
#import "UIBarButtonItem+Extension.h"
#import "WBTitleButton.h"
#import "WBAccountTool.h"
#import "UIImageView+WebCache.h"
#import "WBStatus.h"
#import "NSObject+MJKeyValue.h"
#import "WBStatusCell.h"
#import "WBStatusFrame.h"
#import "WBStatus.h"
#import "WBUser.h"
#import "MJRefresh.h"
#import "WBHttpTool.h"
#import "HWDropdownMenu.h"
#import "HWTitleMenuViewController.h"

@interface WBHomeViewController ()<MJRefreshBaseViewDelegate,HWDropdownMenuDelegate>

@property (nonatomic, weak)WBTitleButton *titleButton;

@property (nonatomic, strong)NSMutableArray *statusFrames;

@property (nonatomic, weak)MJRefreshHeaderView *header;

@property (nonatomic, weak)MJRefreshFooterView *footer;

@end

@implementation WBHomeViewController

- (NSMutableArray *)statusFrames
{
    if (_statusFrames == nil) {
        _statusFrames = [NSMutableArray array];
    }
    return _statusFrames;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // 设置tableView的背景色
    self.tableView.backgroundColor = WBColor(226, 226, 226);
    
    // 让整个tableView的上面和下面留出一些间距
    self.tableView.contentInset = UIEdgeInsetsMake(WBStatusTableBorder, 0, WBStatusTableBorder, 0);
    
    // 去掉cell之间的分割线
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    
    
    // 集成刷新控件
    [self setupRefreshView];
    // 设置导航条的内容
    [self setupNavBar];
    // 获取用户信息
    [self setupUserData];
}

/**
 *  获取用户信息
 */
- (void)setupUserData
{
    
    // 1.封装请求参数
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"access_token"] = [WBAccountTool getAccount].access_token;
    params[@"uid"] = @([WBAccountTool getAccount].uid);
    
    WBLog (@"the access_token is %@",params[@"access_token"]);
    
    
    
    
    /*
     the access_token :2.00C8wUADO52vcB9ad41a5614wp5fFE
     the uid :2755772964

     */
    
    WBLog(@"the access_token :%@\n the uid :%@",params[@"access_token"],params[@"uid"]);
    
    // 2.发送请求
    [WBHttpTool getWithURL:@"https://api.weibo.com/2/users/show.json" params:params success:^(id json) {
        
        WBLog(@"the return json is %@",json);
        
         //字典转模型
         WBUser *user = [WBUser objectWithKeyValues:json];
         // 设置标题文字
         [self.titleButton setTitle:user.name forState:UIControlStateNormal];
         // 保存昵称
         WBAccount *account = [WBAccountTool getAccount];
         account.name = user.name;
         [WBAccountTool saveAccount:account];
        
    } failure:^(NSError *error) {
        
        WBLog(@"Error %@",error);
        
        //
    }];
    
}



/**
 *  集成刷新控件
 */
- (void)setupRefreshView
{
    // 1.下拉刷新
    MJRefreshHeaderView *header = [MJRefreshHeaderView header];
    header.scrollView = self.tableView;
    header.delegate = self;
    
    // 自动进入刷新状态
    [header beginRefreshing];
    self.header = header;
    
    // 2.上拉刷新(上拉加载更多数据)
    MJRefreshFooterView *footer = [MJRefreshFooterView footer];
    footer.scrollView = self.tableView;
    footer.delegate = self;
    self.footer = footer;
}

- (void)dealloc
{
    // 释放内存
    [self.header free];
    [self.footer free];
}

/**
 *  刷新控件进入开始刷新状态的时候调用
 */
- (void)refreshViewBeginRefreshing:(MJRefreshBaseView *)refreshView
{
    if ([refreshView isKindOfClass:[MJRefreshFooterView class]]) { // 上拉加载更多
        [self loadMoreData];
    } else { // 下拉刷新
        [self loadNewData];
    }
}

/**
 *  上拉加载更多
 */
- (void)loadMoreData{
    
    // 1.封装请求参数
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"access_token"] = [WBAccountTool getAccount].access_token;
    params[@"count"] = @10;
    if (self.statusFrames.count) {
        WBStatusFrame *statusFrame = [self.statusFrames lastObject];
        
        long long maxId = [statusFrame.status.idstr longLongValue] - 1;
        
        // 加载ID 小于或者等于 maxId 的微博
        params[@"max_id"] = @(maxId);
    }
    
    // 2.发送请求
    [WBHttpTool getWithURL:@"https://api.weibo.com/2/statuses/home_timeline.json" params:params success:^(id json) {
       
        // 直接将字典数组转为模型数组(并且只需要在WBStatus的.h文件中声明属性就行，.m文件无需写任何代码)
        NSArray *statusArray = [WBStatus objectArrayWithKeyValuesArray:json[@"statuses"]];
        
        // 创建frame模型对象
        NSMutableArray *statusFrameArray = [NSMutableArray array];
        for (WBStatus *status in statusArray) {
            
            WBStatusFrame *statusFrame = [[WBStatusFrame alloc] init];
            
            // 传递微博模型数据
            statusFrame.status = status;
            
            [statusFrameArray addObject:statusFrame];
        }
        
        // 添加新数据到旧数据的后面
        [self.statusFrames addObjectsFromArray:statusFrameArray];
        
        // 刷新表格
        [self.tableView reloadData];
        
        // 让刷新控件停止显示刷新状态
        [self.footer endRefreshing];
    } failure:^(NSError *error) {
        
        // 让刷新控件停止显示刷新状态
        [self.footer endRefreshing];
    }];
    
}

/**
 *  下拉刷新
 */
- (void)loadNewData
{
    
    // 1.封装请求参数
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"access_token"] = [WBAccountTool getAccount].access_token;
    params[@"count"] = @10;
    if (self.statusFrames.count) {
        WBStatusFrame *statusFrame = self.statusFrames[0];
        // 加载ID比since_id大的微博
        params[@"since_id"] = statusFrame.status.idstr;
    }
    
    // 2.发送请求
    
    [WBHttpTool getWithURL:@"https://api.weibo.com/2/statuses/home_timeline.json" params:params success:^(id json) {
        
        // 获取所有的微博数据
        //         NSArray *statusArray = responseObject[@"statuses"];
        
        // 这里使用的是李明杰老师自己弄的一个非常霸道的框架
        // 直接将字典数组转为模型数组(并且只需要在WBStatus的.h文件中声明属性就行，.m文件无需写任何代码)
        NSArray *statusArray = [WBStatus objectArrayWithKeyValuesArray:json[@"statuses"]];
        
        // 创建frame模型对象
        NSMutableArray *statusFrameArray = [NSMutableArray array];
        for (WBStatus *status in statusArray) {
            
            WBStatusFrame *statusFrame = [[WBStatusFrame alloc] init];
            
            // 传递微博模型数据
            statusFrame.status = status;
            
            [statusFrameArray addObject:statusFrame];
        }
        
        // 将最新的数据追加到旧数据的最前面
        // 旧数据: self.statusFrames
        // 新数据: statusFrameArray
        NSMutableArray *tempArray = [NSMutableArray array];
        // 添加statusFrameArray的所有元素 添加到 tempArray中
        [tempArray addObjectsFromArray:statusFrameArray];
        // 添加self.statusFrames的所有元素 添加到 tempArray中
        [tempArray addObjectsFromArray:self.statusFrames];
        // 赋值
        self.statusFrames = tempArray;
        
        // 刷新表格
        [self.tableView reloadData];
        
        // 让刷新控件停止显示刷新状态
        [self.header endRefreshing];
        
        // 提示用户新增了几条微博
        [self showNewStatusCount:statusFrameArray.count];
    } failure:^(NSError *error) {
        
        // 让刷新控件停止显示刷新状态
        [self.header endRefreshing];
    }];
    
}

- (void)showNewStatusCount:(int)count{

    UIButton *button = [[UIButton alloc] init];
    
    // 让button隐藏在导航控制器的导航栏下面
    [self.navigationController.view insertSubview:button belowSubview:self.navigationController.navigationBar];
    
    // 设置button不可点击
    button.userInteractionEnabled = NO;
    
    // 设置button的图片和文字颜色、字体
    [button setBackgroundImage:[UIImage resizedImageWithName:@"timeline_new_status_background"] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:14];
    
    // 设置button要显示的文字
    if (count) {
        NSString *title = [NSString stringWithFormat:@"共有%d条新的微博", count];
        [button setTitle:title forState:UIControlStateNormal];
    } else {
        [button setTitle:@"没有新的微博数据" forState:UIControlStateNormal];
    }
    
    CGFloat buttonH = 30;
    CGFloat buttonY = 64 - buttonH;
    CGFloat buttonX = 0;
    CGFloat buttonW = self.view.frame.size.width;
    // 设置button的frame
    button.frame = CGRectMake(buttonX, buttonY, buttonW, buttonH);
    
    // 通过动画显示button
    [UIView animateWithDuration:0.7 animations:^{
        
        button.transform = CGAffineTransformMakeTranslation(0, buttonH);
        
    } completion:^(BOOL finished) {// 显示完毕，1秒后button回到原位置，并移除button
        
        [UIView animateWithDuration:0.7 delay:1.0 options:UIViewAnimationOptionCurveLinear animations:^{
            
            // 还原button
            button.transform = CGAffineTransformIdentity;
            
        } completion:^(BOOL finished) {
            // 移除button
            [button removeFromSuperview];
        }];
        
    }];
}

/**
 *  设置导航条的内容
 */
- (void)setupNavBar{

    /*
     // 导航条左边按钮
     UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
     [leftButton setBackgroundImage:[UIImage imageWithName:@"navigationbar_friendsearch"] forState:UIControlStateNormal];
     [leftButton setBackgroundImage:[UIImage imageWithName:@"navigationbar_friendsearch_highlighted"] forState:UIControlStateHighlighted];
     
     leftButton.frame = CGRectMake(0, 0, leftButton.currentBackgroundImage.size.width, leftButton.currentBackgroundImage.size.height);
     
     self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
     
     // 导航条右边按钮
     UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
     [rightButton setBackgroundImage:[UIImage imageWithName:@"navigationbar_pop"] forState:UIControlStateNormal];
     [rightButton setBackgroundImage:[UIImage imageWithName:@"navigationbar_pop_highlighted"] forState:UIControlStateHighlighted];
     
     rightButton.frame = CGRectMake(0, 0, rightButton.currentBackgroundImage.size.width, rightButton.currentBackgroundImage.size.height);
     
     self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
     */
    
    // 上述代码有很重复了，可以用一个分类来解决代码重复的问题
    
    // 导航条左边按钮
    UIBarButtonItem *leftButton = [UIBarButtonItem itemWithIcon:@"navigationbar_friendsearch" highlightIcon:@"navigationbar_friendsearch_highlighted" target:self action:@selector(findFriend)];
    
    self.navigationItem.leftBarButtonItem = leftButton;
    
    // 导航条右边按钮
    UIBarButtonItem *rightButton = [UIBarButtonItem itemWithIcon:@"navigationbar_pop" highlightIcon:@"navigationbar_pop_highlighted" target:self action:@selector(pop)];
    
    self.navigationItem.rightBarButtonItem = rightButton;
    
    WBTitleButton *titleButton = [[WBTitleButton alloc] init];
    
    
    [titleButton setTitle:@"首页" forState:UIControlStateNormal];
   
    // 给标题按钮设置监听
    [titleButton addTarget:self action:@selector(titleClick:) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.titleView = titleButton;
    
    self.titleButton = titleButton;
}

- (void)findFriend{
    // 使用自定义的log
    WBLog(@"findFriend");
}

- (void)pop{
    // 使用自定义的log
    WBLog(@"pop");
}

- (void)titleClick:(WBTitleButton *)titleButton{
    
    WBLog(@"titlebutton state %lu",titleButton.state);

//    if (titleButton.tag == -1) {
//        
//        // 切换箭头指向
//        [titleButton setImage:[UIImage imageWithName:@"navigationbar_arrow_down"] forState:UIControlStateNormal];
//        
//        titleButton.tag = 0;
//        
//    }else {
//        
//        // 切换箭头指向
//        [titleButton setImage:[UIImage imageWithName:@"navigationbar_arrow_up"] forState:UIControlStateNormal];
//        
//        titleButton.tag = -1;
//    }
    
    // 1.创建下拉菜单
    HWDropdownMenu *menu = [HWDropdownMenu menu];
    menu.delegate = self;
    
    // 2.设置内容
    HWTitleMenuViewController *vc = [[HWTitleMenuViewController alloc] init];
    vc.view.height = 150;
    vc.view.width = 150;
    
    vc.view.layer.borderWidth = 4;
    menu.contentController = vc;
    
    // 3.显示
    [menu showFrom:titleButton];
}





#pragma mark -tableView的数据源方法

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return self.statusFrames.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    // 1.创建cell
    WBStatusCell *cell = [WBStatusCell cellWithTableView:tableView];
    
    // 2.传递frame模型
    cell.statusFrame = self.statusFrames[indexPath.row];
    
    return cell;
}

#pragma mark -tableView的代理方法
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    WBStatusFrame *statusFrame = self.statusFrames[indexPath.row];
    
    return statusFrame.cellHeight;
}

//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//
//    UIViewController *vc = [[UIViewController alloc] init];
//    vc.view.backgroundColor = [UIColor yellowColor];
//    [self.navigationController pushViewController:vc animated:YES];
//}

@end
