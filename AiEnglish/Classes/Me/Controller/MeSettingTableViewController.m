//
//  MeSettingTableViewController.m
//  AiEnglish
//
//  Created by kangGG on 17/2/17.
//  Copyright © 2017年 Kong....... All rights reserved.
//

#import "MeSettingTableViewController.h"

#import "RootViewController.h"
#import "MeViewController.h"
#import "MeSettingOursViewController.h"

#import "UMSocialData.h"
#import "UMSocialSnsService.h"
#import "UMSocialSnsPlatformManager.h"
@interface MeSettingTableViewController ()<UMSocialUIDelegate>
@property(nonatomic,strong)NSMutableArray *dataArray;
@property(nonatomic,assign,getter=isStatus)BOOL status;

@end

@implementation MeSettingTableViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self.rdv_tabBarController setTabBarHidden:YES];

    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.dataArray = [NSMutableArray array];
    
    NSArray *array1 = @[@"推荐给好友"];
    NSArray *array2 = @[@"关于我们"];
    NSArray *array3 = @[@"退出登录"];

    [self.dataArray addObject:array1];
    [self.dataArray addObject:array2];
    [self.dataArray addObject:array3];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"setting"];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"setting" forIndexPath:indexPath];
    
    cell.textLabel.text = self.dataArray[indexPath.section][indexPath.row];
    
    cell.textLabel.font = [UIFont systemFontOfSize:13];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle = UITableViewCellSeparatorStyleNone;
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{

    return 20;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    if (indexPath.section==0) {//推荐给好友
        
        [UMSocialData defaultData].extConfig.wechatTimelineData.url = @"http://www.engua.com";
//      分享title
        [UMSocialData defaultData].extConfig.wechatTimelineData.title = @"爱英语";
        [UMSocialData defaultData].extConfig.wxMessageType = UMSocialWXMessageTypeApp;
        
        [UMSocialSnsService presentSnsIconSheetView:self appKey:@"wx1b008cf4b693f89e" shareText:@"分享" shareImage:[UIImage imageNamed:@"1"] shareToSnsNames:@[UMShareToWechatTimeline,UMShareToSina,] delegate:self];
        
    }else if(indexPath.section==1){//关于我们
        MeSettingOursViewController *ourVC = [[MeSettingOursViewController alloc] init];
        
        [self.navigationController pushViewController:ourVC animated:YES];
        
        
    }else{//退出登录
        UIAlertController *alertControl = [UIAlertController alertControllerWithTitle:@"" message:@"退出后不会删除任何历史数据" preferredStyle:UIAlertControllerStyleActionSheet];
        
        UIAlertAction *ok = [UIAlertAction actionWithTitle:@"确认退出" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
            
            self.status = [userDef objectForKey:kStatus];
            
            self.status = 0;
            
            [userDef setBool:self.status forKey:kStatus];
            
            [userDef synchronize];
            
            [alertControl dismissViewControllerAnimated:YES completion:nil];
            
            [self.navigationController popViewControllerAnimated:YES];
            

        }];
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        
        [alertControl addAction:ok];
        [alertControl addAction:cancel];
        
        [self presentViewController:alertControl animated:YES completion:nil];
        
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
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
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
