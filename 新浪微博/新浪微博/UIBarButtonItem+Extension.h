//
//  UIBarButtonItem+Extension.h
//  新浪微博
//
//  Created by XinYou on 15-4-16.
//  Copyright (c) 2015年 vxinyou. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (Extension)

+ (instancetype)itemWithIcon:(NSString *)icon highlightIcon:(NSString *)highlightIcon target:(id)target action:(SEL)action;

@end
