//
//  LoginViewController.m
//  AiEnglish
//
//  Created by kangGG on 17/2/16.
//  Copyright © 2017年 Kong....... All rights reserved.
//

#import "LoginViewController.h"
#import "RDVTabBarController.h"
#import "MeViewController.h"
#import "AFHTTPSessionManager.h"
@interface LoginViewController ()<UITextFieldDelegate>
@property(nonatomic,assign)NSInteger time;
@property(nonatomic,assign,getter=isStatus)BOOL status;
@property(nonatomic,strong)UIButton *button;
@property(nonatomic,strong)UIImageView *phoneImg;
@property(nonatomic,strong)UIImageView *codeImageView;

@end

@implementation LoginViewController

-(void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:animated];
    
    [self.rdv_tabBarController setTabBarHidden:YES];

}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createUI];
    self.status = 0;
    
}

-(void)createUI{
//手机号 左部视图
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    self.phoneImg = imgView;
    
    self.phoneField.leftView = imgView;
    
    imgView.image = [UIImage imageNamed:@"手机_30X30"];
    self.phoneField.leftViewMode = UITextFieldViewModeUnlessEditing;
        
    self.phoneField.delegate = self;
    
    self.phoneField.placeholder = @"请输入手机号码";
    self.phoneField.keyboardType = UIKeyboardTypeNumberPad;
//    右视图
    UIButton *btn = [UIButton buttonWithType: UIButtonTypeSystem];
    self.button = btn;
    
    btn.frame = CGRectMake(0, 0, 60, 30);
    [btn setTitle:@"获取验证码" forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:11];
    btn.layer.cornerRadius =5;
    btn.clipsToBounds = YES;
    
    [btn setBackgroundColor:[UIColor colorWithRed:51/255.0 green:204/255.0 blue:255/255.0 alpha:1]];
//    获取验证码
    [btn addTarget:self action:@selector(getNumber) forControlEvents:UIControlEventTouchUpInside];
    self.phoneField.rightView = btn;
    self.phoneField.rightViewMode = UITextFieldViewModeAlways;
//    验证码
    UIImageView *imgView1 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    self.codeImageView = imgView1;
    
    self.passField.leftView = imgView1;
    self.passField.delegate = self;
    
    imgView1.image = [UIImage imageNamed:@"验证码_30X30"];
    self.passField.leftViewMode = UITextFieldViewModeUnlessEditing;
    
    self.passField.placeholder = @"请输入验证码";
    self.passField.keyboardType = UIKeyboardTypeNumberPad;
    
    self.quitBtn.clipsToBounds = YES;
    self.quitBtn.layer.cornerRadius = 10;
    [self.quitBtn setTitle:@"X" forState:UIControlStateNormal];
    [self.quitBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.quitBtn setBackgroundColor:[UIColor colorWithRed:255/255.0 green:98/255.0 blue:89/255.0 alpha:1]];
}
-(void)textFieldDidBeginEditing:(UITextField *)textField{
    if (self.phoneField.isEditing) {
        
        self.phoneImg.image = [UIImage imageNamed:@"手机_icon_30X30"];
        self.phoneField.leftViewMode = UITextFieldViewModeAlways;
    }else{
    
        self.codeImageView.image = [UIImage imageNamed:@"验证码_icon_30X30"];
        self.passField.leftViewMode = UITextFieldViewModeAlways;
    }
    
}

-(void)textFieldDidEndEditing:(UITextField *)textField{
    self.phoneImg.image = [UIImage imageNamed:@"手机_30X30"];
    self.phoneField.leftViewMode = UITextFieldViewModeUnlessEditing;
    
    self.codeImageView.image = [UIImage imageNamed:@"验证码_30X30"];
    self.passField.leftViewMode = UITextFieldViewModeAlways;
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
// 获取验证码
-(void)getNumber{    
    //app.ekaola.com/app/phone_auth GET phone=XXXXX
    
    NSString *url = [NSString stringWithFormat:@"http://app.ekaola.com/app/phone_auth&phone=%@",self.phoneField.text];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    [manager GET:url parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSLog(@"%@",responseObject);
        NSDictionary *dict = responseObject;
        
        if ([dict[@"result"] isEqualToString:@"ok"]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.time = 60;
                [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerForBtn) userInfo:nil repeats:YES];
            });
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"error:%@",error.localizedDescription);
        
    }];
    
}
-(void)timerForBtn{
    
    [self.button setTitle:[NSString stringWithFormat:@"%ld",self.time]  forState:UIControlStateNormal];
    
    if (self.time>0) {
        
        self.time --;
    }
    
}
- (IBAction)quitBtn:(id)sender {
    
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
    
}
- (IBAction)loginBtn:(id)sender {

    //app.ekaola.com/app/login 登陆提交 POST telphone=XXX&code=XXX
    NSString *url = @"http://app.ekaola.com/app/login";
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    
    request.URL = [NSURL URLWithString:url];
    
    request.HTTPMethod = @"POST";
    request.HTTPBody = [[NSString stringWithFormat:@"telphone=%@&code=%@",self.phoneField.text,self.passField.text] dataUsingEncoding:NSUTF8StringEncoding];
    
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        if (error) {
            
        }else{
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
            

            if (dict[@"msg"]) {
                self.status = 0;
                dispatch_async(dispatch_get_main_queue(), ^{
                   
                    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"" message:dict[@"msg"] preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction *action = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
                    
                    [alertController addAction:action];
                    
                    
                    [self presentViewController:alertController animated:YES completion:nil];
                    
                });
            }else{
            
                self.status =dict[@"status"];
                NSLog(@"%d",self.status);
                
//                本地永久化存储
                NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
                
                [userDef setBool:self.status forKey:kStatus];
                
//                NSString *name = [userDef objectForKey:kName];
//                if (!name) {
                
                [userDef setObject:self.phoneField.text forKey:kName];
                
                
                [userDef synchronize];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [self dismissViewControllerAnimated:YES completion:nil];

                });
            }
            
        }
        
    }];
    
    [task resume];    
    
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
