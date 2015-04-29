//
//  WBComposeToolbar.h
//  WeiBo
//
//  Created by Doublenian on 15/3/21.
//  Copyright (c) 2015年 com.doublenian. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WBComposeToolbar;

typedef enum {
    WBComposeToolbarButtonTypeCamera,
    WBComposeToolbarButtonTypePicture,
    WBComposeToolbarButtonTypeMention,
    WBComposeToolbarButtonTypeTrend,
    WBComposeToolbarButtonTypeEmotion
} WBComposeToolbarButtonType;

@protocol WBComposeToolbarDelegate <NSObject>

@optional
- (void)composeToolbar:(WBComposeToolbar *)toolbar didClickedButton:(WBComposeToolbarButtonType)buttonType;

@end

@interface WBComposeToolbar : UIView

@property (nonatomic, weak)id<WBComposeToolbarDelegate> delegate;

@end
