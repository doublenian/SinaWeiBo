//
//  WBNavigationController.m
//  WeiBo
//
//  Created by Doublenian on 15/3/21.
//  Copyright (c) 2015年 com.doublenian. All rights reserved.
//

#import "WBNavigationController.h"
#import "UIImage+Extension.h"

@interface WBNavigationController ()

@end

@implementation WBNavigationController

/**
 *  第一次使用这个类的时候会调用
 */
+ (void)initialize{

    [self setupNavBarTheme];
    
    [self setupNavBarButtonTheme];
    
}

/**
 *  设置导航条的主题
 */
+ (void)setupNavBarTheme{
    
    // 获取导航条
    UINavigationBar *navBar = [UINavigationBar appearance];
    
    // 设置背景
    if (!iOS7) {
        
        [navBar setBackgroundImage:[UIImage imageWithName:@"navigationbar_background"] forBarMetrics:UIBarMetricsDefault];
        
        // 状态栏的背景会被导航栏同化，我们需要把状态栏的背景设置回来
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleBlackOpaque;
    }
    
    NSMutableDictionary *textAttrs = [NSMutableDictionary dictionary];
    
    // 设置文字颜色
    textAttrs[UITextAttributeTextColor] = [UIColor blackColor];
    // 设置文字不要阴影效果
    textAttrs[UITextAttributeTextShadowOffset] = [NSValue valueWithUIOffset:UIOffsetZero];
    // 设置字体
    textAttrs[UITextAttributeFont] = [UIFont boldSystemFontOfSize:19];
    
    [navBar setTitleTextAttributes:textAttrs];
}

/**
 *  设置导航条中按钮的主题
 */
+ (void)setupNavBarButtonTheme{

    // 获取导航条按钮
    UIBarButtonItem *item = [UIBarButtonItem appearance];
    
    // 设置背景
    if (!iOS7) {
        [item setBackgroundImage:[UIImage imageWithName:@"navigationbar_button_background"] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
        [item setBackgroundImage:[UIImage imageWithName:@"navigationbar_button_background_pushed"] forState:UIControlStateHighlighted barMetrics:UIBarMetricsDefault];
        [item setBackgroundImage:[UIImage imageWithName:@"navigationbar_button_background_disable"] forState:UIControlStateDisabled barMetrics:UIBarMetricsDefault];
    }
    
    NSMutableDictionary *textAttrs = [NSMutableDictionary dictionary];
    // 设置文字颜色
    textAttrs[UITextAttributeTextColor] = iOS7 ? [UIColor orangeColor] : [UIColor grayColor];
    // 设置文字不要阴影效果
    textAttrs[UITextAttributeTextShadowOffset] = [NSValue valueWithUIOffset:UIOffsetZero];
    // 设置字体
    textAttrs[UITextAttributeFont] = [UIFont systemFontOfSize:iOS7 ? 15 : 12];
    
    // 设置normal状态下文字属性
    [item setTitleTextAttributes:textAttrs forState:UIControlStateNormal];
    // 设置高亮状态下文字属性
    [item setTitleTextAttributes:textAttrs forState:UIControlStateHighlighted];
    
    // 设置disabled状态下文字属性
    NSMutableDictionary *disableTextAttrs = [NSMutableDictionary dictionary];
    disableTextAttrs[UITextAttributeTextColor] =  [UIColor lightGrayColor];
    [item setTitleTextAttributes:disableTextAttrs forState:UIControlStateDisabled];
    
}


/**
 *  在这个方法中拦截所有的push操作
 */
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated{
    
    // 只有导航控制器的根控制器需要底部菜单条，其他的控制器不需要
    // 这里为什么是>0,而不是>1呢？因为根控制器也是push进来的
    if (self.viewControllers.count > 0) {
        
        // 隐藏底部菜单条
        viewController.hidesBottomBarWhenPushed = YES;
    }
    
    [super pushViewController:viewController animated:animated];
}

@end
