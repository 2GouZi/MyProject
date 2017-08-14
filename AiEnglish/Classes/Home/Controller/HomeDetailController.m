
//
//  HomeDetailController.m
//  AiEnglish
//
//  Created by kangGG on 16/7/11.
//  Copyright © 2016年 Kong....... All rights reserved.
//

#import "HomeDetailController.h"
#import "RootViewController.h"
#import "AFHTTPSessionManager.h"
#import "SenceModel.h"
#import "InfoModel.h"
#import "DetailCell.h"
#import "UIImageView+WebCache.h"
#import "HeaderCell.h"
#import "StudyViewController.h"
#import "WordViewController.h"
#import "MBProgressHUD.h"
#import "TestViewController.h"
@interface HomeDetailController ()<UIWebViewDelegate>
@property(nonatomic,strong)NSMutableArray *dataArray;
@property(nonatomic,strong)NSMutableArray *infoArray;

@end

@implementation HomeDetailController

-(NSMutableArray *)dataArray{
 
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
    
}
-(NSMutableArray *)infoArray{

    if (!_infoArray ) {
        _infoArray = [NSMutableArray array];
        
    }
    return _infoArray;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.tableView animated:YES];
    
    // Set the annular determinate mode to show task progress.
    hud.mode = MBProgressHUDModeAnnularDeterminate;
    hud.label.text = NSLocalizedString(@"Loading...", @"HUD loading title");
    
    dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), ^{
        // Do something useful in the background and update the HUD periodically.
        [self requestData];
        dispatch_async(dispatch_get_main_queue(), ^{
            [hud hideAnimated:YES];
        });
    });
    self.tableView.separatorStyle =UITableViewCellSeparatorStyleNone;
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.navigationItem.title = self.titleName;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"DetailCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"HeaderCell" bundle:nil] forCellReuseIdentifier:@"header"];
}
-(void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:animated];
    
    [self.rdv_tabBarController setTabBarHidden:YES];
    
}

-(void)requestData{
    
    NSString *url = @"http://app.ekaola.com/app/v2/get_pkg_detail?version=2";

    NSString *str = [NSString stringWithFormat:@"id=%@",self.uid];
        
    NSData *body = [str dataUsingEncoding:NSUTF8StringEncoding];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    
    request.URL = [NSURL URLWithString:url];
    request.HTTPBody = body;
    request.HTTPMethod = @"POST";
    
    NSURLSession *session = [NSURLSession sharedSession];

    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        if (error) {
            NSLog(@"error: %@",error.localizedDescription);
        }else{
    
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
//  头部数据
            NSDictionary *pkgdict = dict[@"pkgInfo"];
                        
            InfoModel *info = [[InfoModel alloc] init];
            
            [info setValuesForKeysWithDictionary:pkgdict];
                        
            [self.infoArray addObject:info];
//  cell数据
            NSArray *array  = dict[@"senceList"];
                        
            for (NSDictionary *dict in array) {
                                
                SenceModel *model = [[SenceModel alloc] init];
                
                [model setValuesForKeysWithDictionary:dict];
                
                [self.dataArray addObject:model];
            }
            
        }
        
        [self.tableView reloadData];
        
    }];
    
    [task resume];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count +self.infoArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row==0) {
    
        HeaderCell *cell = [tableView dequeueReusableCellWithIdentifier:@"header" forIndexPath:indexPath];
    
        cell.introWeb.delegate = self;
        
        cell.model = self.infoArray[0];
        
        return cell;
        
    }else{
        DetailCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
        cell.model =self.dataArray[indexPath.row -1];
        return cell;
    }
    
}
#pragma webViewDelegate
-(void)webViewDidFinishLoad:(UIWebView *)webView{

    [webView stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('p')[0].style.webkitTextSizeAdjust= '90%'"];
    [webView stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('p')[0].style.webkitTextFillColor= 'white'"];
    

}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    if (indexPath.row ==0) {
        return 150;
        
    }else{
    
        return 90;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    if (!(indexPath.row==0)) {
        
        
        SenceModel *model =self.dataArray[indexPath.row - 1];
        NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
        [userDef setObject:model.title forKey:kTitle];
        NSData *imgData = [NSKeyedArchiver archivedDataWithRootObject:model.cover];
        [userDef setObject:imgData forKey:kStudyImage];
        [userDef setObject:model.senceid forKey:kSenceid];
        [userDef setObject:self.titleName forKey:kTitleName];
        [userDef synchronize];

        
        if ([self.titleName containsString:@"课本点读"]) {//进入 课本点读界面
            StudyViewController *vc = [[StudyViewController alloc] init];
            
            vc.senceid = model.senceid;
            NSMutableData *data1 = [[NSMutableData alloc] init];
            NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data1];
            [archiver encodeObject:self.dataArray];
            [archiver finishEncoding];
            
            NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/category"];
            BOOL isOK = [data1 writeToFile:path atomically:YES];
            NSLog(@"%d",isOK);
            vc.categoryArray = self.dataArray;
            
            [self.navigationController pushViewController:vc animated:YES];
        }
        else if([self.titleName containsString:@"词汇练习"]){
        
            
                WordViewController *wordVC = [[WordViewController alloc] init];
                
                wordVC.senceid = model.senceid;
                
                [self.navigationController pushViewController:wordVC animated:YES];
                
            
            }
        else{// 进入配套练习界面
            
            TestViewController *testVc = [[TestViewController alloc] init];
            testVc.senceId = model.senceid;
            [self.navigationController pushViewController:testVc animated:YES];
            
            }
            
        
        
    }
    
    
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
