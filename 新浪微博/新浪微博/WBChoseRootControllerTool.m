//
//  WBChoseRootControllerTool.m
//  WeiBo
//
//  Created by Doublenian on 15/3/21.
//  Copyright (c) 2015年 com.doublenian. All rights reserved.
//

#import "WBChoseRootControllerTool.h"
#import "WBTabBarViewController.h"
#import "WBNewFeatureViewController.h"
#import "WBOAuthViewController.h"
#import "WBAccount.h"

#import "WBAccountTool.h"

@implementation WBChoseRootControllerTool

/**
 *  检查版本，选择根控制器
 */
+ (void)choseRootController{

    NSString *key = @"CFBundleVersion";// 在info.plist文件中版本号对应的key是"CFBundleVersion"
    
    // 取出沙盒中存储的上次使用软件的版本号
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *lastVersion = [defaults stringForKey:key];
    
    // 获得当前软件的版本号(infoDictionary表示info.plist文件)
    NSString *currentVersion = [NSBundle mainBundle].infoDictionary[key];
    
    // 设置整个应用的根控制器,如果是最新版本那就跳到WBTabBarController主界面
    
    if ([currentVersion isEqualToString:lastVersion]) {
        
        //此时应该取出用户的登录信息,检查用户是否登陆过
        
        if ([WBAccountTool getAccount]) {
            
            [UIApplication sharedApplication].keyWindow.rootViewController = [[WBTabBarViewController alloc]init];
            
        }else{
            //应该直接跳到登
            [UIApplication sharedApplication].keyWindow.rootViewController = [[WBOAuthViewController alloc] init];
        
        
        }
        
    } else { // 如果不是新版本，那么直接跳到NewFeatureViewController
        [UIApplication sharedApplication].keyWindow.rootViewController = [[WBNewFeatureViewController alloc] init];
        // 存储新版本
        [defaults setObject:currentVersion forKey:key];
        [defaults synchronize];
        //跳到登陆页
        
    }
}

@end
