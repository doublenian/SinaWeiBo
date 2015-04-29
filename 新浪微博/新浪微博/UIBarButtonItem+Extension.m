//
//  UIBarButtonItem+Extension.m
//  新浪微博
//
//  Created by XinYou on 15-4-16.
//  Copyright (c) 2015年 vxinyou. All rights reserved.
//

#import "UIBarButtonItem+Extension.h"
#import "UIImage+Extension.h"

@implementation UIBarButtonItem (Extension)

+ (instancetype)itemWithIcon:(NSString *)icon highlightIcon:(NSString *)highlightIcon target:(id)target action:(SEL)action{

    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setBackgroundImage:[UIImage imageWithName:icon] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageWithName:highlightIcon] forState:UIControlStateHighlighted];
    
//    button.frame = CGRectMake(0, 0, button.currentBackgroundImage.size.width, button.currentBackgroundImage.size.height);
    // 这两句是等价的
    button.frame = (CGRect){CGPointZero, button.currentBackgroundImage.size};
    
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    return [[UIBarButtonItem alloc] initWithCustomView:button];
}

@end
