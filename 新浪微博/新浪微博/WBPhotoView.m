//
//  WBPhotoView.m
//  WeiBo
//
//  Created by Doublenian on 15/3/21.
//  Copyright (c) 2015年 com.doublenian. All rights reserved.
//
#import "WBPhotoView.h"
#import "WBPhoto.h"
#import "UIImageView+WebCache.h"
#import "UIImage+Extension.h"

@interface WBPhotoView()
@property (nonatomic, weak) UIImageView *gifView;
@end

@implementation WBPhotoView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // 添加一个GIF小图片
        UIImage *image = [UIImage imageWithName:@"timeline_image_gif"];
        UIImageView *gifView = [[UIImageView alloc] initWithImage:image];
        [self addSubview:gifView];
        self.gifView = gifView;
    }
    return self;
}

- (void)setPhoto:(WBPhoto *)photo
{
    _photo = photo;
    
    // 控制gifView的可见性
    self.gifView.hidden = ![photo.thumbnail_pic hasSuffix:@"gif"];
    
    // 下载图片
    
    [self sd_setImageWithURL:[NSURL URLWithString:photo.thumbnail_pic]  placeholderImage:[UIImage imageWithName:@"timeline_image_placeholder"]];
    
    
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.gifView.layer.anchorPoint = CGPointMake(1, 1);
    self.gifView.layer.position = CGPointMake(self.frame.size.width, self.frame.size.height);
}

@end
