//
//  WBAccountTool.m
//  WeiBo
//
//  Created by Doublenian on 15/3/21.
//  Copyright (c) 2015年 com.doublenian. All rights reserved.
//

#import "WBAccountTool.h"

// 账户信息文件的路径
#define WBPathOfSaveAccount [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"account.data"]

@implementation WBAccountTool

+ (void)saveAccount:(WBAccount *)account{

    // 当前时间
    NSDate *currentTime = [NSDate date];
    
    // 当前时间 + 有效期 = 过期时间
    account.expiresTime = [currentTime dateByAddingTimeInterval:account.expires_in];
    
    // 归档
    [NSKeyedArchiver archiveRootObject:account toFile:WBPathOfSaveAccount];
}

+ (WBAccount *)getAccount{

    WBAccount *account = [NSKeyedUnarchiver unarchiveObjectWithFile:WBPathOfSaveAccount];
    
    // 当前时间
    NSDate *currentTime = [NSDate date];
    
    // 如果当前时间早于过期时间，表示access_token还未过期
    if ([currentTime compare:account.expiresTime] == NSOrderedAscending) {
        
        return  account;
        
    }else {// access_token过期，返回空
        
        return nil;
    }
}

@end
