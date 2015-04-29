//
//  WBComposeViewController.m
//  WeiBo
//
//  Created by Doublenian on 15/3/21.
//  Copyright (c) 2015年 com.doublenian. All rights reserved.
//

#import "WBComposeViewController.h"
#import "WBTextView.h"
#import "WBAccount.h"
#import "WBHttpTool.h"
#import "WBAccountTool.h"
#import "MBProgressHUD+MJ.h"
#import "WBComposeToolbar.h"
#import "WBComposePhotosView.h"

@interface WBComposeViewController ()<UITextViewDelegate, WBComposeToolbarDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (nonatomic, weak)WBTextView *textView;

@property (nonatomic, weak)WBComposeToolbar *toolbar;

@property (nonatomic, weak)WBComposePhotosView *photosView;

@end

@implementation WBComposeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // 设置控制器view的背景色
    self.view.backgroundColor = [UIColor whiteColor];
    
    // 设置导航条
    [self setupNavBar];
    
    // 添加textView
    [self setupTextView];
    
    // 添加toolbar(跟随键盘移动的工具条)
    [self setupToolbar];
    
    // 添加photosView
    [self setupPhotosView];
}

/**
 *  添加photosView
 */
- (void)setupPhotosView{

    WBComposePhotosView *photosView = [[WBComposePhotosView alloc] init];
    CGFloat photosW = self.textView.frame.size.width;
    CGFloat photosH = self.textView.frame.size.height;
    CGFloat photosY = 80;
    photosView.frame = CGRectMake(0, photosY, photosW, photosH);
    [self.textView addSubview:photosView];
    self.photosView = photosView;
    
}

/**
 *  添加toolbar
 */
- (void)setupToolbar{

    WBComposeToolbar *toolbar = [[WBComposeToolbar alloc] init];
    
    toolbar.delegate = self;
    
    CGFloat toolbarX = 0;
    CGFloat toolbarW = self.view.frame.size.width;
    CGFloat toolbarH = 44;
    CGFloat toolbarY = self.view.frame.size.height - toolbarH;
    
    toolbar.frame = CGRectMake(toolbarX, toolbarY, toolbarW, toolbarH);
    
    [self.view addSubview:toolbar];
    
    self.toolbar = toolbar;
}

#pragma mark -toolbar的代理方法
- (void)composeToolbar:(WBComposeToolbar *)toolbar didClickedButton:(WBComposeToolbarButtonType)buttonType{

    switch (buttonType) {
            
        case WBComposeToolbarButtonTypeCamera:// 相机
            
//            WBLog(@"相机");
            [self openCamera];
            break;
        
        case WBComposeToolbarButtonTypePicture:// 图库(相册)
            
//            WBLog(@"相册");
            [self openPhotoLibrary];
            break;
            
        default:
            break;
    }

}

/**
 *  打开照相机
 */
- (void)openCamera{
    
    // 图片选择控制器
    UIImagePickerController *ipc = [[UIImagePickerController alloc] init];
    
    ipc.sourceType = UIImagePickerControllerSourceTypeCamera;
    
    // 注意:UIImagePickerController的代理有两个:
    // UINavigationControllerDelegate, UIImagePickerControllerDelegate
    ipc.delegate = self;
    
    [self presentViewController:ipc animated:YES completion:nil];
}

/**
 *  打开相册
 */
- (void)openPhotoLibrary{

    // 图片选择控制器
    UIImagePickerController *ipc = [[UIImagePickerController alloc] init];
    
    ipc.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    // 注意:UIImagePickerController的代理有两个:
    // UINavigationControllerDelegate, UIImagePickerControllerDelegate
    ipc.delegate = self;
    
    [self presentViewController:ipc animated:YES completion:nil];
}

#pragma mark -图片选择控制器的代理方法
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{

    // 1.销毁picker控制器
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    // 2.取出图片
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    
    [self.photosView addImage:image];
    
    // 这里不需要判断图片是从相机来的，还是从图库(相册)来的，只要拿到图片就行了
    
}

/**
 *  设置导航条
 */
- (void)setupNavBar{

    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStyleDone target:self action:@selector(cancel)];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"发送" style:UIBarButtonItemStyleDone target:self action:@selector(send)];
    self.navigationItem.rightBarButtonItem.enabled = NO;
    
    self.title = @"发微博";
}

/**
 *  添加textView
 */
- (void)setupTextView{

    // 添加textView
    WBTextView *textView = [[WBTextView alloc] init];
    textView.font = [UIFont systemFontOfSize:15];
    textView.frame = self.view.bounds;
    
    textView.placeholder = @"分享新鲜事...";
    
    // 设置textView垂直方向可滑动
    textView.alwaysBounceVertical = YES;
    textView.delegate = self;
    
    [self.view addSubview:textView];
    
    self.textView = textView;
    
    // 监听textView的文字改变通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidChange) name:UITextViewTextDidChangeNotification object:textView];

    // 3.监听键盘的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

/**
 *  键盘即将显示的时候调用
 */
- (void)keyboardWillShow:(NSNotification *) notification{
    
    // 1.取出键盘的frame
    CGRect keyboardF = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    // 2.取出键盘弹出的时间
    CGFloat duration = [notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    // 3.执行动画
    [UIView animateWithDuration:duration animations:^{
        self.toolbar.transform = CGAffineTransformMakeTranslation(0, -keyboardF.size.height);
    }];
}

/**
 *  键盘即将退出的时候调用
 */
- (void)keyboardWillHide:(NSNotification *) notification{
    
    // 1.取出键盘弹出的时间
    CGFloat duration = [notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    // 2.执行动画
    [UIView animateWithDuration:duration animations:^{
        // textView恢复到原位置
        self.toolbar.transform = CGAffineTransformIdentity;
    }];
}

#pragma mark -textView的代理方法
/**
 *  当textView滑动的时候，需要隐藏键盘
 */
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    [self.view endEditing:YES];
}

- (void)textDidChange{

    self.navigationItem.rightBarButtonItem.enabled = (self.textView.text.length != 0);
}

- (void)viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:animated];
    
    // 自动弹出键盘
    [self.textView becomeFirstResponder];
}

/**
 *  发微博
 */
- (void)send{

    if (self.photosView.totalImages.count != 0) {
        
        // 发带有图片的微博
        [self sendWithImage];
    }else {
    
        // 发没有图片的微博
        [self sendWithoutImage];
    }
    
    
}

/**
 *  发带有图片的微博
 */
- (void)sendWithImage{

    // 1.封装请求参数
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"status"] = self.textView.text;
    params[@"access_token"] = [WBAccountTool getAccount].access_token;
    
    // 2.封装文件参数
    NSMutableArray *formDataArray = [NSMutableArray array];
    NSArray *images = [self.photosView totalImages];
    for (UIImage *image in images) {
        WBFormData *formData = [[WBFormData alloc] init];
        formData.data = UIImageJPEGRepresentation(image, 0.000001);
        formData.name = @"pic";
        formData.mimeType = @"image/jpeg";
        formData.filename = @"";
        [formDataArray addObject:formData];
    }
    
    // 3.发送请求
    [WBHttpTool postWithURL:@"https://upload.api.weibo.com/2/statuses/upload.json" params:params formDataArray:formDataArray success:^(id json) {
        [MBProgressHUD showSuccess:@"发送成功"];
    } failure:^(NSError *error) {
        [MBProgressHUD showError:@"发送失败"];
    }];
    
    // 4.关闭控制器
    [self dismissViewControllerAnimated:YES completion:nil];
}

/**
 *  发没有图片的微博
 */
- (void)sendWithoutImage{

    // 1.封装请求参数
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"status"] = self.textView.text;
    params[@"access_token"] = [WBAccountTool getAccount].access_token;
    
    // 2.发送请求
    [WBHttpTool postWithURL:@"https://api.weibo.com/2/statuses/update.json"  params:params success:^(id json) {
        [MBProgressHUD showSuccess:@"发送成功"];
    } failure:^(NSError *error) {
        [MBProgressHUD showError:@"发送失败"];
    }];
    
    // 3.关闭控制器
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

- (void)cancel{

//    WBLog(@"取消");
    
    [self.view endEditing:YES];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void)dealloc{
    
    // 移除监听
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
