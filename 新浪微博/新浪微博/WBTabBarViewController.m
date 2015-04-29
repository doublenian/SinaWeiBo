//
//  WBTabBarViewController.m
//  WeiBo
//
//  Created by Doublenian on 15/3/21.
//  Copyright (c) 2015年 com.doublenian. All rights reserved.
//

#import "WBTabBarViewController.h"
#import "WBHomeViewController.h"
#import "WBMessageViewController.h"
#import "WBDiscoverViewController.h"
#import "WBMeViewController.h"
#import "UIImage+Extension.h"
#import "WBTabBar.h"
#import "WBNavigationController.h"
#import "WBComposeViewController.h"

#import "PopMenu.h"

@interface WBTabBarViewController ()<WBTabBarDelegate>

@property (nonatomic, weak)WBTabBar *customeTabBar;
@property (nonatomic, strong) PopMenu *popMenu;

@end

@implementation WBTabBarViewController

#pragma mark -生命周期方法
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // 初始化TabBar
    [self setupTabBar];
    
    // 初始化所有的子控制器
    [self setupAllChildViewControllers];
}

- (void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:animated];
    
    // 通过打印可知TabBar中的子控件是UITabBarButton
    // UITabBarButton是系统私有API，我们是不能调用的
    // 但是可以肯定的是，只要是Button就继承自UIControl
//    NSLog(@"%@", self.tabBar.subviews);
    
    // 删除系统自带TabBar中的子控件(UITabBarButton)
    for (UIView *child in self.tabBar.subviews) {
        if ([child isKindOfClass:[UIControl class]]) {
            [child removeFromSuperview];
        }
    }
    
}

#pragma mark -一些初始化方法
/**
 *  初始化TabBar，这里使用的是自定义的TabBar
 */
- (void)setupTabBar{
    // 创建自定义的TabBar
    WBTabBar *customTabBar = [[WBTabBar alloc] init];
    // 设置frame
    customTabBar.frame = self.tabBar.bounds;
    // 设置代理
    customTabBar.delegate = self;
    // 覆盖系统自带的TabBar
    [self.tabBar addSubview:customTabBar];
    
    self.customeTabBar = customTabBar;
}

/**
 *  初始化所有子控制器
 */
- (void)setupAllChildViewControllers{
    
    // 首页
    WBHomeViewController *home = [[WBHomeViewController alloc] init];
    home.tabBarItem.badgeValue = @"99+";
    [self setupChildViewController:home title:@"首页" imageName:@"tabbar_home" selectedImageName:@"tabbar_home_selected"];
    
    // 消息
    WBMessageViewController *message = [[WBMessageViewController alloc] init];
    message.tabBarItem.badgeValue = @"15";
    [self setupChildViewController:message title:@"消息" imageName:@"tabbar_message_center" selectedImageName:@"tabbar_message_center_selected"];
    
    // 广场
    WBDiscoverViewController *discover = [[WBDiscoverViewController alloc] init];
    discover.tabBarItem.badgeValue = @"New";
    [self setupChildViewController:discover title:@"广场" imageName:@"tabbar_discover" selectedImageName:@"tabbar_discover_selected"];
    
    // 我
    WBMeViewController *me = [[WBMeViewController alloc] init];
    me.tabBarItem.badgeValue = @"3";
    [self setupChildViewController:me title:@"我" imageName:@"tabbar_profile" selectedImageName:@"tabbar_profile_selected"];
}

/**
 *  初始化一个子控制器
 *
 *  @param childVc           要初始化的子控制器
 *  @param title             子控制器的标题
 *  @param imageName         子控制器在TabBar中normal状态对应的图片
 *  @param selectedImageName 子控制器在TabBar中selected状态对应的图片
 */
- (void)setupChildViewController:(UIViewController *)childVc title:(NSString *)title imageName:(NSString *)imageName selectedImageName:(NSString *)selectedImageName{
    
    // 设置控制器的标题
//    childVc.navigationItem.title = title;
//    childVc.tabBarItem.title = title;
    // 这一句等于上面两句
    childVc.title = title;
    
    // 设置控制器normal状态对应的图片
    childVc.tabBarItem.image = [UIImage imageWithName:imageName];
    
    // 设置控制器selected状态对应的图片
    UIImage *selectedImage = [UIImage imageWithName:selectedImageName];
    
    if (iOS7) {
        // UIImageRenderingModeAlwaysOriginal:如果不这样设置，ios7系统会默认把图片渲染成蓝色。
        childVc.tabBarItem.selectedImage = [selectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    }else{
        childVc.tabBarItem.selectedImage = selectedImage;
    }
    
    // 包装一个导航控制器
    WBNavigationController *nav = [[WBNavigationController alloc] initWithRootViewController:childVc];
    
    // 添加到UITabBarController
    [self addChildViewController:nav];
    
    [self.customeTabBar addTabBarButtonWithItem:childVc.tabBarItem];
}

#pragma mark -WBTabBar的代理方法
- (void)tabBar:(WBTabBar *)tabBar didSelectedButtonFrom:(int)from to:(int)to{
    // 切换控制器
    self.selectedIndex = to;
}

/**
 *  这个就是点击加号按钮的时候弹出的View
 *
 *  @param tabBar <#tabBar description#>
 */

- (void)tabBarDidClickPlusButton:(WBTabBar *)tabBar{

    
    [self showMenu];
    
    
}

- (void)showMenu {
    NSMutableArray *items = [[NSMutableArray alloc] initWithCapacity:3];
    
    MenuItem *menuItem = [MenuItem itemWithTitle:@"Flickr" iconName:@"post_type_bubble_flickr" glowColor:[UIColor colorWithRed:1.000 green:0.966 blue:0.880 alpha:0.800]];
    [items addObject:menuItem];
    
    menuItem = [MenuItem itemWithTitle:@"Googleplus" iconName:@"post_type_bubble_googleplus" glowColor:[UIColor colorWithRed:0.840 green:0.264 blue:0.208 alpha:0.800]];
    [items addObject:menuItem];
    
    menuItem = [MenuItem itemWithTitle:@"Instagram" iconName:@"post_type_bubble_instagram" glowColor:[UIColor colorWithRed:0.232 green:0.442 blue:0.687 alpha:0.800]];
    [items addObject:menuItem];
    
    menuItem = [MenuItem itemWithTitle:@"Twitter" iconName:@"post_type_bubble_twitter" glowColor:[UIColor colorWithRed:0.000 green:0.509 blue:0.687 alpha:0.800]];
    [items addObject:menuItem];
    
    menuItem = [MenuItem itemWithTitle:@"Youtube" iconName:@"post_type_bubble_youtube" glowColor:[UIColor colorWithRed:0.687 green:0.164 blue:0.246 alpha:0.800]];
    [items addObject:menuItem];
    
    menuItem = [MenuItem itemWithTitle:@"Facebook" iconName:@"post_type_bubble_facebook" glowColor:[UIColor colorWithRed:0.258 green:0.245 blue:0.687 alpha:0.800]];
    [items addObject:menuItem];
    
    if (!_popMenu) {
        _popMenu = [[PopMenu alloc] initWithFrame:self.view.bounds items:items];
        //_popMenu.menuAnimationType = kPopMenuAnimationTypeNetEase;
        _popMenu.menuAnimationType = kPopMenuAnimationTypeSina;
    }
    if (_popMenu.isShowed) {
        return;
    }
    
    __weak typeof(self) weakSelf = self;
    _popMenu.didSelectedItemCompletion = ^(MenuItem *selectedItem) {
        NSLog(@"%@",selectedItem.title);
        
        if ([selectedItem.title isEqualToString:@"Flickr"]) {
            
            WBComposeViewController *composeVc = [[WBComposeViewController alloc] init];
            
            WBNavigationController *nav = [[WBNavigationController alloc] initWithRootViewController:composeVc];
            
            [weakSelf presentViewController:nav animated:YES completion:^{
                    //
            }];
            
        }
    };
    
    [_popMenu showMenuAtView:self.view];
    
}

@end
