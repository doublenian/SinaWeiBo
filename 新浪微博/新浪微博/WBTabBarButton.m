//
//  WBTabBarButton.m
//  WeiBo
//
//  Created by Doublenian on 15/3/21.
//  Copyright (c) 2015年 com.doublenian. All rights reserved.
//

#import "WBTabBarButton.h"
#import "UIImage+Extension.h"
#import "WBBadgeButton.h"

// 按钮normal状态下的文字颜色(ios7为黑色，低于ios7为白色)
#define WBTabBarButtonTitleColor (iOS7 ? [UIColor blackColor] : [UIColor whiteColor])

// 按钮selected状态下文字颜色
#define WBTabBarButtonTitleSelectedColor (iOS7 ? WBColor(234, 103, 7) : WBColor(248, 139, 0))

@interface WBTabBarButton()

@property (nonatomic, weak)WBBadgeButton *badgeButton;

@end

@implementation WBTabBarButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        // 图片居中
        self.imageView.contentMode = UIViewContentModeCenter;
        
        // 文字居中
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        
        // 设置文字的字体
        self.titleLabel.font = [UIFont systemFontOfSize:12];
        
        // 设置文字颜色
        [self setTitleColor:WBTabBarButtonTitleColor forState:UIControlStateNormal];
        [self setTitleColor:WBTabBarButtonTitleSelectedColor forState:UIControlStateSelected];
    
        if (!iOS7) { // 非iOS7下,设置按钮选中时的背景
            [self setBackgroundImage:[UIImage imageWithName:@"tabbar_slider"] forState:UIControlStateSelected];
        }
        
        // 添加一个badgeValue
        WBBadgeButton *badgeButton = [[WBBadgeButton alloc] init];
        
        [self addSubview:badgeButton];
        
        self.badgeButton = badgeButton;
    }
    return self;
}
// 设置按钮内部图片的位置
- (CGRect)imageRectForContentRect:(CGRect)contentRect{
    
    CGFloat imageW = contentRect.size.width;
    // 0.6表示图片占整个按钮上面60%
    CGFloat imageH = contentRect.size.height * 0.6;
    return CGRectMake(0, 0, imageW, imageH);
}

// 设置按钮内部文字的frame
- (CGRect)titleRectForContentRect:(CGRect)contentRect{

    CGFloat titleY = contentRect.size.height * 0.6;
    CGFloat titleW = contentRect.size.width;
    CGFloat titleH = contentRect.size.height - titleY;
    
    return CGRectMake(0, titleY, titleW, titleH);
}

- (void)setHighlighted:(BOOL)highlighted{
    // 这里无需做任何实现，目的是在选中按钮被选中的时候去除高亮状态，直接进入selectend状态。
}

// 设置item
- (void)setItem:(UITabBarItem *)item{
    
    _item = item;
    
    // KVO 监听属性改变
    [item addObserver:self forKeyPath:@"title" options:0 context:nil];
    [item addObserver:self forKeyPath:@"image" options:0 context:nil];
    [item addObserver:self forKeyPath:@"selectedImage" options:0 context:nil];
    [item addObserver:self forKeyPath:@"badgeValue" options:0 context:nil];
    
    // 
    [self observeValueForKeyPath:nil ofObject:nil change:nil context:nil];
}

/**
 *  监听到某个对象的属性改变了,就会调用
 *
 *  @param keyPath 属性名
 *  @param object  哪个对象的属性被改变
 *  @param change  属性发生的改变
 */
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{

    // 设置文字
    [self setTitle:self.item.title forState:UIControlStateSelected];
    [self setTitle:self.item.title forState:UIControlStateNormal];
    
    // 设置图片
    [self setImage:self.item.image forState:UIControlStateNormal];
    [self setImage:self.item.selectedImage forState:UIControlStateSelected];
    
    // 设置badgeValue要显示的字符串
    self.badgeButton.badgeValue = self.item.badgeValue;
    
//    // 设置badgeValue的位置
//    CGFloat badgeY = 5;
//    CGFloat badgeX = self.frame.size.width -self.badgeButton.frame.size.width - 10;
//    // 理解为什么这么做！！！
//    self.badgeButton.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;
//    CGRect tempFrame = self.badgeButton.frame;
//    tempFrame.origin.x = badgeX;
//    tempFrame.origin.y = badgeY;
//    self.badgeButton.frame = tempFrame;
}

// 设置badgeValue的位置
- (void)layoutSubviews{

    [super layoutSubviews];

    CGFloat badgeY = 2;
    CGFloat badgeX = self.frame.size.width * 0.5 + 2;
    
    CGRect tempFrame = self.badgeButton.frame;
    tempFrame.origin.x = badgeX;
    tempFrame.origin.y = badgeY;
    
    self.badgeButton.frame = tempFrame;

}

// 移除所有监听
- (void)dealloc
{
    [self.item removeObserver:self forKeyPath:@"badgeValue"];
    [self.item removeObserver:self forKeyPath:@"title"];
    [self.item removeObserver:self forKeyPath:@"image"];
    [self.item removeObserver:self forKeyPath:@"selectedImage"];
}

@end
