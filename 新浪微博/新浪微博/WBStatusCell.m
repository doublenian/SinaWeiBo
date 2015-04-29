//
//  WBStatusCell.m
//  WeiBo
//
//  Created by Doublenian on 15/3/21.
//  Copyright (c) 2015年 com.doublenian. All rights reserved.
//

#import "WBStatusCell.h"
#import "WBStatusFrame.h"
#import "WBStatus.h"
#import "WBUser.h"
#import "UIImageView+WebCache.h"
#import "UIImage+Extension.h"
#import "WBStatusTopView.h"
#import "WBStatusToolbar.h"

@interface WBStatusCell()

/** 顶部的view */
@property (nonatomic, weak) WBStatusTopView *topView;


/** 微博的工具条 */
@property (nonatomic, weak) WBStatusToolbar *statusToolbar;

@end

@implementation WBStatusCell

#pragma mark - 初始化
+ (instancetype)cellWithTableView:(UITableView *)tableView{

    static NSString *ID = @"status";
    WBStatusCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (cell == nil) {
        cell = [[WBStatusCell alloc] initWithStyle:(UITableViewCellStyleSubtitle) reuseIdentifier:ID];
    }
    
    return cell;
}

/**
 *  在init方法中添加子控件
 */
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        // 1.添加顶部的view
        [self setupTopView];
        
        // 2.添加微博的工具条
        [self setupStatusToolbar];
    }
    return self;
}
/**
 *  添加顶部的view
 */
- (void)setupTopView
{
    self.backgroundColor = [UIColor clearColor];
    
    // 0.设置cell选中时的背景
    self.selectedBackgroundView = [[UIView alloc] init];
    
    /** 1.顶部的view */
    WBStatusTopView *topView = [[WBStatusTopView alloc] init];
    [self.contentView addSubview:topView];
    self.topView = topView;
}
/**
 *  添加微博的工具条
 */
- (void)setupStatusToolbar
{
    /** 微博的工具条 */
    WBStatusToolbar *statusToolbar = [[WBStatusToolbar alloc] init];
    [self.contentView addSubview:statusToolbar];
    self.statusToolbar = statusToolbar;
}

/**
 *  拦截contentView的frame的设置(是为了让cell的左右两边和屏幕之间有间距)
 */
- (void)setFrame:(CGRect)frame{

    // 这句是为了让contentView与cell的底部留出一些间距(让用户以为cell与cell之间有间距)
    frame.size.height -= WBStatusTableBorder;
    
    // 这两句是为了让contentView的左右两边与cell的左右两边有一些间距
    frame.origin.x = WBStatusTableBorder;
    frame.size.width -= 2 * WBStatusTableBorder;
    
    [super setFrame:frame];
}

#pragma mark - 数据的设置
/**
 *  传递模型数据
 */
- (void)setStatusFrame:(WBStatusFrame *)statusFrame
{
    _statusFrame = statusFrame;
    
    // 1.设置顶部view的数据
    [self setupTopViewData];
    
    // 2.设置微博工具条的数据
    [self setupStatusToolbarData];
}

/**
 *  设置顶部view的数据
 */
- (void)setupTopViewData
{
    // 1.topView
    self.topView.frame = self.statusFrame.topViewF;
    
    // 2.传递模型数据
    self.topView.statusFrame = self.statusFrame;
}

/**
 *  设置微博工具条的数据
 */
- (void)setupStatusToolbarData
{
    self.statusToolbar.frame = self.statusFrame.statusToolbarF;
    self.statusToolbar.status = self.statusFrame.status;
}

@end
