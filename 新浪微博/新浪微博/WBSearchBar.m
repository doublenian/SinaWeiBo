//
//  WBSearchBar.m
//  WeiBo
//
//  Created by Doublenian on 15/3/21.
//  Copyright (c) 2015年 com.doublenian. All rights reserved.
//

#import "WBSearchBar.h"
#import "UIImage+Extension.h"

@implementation WBSearchBar

+ (instancetype)searchBar{

    return [[self alloc] init];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // 设置的背景
        self.background = [UIImage resizedImageWithName:@"searchbar_textfield_background"];
        // 设置文字字体
        self.font = [UIFont systemFontOfSize:13];
        
        if (!iOS7) {
            // 在ios6中使用xib生成的UITextField中的文字默认是左对齐，竖直方向居中
            // 但是使用代码生成的UITextField中的文字在竖直方向不居中，向上对齐。
            // 摘自博客：http://blog.csdn.net/slinloss/article/details/38302569
            self.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        }
        
        UIImageView *iconView = [[UIImageView alloc] initWithImage:[UIImage imageWithName:@"searchbar_textfield_search_icon"]];
        // 居中显示
        iconView.contentMode = UIViewContentModeCenter;
        
        // 设置左边按钮的图片(放大镜)
        self.leftView = iconView;
        // 设置左边按钮为显示
        self.leftViewMode = UITextFieldViewModeAlways;
        
        // 设置右边的清空按钮为显示
        self.clearButtonMode = UITextFieldViewModeAlways;
        
        // 设置提醒文字
        NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
        attrs[NSForegroundColorAttributeName] = [UIColor grayColor];
        self.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"搜索" attributes:attrs];
        
        // 设置键盘右下角按钮的样式
        self.returnKeyType = UIReturnKeySearch;
        self.enablesReturnKeyAutomatically = YES;
        
    }
    return self;
}


- (void)layoutSubviews{

    [super layoutSubviews];
    
    // 设置左边放大镜的尺寸
    self.leftView.frame = CGRectMake(0, 0, 30, self.frame.size.height);
}

@end
