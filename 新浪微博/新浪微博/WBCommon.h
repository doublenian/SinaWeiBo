// 账号相关
#define WBAppKey @"308549646"
#define WBAppSecret @"0bf947fc7a77874fca0e1c23e1a25bb1"
#define WBRedirectUrl @"http://"
#define WBGrantType @"authorization_code"

// 1.判断是否为iOS7
#define iOS7 ([[UIDevice currentDevice].systemVersion doubleValue] >= 7.0)

// 2.获得RGB颜色
#define WBColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]

// 3.自定义Log
#ifdef DEBUG
#define WBLog(...) NSLog(__VA_ARGS__)
#else
#define WBLog(...)
#endif

// 4.判断是否是4英寸屏幕
#define fourInch ([UIScreen mainScreen].bounds.size.height == 568)