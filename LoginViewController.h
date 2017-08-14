//
//  LoginViewController.h
//  AiEnglish
//
//  Created by kangGG on 17/2/16.
//  Copyright © 2017年 Kong....... All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginViewController : UIViewController
- (IBAction)quitBtn:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *quitBtn;

@property (weak, nonatomic) IBOutlet UITextField *phoneField;
@property (weak, nonatomic) IBOutlet UITextField *passField;

- (IBAction)loginBtn:(id)sender;
@end
