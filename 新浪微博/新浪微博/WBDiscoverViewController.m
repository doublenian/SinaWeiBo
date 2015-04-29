//
//  WBDiscoverViewController.m
//  WeiBo
//
//  Created by Doublenian on 15/3/21.
//  Copyright (c) 2015年 com.doublenian. All rights reserved.
//

#import "WBDiscoverViewController.h"
#import "UIImage+Extension.h"
#import "WBSearchBar.h"

@interface WBDiscoverViewController ()

@end

@implementation WBDiscoverViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    /*
    UITextField *tittleView = [[UITextField alloc] init];
    
    // 设置的背景
    tittleView.background = [UIImage resizedImageWithName:@"searchbar_textfield_background"];
    // 设置文字字体
    tittleView.font = [UIFont systemFontOfSize:13];
    
    UIImageView *iconView = [[UIImageView alloc] initWithImage:[UIImage imageWithName:@"searchbar_textfield_search_icon"]];
    // 居中显示
    iconView.contentMode = UIViewContentModeCenter;
    // 图片的尺寸
    iconView.frame = CGRectMake(0, 0, 30, 30);
    
    // 设置左边按钮的图片
    tittleView.leftView = iconView;
    // 设置左边按钮为显示
    tittleView.leftViewMode = UITextFieldViewModeAlways;
    
    // 设置右边的清空按钮为显示
    tittleView.clearButtonMode = UITextFieldViewModeAlways;
    
    // 设置提醒文字
    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
    attrs[NSForegroundColorAttributeName] = [UIColor grayColor];
    tittleView.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"搜索" attributes:attrs];
    
    // 设置键盘右下角按钮的样式
    tittleView.returnKeyType = UIReturnKeySearch;
    tittleView.enablesReturnKeyAutomatically = YES;
    
    tittleView.frame = CGRectMake(0, 0, self.view.frame.size.width, 30);
    
    self.navigationItem.titleView = tittleView;
    */
    
    // 以上代码可以使用自定义UITextField封装起来，方便以后复用
    
    WBSearchBar *searchBar = [WBSearchBar searchBar];
    
    searchBar.frame = CGRectMake(0, 0, 300, 35);
    
    // 设置导航条的中间部分
    self.navigationItem.titleView = searchBar;
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return 0;
}

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
