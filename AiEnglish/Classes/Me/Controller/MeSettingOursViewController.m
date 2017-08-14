//
//  MeSettingOursViewController.m
//  AiEnglish
//
//  Created by kangGG on 17/2/20.
//  Copyright © 2017年 Kong....... All rights reserved.
//

#import "MeSettingOursViewController.h"

@interface MeSettingOursViewController ()

@end

@implementation MeSettingOursViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUI];
    // Do any additional setup after loading the view from its nib.
}

-(void)setUI{

    self.phoneLabel.text = @"联系电话  010-57256764";
    self.emailLabel.text = @"联系邮箱  shanke@ekaola.com";
    self.iconImageView.image = [UIImage imageNamed:@"icon"];
    self.iconImageView.layer.borderWidth = 1;
    self.iconImageView.layer.borderColor = [UIColor blackColor].CGColor;
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
