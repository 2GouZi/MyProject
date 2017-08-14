//
//  MessageNameViewController.h
//  AiEnglish
//
//  Created by kangGG on 17/2/16.
//  Copyright © 2017年 Kong....... All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MessageNameViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property (weak, nonatomic) IBOutlet UIButton *saveBen;

- (IBAction)saveClick:(id)sender;

@property(nonatomic,strong)NSString *name;

@property(nonatomic,strong)void(^Newname)(NSString *name);
@end
