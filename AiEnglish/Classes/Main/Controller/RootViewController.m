//
//  RootViewController.m
//  kangEnglish
//
//  Created by kangGG on 16/7/9.
//  Copyright © 2016年 Kong....... All rights reserved.
//

#import "RootViewController.h"
#import "RDVTabBarController.h"
#import "RDVTabBarItem.h"
@interface RootViewController ()

@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self createTabBar];
    
    [self createTabBarItem];
}

-(void)createTabBar{

    NSMutableArray *array = [NSMutableArray array];
    
    NSArray *viewC =@[@"HomeViewController",@"CourseViewController",@"MeViewController"];
    
    for (NSString *str  in viewC) {
        Class class = NSClassFromString(str);
        
        UIViewController *vc = [[class alloc] init];
        
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
        
        
        [array addObject:nav];
        
    }
    self.viewControllers = array;
    
}

-(void)createTabBarItem{
    NSArray *titles = @[@"首页",@"课程库",@"我"];
    NSArray *imgArray = @[@"首页_icon_1_60X60",@"首页_icon_2_60X60",@"首页_icon_3_60X60"];
    NSArray *seleImgArray = @[@"首页_1_icon_60X60",@"首页_2_icon_60X60",@"首页_3_icon_60X60"];
    NSInteger index = 0;
    

    for (RDVTabBarItem *item in self.tabBar.items) {
        
        NSString *selecName = [NSString stringWithFormat:@"%@",seleImgArray[index]];
        NSString *unseleName = [NSString stringWithFormat:@"%@",imgArray[index]];
        
        item.selectedTitleAttributes = @{NSFontAttributeName:[UIFont systemFontOfSize:9],NSForegroundColorAttributeName:[UIColor colorWithRed:24/255.0 green:167/255.0 blue:239/255.0 alpha:1]};
        
        
        item.unselectedTitleAttributes = @{NSFontAttributeName:[UIFont systemFontOfSize:9],NSForegroundColorAttributeName:[UIColor grayColor]};
        [item setFinishedSelectedImage:[UIImage imageNamed:selecName] withFinishedUnselectedImage:[UIImage imageNamed:unseleName]];
        
        item.title = titles[index];
        
    
        index ++;
        
    }
    
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
