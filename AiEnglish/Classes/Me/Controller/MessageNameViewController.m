//
//  MessageNameViewController.m
//  AiEnglish
//
//  Created by kangGG on 17/2/16.
//  Copyright © 2017年 Kong....... All rights reserved.
//

#import "MessageNameViewController.h"
#import "RDVTabBarController.h"
@interface MessageNameViewController ()

@end

@implementation MessageNameViewController
-(void)viewWillAppear:(BOOL)animated{
    
    
    [super viewWillAppear:animated];
    
    [self.navigationController.navigationBar setHidden:NO];
    
    [self.rdv_tabBarController setTabBarHidden:YES];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];
    
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    
    
    self.nameField.text = [userDef objectForKey:kName];
    
    [self.saveBen setBackgroundColor:[UIColor colorWithRed:51/255.0 green:204/255.0 blue:255/255.0 alpha:1]];
    
    self.saveBen.layer.cornerRadius = 5;
    self.saveBen.clipsToBounds =YES;
    [self.saveBen setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
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

- (IBAction)saveClick:(id)sender {

    [self.navigationController popViewControllerAnimated:YES];
    
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    
    [userDef setObject:self.nameField.text forKey:kName];
    
    [userDef synchronize];
}
@end
