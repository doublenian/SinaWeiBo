//
//  WBAccount.m
//  WeiBo
//
//  Created by Doublenian on 15/3/21.
//  Copyright (c) 2015年 com.doublenian. All rights reserved.
//

#import "WBAccount.h"

@implementation WBAccount

- (instancetype)initWithDict:(NSDictionary *)dict{

    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:dict];
    }
    
    return self;
}

+ (instancetype)accountWithDict:(NSDictionary *)dict{

    return [[self alloc] initWithDict:dict];
}

/**
 *  从文件中解析对象的时候调
 */
- (id)initWithCoder:(NSCoder *)coder
{
    self = [super init];
    if (self) {
        self.access_token = [coder decodeObjectForKey:@"access_token"];
        self.remind_in = [coder decodeInt64ForKey:@"remind_in"];
        self.expires_in = [coder decodeInt64ForKey:@"expires_in"];
        self.expiresTime = [coder decodeObjectForKey:@"expiresTime"];
        self.uid = [coder decodeInt64ForKey:@"uid"];
        self.name = [coder decodeObjectForKey:@"name"];
    }
    return self;
}

/**
 *  将对象写入文件的时候调用
 */
- (void)encodeWithCoder:(NSCoder *)coder
{
    [coder encodeObject:self.access_token forKey:@"access_token"];
    [coder encodeInt64:self.remind_in forKey:@"remind_in"];
    [coder encodeInt64:self.expires_in forKey:@"expires_in"];
    [coder encodeObject:self.expiresTime forKey:@"expiresTime"];
    [coder encodeInt64:self.uid forKey:@"uid"];
    [coder encodeObject:self.name forKey:@"name"];
}

@end
