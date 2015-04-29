//
//  WBAppDelegate.m
//  WeiBo
//
//  Created by Doublenian on 15/3/21.
//  Copyright (c) 2015年 com.doublenian. All rights reserved.
//

#import "WBAppDelegate.h"
#import "WBNewFeatureViewController.h"
#import "WBOAuthViewController.h"
#import "WBAccount.h"
#import "WBChoseRootControllerTool.h"
#import "WBAccountTool.h"
#import "SDWebImageManager.h"




@implementation WBAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // 这里为什么这么设置？参见博客：http://blog.csdn.net/liu537192/article/details/44560157
//    application.statusBarHidden = NO;
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    [self.window makeKeyAndVisible];
    
    
    /*先检查版本信息，看是否为最新的版本，如果是最新就直接到授权页，如果不是那么到NewFeature页*/
    
    [WBChoseRootControllerTool choseRootController];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

/**
 *  当应用程序受到内存警告时调用
 */
- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application{

    // 停止下载所有图片
    [[SDWebImageManager sharedManager] cancelAll];
    // 清除内存中的图片
    [[SDWebImageManager sharedManager].imageCache clearMemory];
}

@end
