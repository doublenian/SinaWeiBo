//
//  WBAccount.h
//  WeiBo
//
//  Created by Doublenian on 15/3/21.
//  Copyright (c) 2015年 com.doublenian. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WBAccount : NSObject<NSCoding>

@property (nonatomic, copy)NSString *access_token;

// 数字很大的情况下应该用long long

// access_token的有效期(单位:秒)
@property (nonatomic, assign)long long expires_in;

// access_token的到期时间
@property (nonatomic, strong)NSDate *expiresTime;

@property (nonatomic, assign)long long remind_in;

@property (nonatomic, assign)long long uid;

@property (nonatomic, copy)NSString *name;

- (instancetype)initWithDict:(NSDictionary *)dict;

+ (instancetype)accountWithDict:(NSDictionary *)dict;

@end
