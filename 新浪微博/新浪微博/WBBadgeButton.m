//
//  WBBadgeButton.m
//  WeiBo
//
//  Created by Doublenian on 15/3/21.
//  Copyright (c) 2015年 com.doublenian. All rights reserved.
//

#import "WBBadgeButton.h"
#import "UIImage+Extension.h"

@implementation WBBadgeButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        // badgeValue一开始是隐藏的
        self.hidden = YES;
        
        // badgeValue不可点击
        self.userInteractionEnabled = NO;
        
        // 设置badgeValue的背景图片
        [self setBackgroundImage:[UIImage resizedImageWithName:@"main_badge"] forState:UIControlStateNormal];
        
        // 设置badgeValue的字体
        self.titleLabel.font = [UIFont systemFontOfSize:11];
        
    }
    return self;
}

- (void)setBadgeValue:(NSString *)badgeValue{

#warning copy
    _badgeValue = [badgeValue copy];
    
    if (badgeValue != nil) {
        
        // 显示badgeValue
        self.hidden = NO;
        
        // 设置badgeValue的文字
        [self setTitle:badgeValue forState:UIControlStateNormal];
        
        // 设置badgeValue的尺寸
        CGRect tempFrame = self.frame;
        CGFloat badgeH = self.currentBackgroundImage.size.height;
        CGFloat badgeW = self.currentBackgroundImage.size.width;
        
        if (badgeValue.length > 1) {
            
            // 文字的尺寸
            CGSize badgeSize = [badgeValue sizeWithFont:self.titleLabel.font];
            
            // 根据文字的尺寸来确定badgeValue的尺寸
            badgeW = badgeSize.width + 10;
        }
        
        tempFrame.size.width = badgeW;
        tempFrame.size.height = badgeH;
        
        self.frame = tempFrame;
    
    }else{
        
        self.hidden = YES;
    }
}

@end
