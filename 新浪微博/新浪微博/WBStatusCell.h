//
//  WBStatusCell.h
//  WeiBo
//
//  Created by Doublenian on 15/3/21.
//  Copyright (c) 2015年 com.doublenian. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WBStatusFrame;

@interface WBStatusCell : UITableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@property (nonatomic, strong)WBStatusFrame *statusFrame;

@end
