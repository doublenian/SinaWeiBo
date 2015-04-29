//
//  WBNewFeatureViewController.m
//  WeiBo
//
//  Created by Doublenian on 15/3/21.
//  Copyright (c) 2015年 com.doublenian. All rights reserved.
//

#import "WBNewFeatureViewController.h"
#import "UIImage+Extension.h"
#import "WBTabBarViewController.h"

#import "WBOAuthViewController.h"

#import "WBAccount.h"
#import "WBAccountTool.h"

// 新特性总共有多少页
#define WBNewFeaturePageCount 3

@interface WBNewFeatureViewController ()<UIScrollViewDelegate>

@property (nonatomic, weak)UIPageControl *pageControl;

@end

@implementation WBNewFeatureViewController

/**
 *  隐藏状态栏。针对ios7，详情参见博客：http://blog.csdn.net/liu537192/article/details/45095559
 */
- (BOOL)prefersStatusBarHidden{

    return YES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // 添加ScrollView
    [self setupScrollView];
    
    // 添加pageControl
    [self setupPageControl];
    
}

/**
 *  添加ScrollView
 */
- (void)setupScrollView{
    
    // 创建ScrollView
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    
    scrollView.frame = self.view.bounds;
    
    // 添加ScrollView到控制器view
    [self.view addSubview:scrollView];
    
    CGFloat imageW = scrollView.frame.size.width;
    CGFloat imageH = scrollView.frame.size.height;
    
    // 往ScrollView里面添加图片
    for (int index = 0; index < WBNewFeaturePageCount; index++) {
        UIImageView *imageView = [[UIImageView alloc] init];
        
        NSString *name = nil;
        if (fourInch) { // 是否为4英寸屏幕
            name = [NSString stringWithFormat:@"new_feature_%d-568h", index + 1];
        } else {
            name = [NSString stringWithFormat:@"new_feature_%d", index + 1];
        }
        
        imageView.image = [UIImage imageWithName:name];
        
        CGFloat imageX = index * imageW;
        
        // 设置imageView的frame
        imageView.frame = CGRectMake(imageX, 0, imageW, imageH);
        
        if (index == WBNewFeaturePageCount -1) {
            
            // 在新特性的最后一页加上一些按钮
            [self setupLastImageView:imageView];
        }
        
        // 将imageView添加到ScrollView
        [scrollView addSubview:imageView];
    }
    
    // 设置ScrollView滚动的范围(如果不设置，默认不能滚动)
    scrollView.contentSize = CGSizeMake(imageW * WBNewFeaturePageCount, 0);// 0表示Y方向不能滚动
    
    // 隐藏水平滚动条
    scrollView.showsHorizontalScrollIndicator = NO;
    
    // 去除弹簧效果
    scrollView.bounces = NO;
    
    // 自动分页
    scrollView.pagingEnabled = YES;
    
    // 设置代理
    scrollView.delegate = self;
}

/**
 *  添加pageControl
 */
- (void)setupPageControl{

    UIPageControl *pageControl = [[UIPageControl alloc] init];
    
    pageControl.numberOfPages = WBNewFeaturePageCount;
    
    CGFloat pageControlCenterX = self.view.frame.size.width * 0.5;
    CGFloat pageControlCenterY = self.view.frame.size.height - 30;
    
    // 设置pageControl的中点位置
    pageControl.center = CGPointMake(pageControlCenterX, pageControlCenterY);
    
    // 设置pageControl的尺寸
    pageControl.bounds = (CGRect){CGPointZero, CGSizeMake(100, 30)};
    
    // 设置pageControl小圆点的颜色
    pageControl.currentPageIndicatorTintColor = WBColor(253, 98, 42);
    pageControl.pageIndicatorTintColor = WBColor(189, 189, 189);
    
    [self.view addSubview:pageControl];
    
    self.pageControl = pageControl;
}

- (void)setupLastImageView:(UIImageView *)imageView{
    
    // 1,设置imageView能跟用户交互，不然imageView里面的按钮也不可用
    imageView.userInteractionEnabled = YES;
    
    // 2,添加"进入微博"按钮
    
    // 2.1,创建
    UIButton *enterButton = [[UIButton alloc] init];
    [enterButton setBackgroundImage:[UIImage imageWithName:@"new_feature_finish_button"] forState:UIControlStateNormal];
    [enterButton setBackgroundImage:[UIImage imageWithName:@"new_feature_finish_button_highlighted"] forState:UIControlStateHighlighted];
    
    // 2.2,设置frame
    CGFloat enterButtonCenterX = imageView.frame.size.width * 0.5;
    CGFloat enterButtonCenterY = imageView.frame.size.height * 0.6;
    enterButton.center = CGPointMake(enterButtonCenterX, enterButtonCenterY);
    enterButton.bounds = (CGRect){CGPointZero, enterButton.currentBackgroundImage.size};
    
    // 2.3,设置文字
    [enterButton setTitle:@"进入微博" forState:UIControlStateNormal];
    [enterButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    // 2.4,设置监听
    [enterButton addTarget:self action:@selector(enterWeibo) forControlEvents:UIControlEventTouchUpInside];
    
    [imageView addSubview:enterButton];
    
    // 3,添加checkbox
    UIButton *checkBox = [[UIButton alloc] init];
    checkBox.selected = YES;
    
    // 设置文字
    [checkBox setTitle:@"分享给好友" forState:UIControlStateNormal];
    
    // 设置图片
    [checkBox setImage:[UIImage imageWithName:@"new_feature_share_false"] forState:UIControlStateNormal];
    [checkBox setImage:[UIImage imageWithName:@"new_feature_share_true"] forState:UIControlStateSelected];
    
    // 设置尺寸
    checkBox.bounds = CGRectMake(0, 0, 200, 50);
    
    // 设置位置
    CGFloat checkboxCenterX = enterButtonCenterX;
    CGFloat checkboxCenterY = imageView.frame.size.height * 0.5;
    checkBox.center = CGPointMake(checkboxCenterX, checkboxCenterY);
    
    // 设置文字颜色和字体
    [checkBox setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    checkBox.titleLabel.font = [UIFont systemFontOfSize:15];
    
    // 设置按钮中文字和图片之间的间距
    checkBox.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 10);
    
    // 设置监听
    [checkBox addTarget:self action:@selector(checkboxClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [imageView addSubview:checkBox];
}

- (void)checkboxClick:(UIButton *)checkBox{

    checkBox.selected = !checkBox.isSelected;
}

- (void)enterWeibo{

    WBLog(@"进入微博");
    // 显示状态栏
    [UIApplication sharedApplication].statusBarHidden = NO;
    
    [self checkIsLogin];
    
   
}


- (void)checkIsLogin
{
    //这里应该检查一下，是否登录过，如果登录过，就直接到WBTabBarController,如果没有那么跳到WBOAuthViewController
    
    //检查用户是否登陆过
    WBAccount *account = [WBAccountTool getAccount];
    
    // 如果有存储新浪的账户信息
    if (account != nil) {
        
        // 有登陆过,我们直接跳到 TabBarcontroller        
        self.view.window.rootViewController = [[WBTabBarViewController alloc]init];
        
    } else{// 如果没有新浪的账户信息，进入到授权界面
        
         self.view.window.rootViewController = [[WBOAuthViewController alloc] init];
    }

}

#pragma mark -ScrollView的代理
/**
 *  ScrollView滚动的时候就会调用
 */
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{

    // ScrollView当前滚动到了哪个位置
    // 如果不了解contentOffSet属性表示什么意思，参见博客：http://blog.csdn.net/liu537192/article/details/43732397
    CGFloat offSetX = scrollView.contentOffset.x;
    
    // 计算当前页
    double pageDouble = offSetX / scrollView.frame.size.width;
    
    // ceil:进一法 floor:去尾法 round:四舍五入法
//    int pageInt = ceil(pageDouble);
//    int pageInt = floor(pageDouble);
    int pageInt = round(pageDouble);
    
    self.pageControl.currentPage = pageInt;
}

@end
