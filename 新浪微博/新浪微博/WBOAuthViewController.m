//
//  WBOAuthViewController.m
//  WeiBo
//
//  Created by Doublenian on 15/3/21.
//  Copyright (c) 2015年 com.doublenian. All rights reserved.
//

#import "WBOAuthViewController.h"
#import "WBAccount.h"
#import "WBChoseRootControllerTool.h"
#import "WBAccountTool.h"
#import "MBProgressHUD+MJ.h"
#import "WBHttpTool.h"

#import "WBTabBarViewController.h"

@interface WBOAuthViewController ()<UIWebViewDelegate>

@end

@implementation WBOAuthViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // 创建webView
    UIWebView *webView = [[UIWebView alloc] init];
    
    // 设置webView的frame和代理
    webView.frame = self.view.bounds;
    webView.delegate = self;
    
    [self.view addSubview:webView];
    
    // 构建url和request
    NSString *urlStr = [NSString stringWithFormat:@"https://api.weibo.com/oauth2/authorize?client_id=%@&redirect_uri=%@", WBAppKey, WBRedirectUrl];
    NSURL *url = [NSURL URLWithString:urlStr];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    // 加载授权界面
    [webView loadRequest:request];
}

#pragma mark -webView的代理方法
/**
 *  webView开始加载
 */
-(void)webViewDidStartLoad:(UIWebView *)webView{

    // 提示用户
    [MBProgressHUD showMessage:@"玩命加载中..."];
}

/**
 *  webView加载完毕
 */
- (void)webViewDidFinishLoad:(UIWebView *)webView{

    // 隐藏提示框
    [MBProgressHUD hideHUD];
}
/**
 *  加载出错
 */
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{

    // 隐藏提示框
    [MBProgressHUD hideHUD];
}

/**
 *  当webView要加载一个url之前会先调用这个方法，可以在这个方法中控制是否加载url
 *
 *  @return YES:表示允许加载 NO:表示不允许加载
 */
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{

    NSString *urlStr = request.URL.absoluteString;
    WBLog(@"%@", urlStr);
    
    // 查找“code=”在urlStr中的范围
    NSRange range = [urlStr rangeOfString:@"code="];
    
    // 如果urlStr中包含了“code=”
//    if (range.location != -1){
    // 这两种判断方式都可以
    if (range.length > 0) {
        
        // 截取“code=”后面的字符串
        int location = range.location + range.length;
        NSString *code = [urlStr substringFromIndex:location];
        
        // 发送POST请求给新浪，用code换取access_token
        [self getAccessTokenByCode:code];
        
        // 不要显示回调界面
        return NO;
    }
    
    return YES;
}

/**
 *  用code换取access_token
 */
-(void)getAccessTokenByCode:(NSString *)code{
    
    // 1,封装请求参数
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"client_id"] = WBAppKey;
    params[@"client_secret"] = WBAppSecret;
    params[@"grant_type"] = WBGrantType;
    params[@"code"] = code;
    params[@"redirect_uri"] = WBRedirectUrl;
    
    // 2,发送请求
    [WBHttpTool postWithURL:@"https://api.weibo.com/oauth2/access_token" params:params success:^(id json) {
        
        NSDictionary *resultDict = (NSDictionary *)json;
        
        WBLog(@"%@--access_token:%@", @"请求成功", resultDict[@"access_token"]);
        
        
        // 字典转模型
        WBAccount *account = [WBAccount accountWithDict:resultDict];
        
        // 以上3句封装到工具类中:
        [WBAccountTool saveAccount:account];
        
        self.view.window.rootViewController = [[WBTabBarViewController alloc]init];
        
        /*****************************检查版本end*********************************************/
        
        // 隐藏提示框
        [MBProgressHUD hideHUD];
        
    } failure:^(NSError *error) {
        
        WBLog(@"%@", @"请求失败");
        
        // 隐藏提示框
        [MBProgressHUD hideHUD];
        
    }];
    
}

@end
