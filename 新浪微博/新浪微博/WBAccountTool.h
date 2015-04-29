//
//  WBAccountTool.h

//  WeiBo
//
//  Created by Doublenian on 15/3/21.
//  Copyright (c) 2015年 com.doublenian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WBAccount.h"

@interface WBAccountTool : NSObject

/**
 *  存储账户信息
 */
+ (void)saveAccount:(WBAccount *)account;

/**
 *  获取账户信息
 */
+ (WBAccount *)getAccount;

@end
