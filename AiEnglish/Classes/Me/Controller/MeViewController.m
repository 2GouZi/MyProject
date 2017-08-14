//
//  MeViewController.m
//  kangEnglish
//
//  Created by kangGG on 16/7/9.
//  Copyright © 2016年 Kong....... All rights reserved.
//

#import "MeViewController.h"
#import "MeHeaderCell.h"
#import "RDVTabBarController.h"
#import "LoginViewController.h"
#import "MeMessageController.h"
#import "MeSettingTableViewController.h"
@interface MeViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)NSMutableArray *titles;
@property(nonatomic,strong)NSMutableArray *imgNames;

@property(nonatomic,strong)UITableView *tableView;

@property(nonatomic,strong)UIImage *headImg;
@property(nonatomic,strong)NSString *name;

//登陆状态
@property(nonatomic,assign,getter=isStatus)BOOL status;



@end

@implementation MeViewController

-(void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:animated];
    
    [self.navigationController.navigationBar setHidden:NO];
    
    [self.rdv_tabBarController setTabBarHidden:NO];
    
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    
    self.status =[userDef boolForKey:kStatus];
    
    NSLog(@"%d",self.status);
        
    if (self.status) {//登录
        self.name = [userDef objectForKey:kName];
        NSData *headerimg= [userDef objectForKey:kHeaderImage];
        self.headImg = [NSKeyedUnarchiver unarchiveObjectWithData:headerimg];
    }else{//退出
//        [userDef setObject:@"未登录" forKey:kName];
        
        NSData *header = [NSKeyedArchiver archivedDataWithRootObject:[UIImage imageNamed:@"1"]];
        [userDef setObject:header forKey:kHeaderImage];
        [userDef synchronize];
        
        self.name = @"未登录";
        
        NSData *headerimg= [userDef objectForKey:kHeaderImage];
        self.headImg = [NSKeyedUnarchiver unarchiveObjectWithData:headerimg];
    }

    [self.tableView reloadData];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"我";
    [self.tableView setSeparatorColor:[UIColor clearColor]];
    
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    
    NSString *name = [userDef objectForKey:kName];
    
    if (name) {//已经登录过的状态；
        self.name = [userDef objectForKey:kName];
        NSData *headerimg= [userDef objectForKey:kHeaderImage];
        self.headImg = [NSKeyedUnarchiver unarchiveObjectWithData:headerimg];
        

        
    }else{//name 没有值，表示是第一次登录。
        [userDef setObject:@"未登录" forKey:kName];
        NSData *header = [NSKeyedArchiver archivedDataWithRootObject:[UIImage imageNamed:@"1"]];
        [userDef setObject:header forKey:kHeaderImage];
        [userDef synchronize];
    }
    
    [self createUI];
    
    [self createData];
}
-(void)createUI{

    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) style:UITableViewStylePlain];
    
    self.tableView.delegate=self;
    self.tableView.dataSource =self;
    
    [self.view addSubview:self.tableView];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
//    注册cell
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"MeHeaderCell" bundle:nil] forCellReuseIdentifier:@"header"];
}
-(void)createData{
    NSArray *array1 = @[@"已下载课程",@"已购课程"];
    NSArray *array2 = @[@"设置"];
    NSArray *imgName1 = @[@"已下载_icon_60X60",@"已购_icon_60X60"];
    NSArray *ImgName2= @[@"设置_icon_60X60"];
    self.titles = [NSMutableArray array];
    self.imgNames = [NSMutableArray array];
    
    [self.titles addObject:array1];
    [self.titles addObject:array2];
    
    [self.imgNames addObject:imgName1];
    [self.imgNames addObject:ImgName2];
    
    
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{

    return 2;
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    if (section==0) {
        return [self.titles[section]count] +1;
    }else{
    
        return [self.titles[section]count];
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    if (indexPath.section==0&&indexPath.row==0) {
        MeHeaderCell *cell = [tableView dequeueReusableCellWithIdentifier:@"header" forIndexPath:indexPath];
        
        cell.headerImgView.image = self.headImg;
//        
        cell.nameLabel.text = self.name;
        
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle =UITableViewCellSelectionStyleNone;
        cell.nameLabel.font = [UIFont systemFontOfSize:15];
        return cell;
    }else{
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
        
        if (indexPath.section==0) {
            
            cell.textLabel.text = self.titles[indexPath.section][indexPath.row -1];
            cell.imageView.image = [UIImage imageNamed:self.imgNames[indexPath.section][indexPath.row -1]];
        }else{
            
            cell.textLabel.text = self.titles[indexPath.section][indexPath.row ];
            cell.imageView.image = [UIImage imageNamed:self.imgNames[indexPath.section][indexPath.row]];
    
        }
        cell.selectionStyle =UITableViewCellSelectionStyleNone;

        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.font = [UIFont systemFontOfSize:14];
        return cell;
    }
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//      已登录,点击修改昵称和头像
    
    if (self.isStatus) {
//        从永久化存储中取出
        NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
        self.name =[userDef objectForKey:kName];
        [self.tableView reloadData];
        if (indexPath.section==0&&indexPath.row==0) {
            MeMessageController *message = [[MeMessageController alloc] init];
            
            [self.navigationController pushViewController:message animated:YES];
        }else if (indexPath.section==1&&indexPath.row==0){
            MeSettingTableViewController *setting = [[MeSettingTableViewController alloc] init];
            [self.navigationController pushViewController:setting animated:YES];
        }
        
        
    }else{
//        未登录
        
        LoginViewController *logVC = [[LoginViewController alloc] init];
        
        [self presentViewController:logVC animated:YES completion:nil];
    
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    if (indexPath.section==0&&indexPath.row==0) {
        return 140;
    }else{
    
        return 44;
        
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    NSIndexPath *indexPath = [[NSIndexPath alloc]initWithIndex:section];
    if (0 == indexPath.section) {//第一组
        return 0;
    }else
        return 15;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
