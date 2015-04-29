//
//  WBTabBar.h
//  WeiBo
//
//  Created by Doublenian on 15/3/21.
//  Copyright (c) 2015年 com.doublenian. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WBTabBar;

@protocol WBTabBarDelegate <NSObject>

@optional
/**
 *  TabBar中被选中的按钮发生改变
 *  @param from   之前被选中按钮的索引
 *  @param to     当前被选中按钮的索引
 */
- (void)tabBar:(WBTabBar *)tabBar didSelectedButtonFrom:(int)from to:(int)to;

- (void)tabBarDidClickPlusButton:(WBTabBar *)tabBar;

@end

@interface WBTabBar : UIView

- (void)addTabBarButtonWithItem:(UITabBarItem *)item;

@property (nonatomic, weak)id<WBTabBarDelegate> delegate;

@end
