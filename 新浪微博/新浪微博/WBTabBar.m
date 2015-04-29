//
//  WBTabBar.m
//  WeiBo
//
//  Created by Doublenian on 15/3/21.
//  Copyright (c) 2015年 com.doublenian. All rights reserved.
//

#import "WBTabBar.h"
#import "UIImage+Extension.h"
#import "WBTabBarButton.h"

@interface WBTabBar()
/**
 *  用来记住被选中的按钮
 */
@property (nonatomic, weak)WBTabBarButton *selectedButton;
/**
 *  TabBar正中间的加号按钮
 */
@property (nonatomic, weak)UIButton *plusButton;

@property (nonatomic, strong)NSMutableArray *tabBarButtons;

@end

@implementation WBTabBar

- (NSMutableArray *)tabBarButtons
{
    if (_tabBarButtons == nil) {
        _tabBarButtons = [NSMutableArray array];
    }
    return _tabBarButtons;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        if (!iOS7) { // 非iOS7下,设置tabbar的背景
            self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageWithName:@"tabbar_background"]];
        }
        
        // TabBar中间的加号按钮
        UIButton *plusButton = [UIButton buttonWithType:UIButtonTypeCustom];
        
        [plusButton setBackgroundImage:[UIImage imageWithName:@"tabbar_compose_button"] forState:UIControlStateNormal];
        [plusButton setBackgroundImage:[UIImage imageWithName:@"tabbar_compose_button_highlighted"] forState:UIControlStateHighlighted];
        [plusButton setImage:[UIImage imageWithName:@"tabbar_compose_icon_add"] forState:UIControlStateNormal];
        [plusButton setImage:[UIImage imageWithName:@"tabbar_compose_icon_add_highlighted"] forState:UIControlStateHighlighted];
        
        // 设置加号按钮的宽高为背景图片的宽高
        plusButton.bounds = CGRectMake(0, 0, plusButton.currentBackgroundImage.size.width, plusButton.currentBackgroundImage.size.height + 12);
        [self addSubview:plusButton];
        
        // 设置加号按钮的监听
        [plusButton addTarget:self action:@selector(plusButtonClick) forControlEvents:UIControlEventTouchUpInside];
        
        self.plusButton = plusButton;
    }
    return self;
}

- (void)plusButtonClick{

    if ([self.delegate respondsToSelector:@selector(tabBarDidClickPlusButton:)]) {
        [self.delegate tabBarDidClickPlusButton:self];
    }
}

- (void)addTabBarButtonWithItem:(UITabBarItem *)item{
    
    // 创建按钮
    WBTabBarButton *button = [[WBTabBarButton alloc] init];
    [self addSubview:button];
    
    // 加入数组
    [self.tabBarButtons addObject:button];
    
    // 设置数据
    button.item = item;
    
    // 监听按钮的点击，注意这里监听的是：UIControlEventTouchDown
    [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchDown];
    
    // 默认选中第0个按钮
    if (self.tabBarButtons.count == 1) {
        [self buttonClick:button];
    }
}

- (void)buttonClick:(WBTabBarButton *)button{
    
    // 通知代理
    if ([self.delegate respondsToSelector:@selector(tabBar:didSelectedButtonFrom:to:)]) {
        [self.delegate tabBar:self didSelectedButtonFrom:self.selectedButton.tag to:button.tag];
    }
    
    // 更换按钮的选中状态
    self.selectedButton.selected = NO;
    button.selected = YES;
    self.selectedButton = button;
}

- (void)layoutSubviews{

    [super layoutSubviews];
    
    // 设置加号按钮的位置
    self.plusButton.center = CGPointMake(self.frame.size.width * 0.5, self.frame.size.height * 0.5);
    
    // 设置tabBarButton的frame数据
    CGFloat buttonH = self.frame.size.height ;
    CGFloat buttonW = self.frame.size.width / self.subviews.count;
    CGFloat buttonY = 0;
    
    for (int index = 0; index < self.tabBarButtons.count; index++) {
        // 取出按钮
        WBTabBarButton *button = self.tabBarButtons[index];
        
        CGFloat buttonX = index * buttonW;
        
        // 加号右边的两个按钮的x坐标需要做特殊处理
        if (index > 1) {
            buttonX += buttonW;
        }
        
        // 设置按钮的frame
        button.frame = CGRectMake(buttonX, buttonY, buttonW, buttonH);
        
        // 绑定tag
        button.tag = index;
    }
    
}

@end
