//
//  UIImage+Extension.m
//  新浪微博
//
//  Created by XinYou on 15-4-14.
//  Copyright (c) 2015年 vxinyou. All rights reserved.
//

#import "UIImage+Extension.h"

@implementation UIImage (Extension)

+ (UIImage *)imageWithName:(NSString *)name{

    // 如果是ios7系统
    if (iOS7) {
        NSString *newName = [name stringByAppendingString:@"_os7"];
        UIImage *image = [UIImage imageNamed:newName];
        // 如果没有对应的ios7图片，就使用原图片
        if (image == nil) {
            image = [UIImage imageNamed:name];
        }
        
        return image;
    }
    
    return [UIImage imageNamed:name];
}

+ (UIImage *)resizedImageWithName:(NSString *)name
{
    return [self resizedImageWithName:name left:0.5 top:0.5];
}

+ (UIImage *)resizedImageWithName:(NSString *)name left:(CGFloat)left top:(CGFloat)top
{
    UIImage *image = [self imageWithName:name];
    return [image stretchableImageWithLeftCapWidth:image.size.width * left topCapHeight:image.size.height * top];
}
@end
