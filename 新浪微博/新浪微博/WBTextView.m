//
//  WBTextView.m
//  WeiBo
//
//  Created by Doublenian on 15/3/21.
//  Copyright (c) 2015年 com.doublenian. All rights reserved.
//

#import "WBTextView.h"

@interface WBTextView()

@property (nonatomic,weak)UILabel *placeholderLabel;

@end

@implementation WBTextView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        UILabel *placeholderLabel = [[UILabel alloc] init];
        
        placeholderLabel.textColor = [UIColor lightGrayColor];
        placeholderLabel.hidden = YES;
        // 自动换行
        placeholderLabel.numberOfLines = 0;
        placeholderLabel.backgroundColor = [UIColor clearColor];
        // placeholder的字体应该与textView的字体一致
        placeholderLabel.font = self.font;
        [self insertSubview:placeholderLabel atIndex:0];
        
        self.placeholderLabel = placeholderLabel;
        
        // 监听textView文字改变的通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidChange) name:UITextViewTextDidChangeNotification object:self];
        
        
    }
    return self;
}

- (void)setPlaceholder:(NSString *)placeholder{

    _placeholder = [placeholder copy];
    
    self.placeholderLabel.text = placeholder;
    
    if (placeholder.length) {
        
        self.placeholderLabel.hidden = NO;
        
        // 计算frame
        CGFloat placeholderX = 5;
        CGFloat placeholderY = 7;
        CGFloat maxW = self.frame.size.width - 2 * placeholderX;
        CGFloat maxH = self.frame.size.height - 2 * placeholderY;
        CGSize placeholderSize = [placeholder sizeWithFont:self.placeholderLabel.font constrainedToSize:CGSizeMake(maxW, maxH)];
        self.placeholderLabel.frame = CGRectMake(placeholderX, placeholderY, placeholderSize.width, placeholderSize.height);
        
    }else{
        
        self.placeholderLabel.hidden = YES;
    }
    
}

- (void)setPlaceholderColor:(UIColor *)placeholderColor
{
    _placeholderColor = placeholderColor;
    
    self.placeholderLabel.textColor = placeholderColor;
}

- (void)setFont:(UIFont *)font
{
    [super setFont:font];
    
    self.placeholderLabel.font = font;
    
    // 这句话的作用是为了调用set方法，重新计算placeholderLabel的尺寸
    self.placeholder = self.placeholder;
}


- (void)textDidChange{

    self.placeholderLabel.hidden = (self.text.length != 0);
}

- (void)dealloc{

    // 移除监听
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
