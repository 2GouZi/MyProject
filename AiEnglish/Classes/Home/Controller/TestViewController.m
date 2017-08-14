//
//  TestViewController.m
//  AiEnglish
//
//  Created by kangGG on 16/8/8.
//  Copyright © 2016年 Kong....... All rights reserved.
//

#import "TestViewController.h"
#import "QuestionsModel.h"
#import <AVFoundation/AVFoundation.h>
#import "UIImageView+WebCache.h"
#import "QuestionsViewController.h"
@interface TestViewController ()

@property(nonatomic,strong)NSMutableArray *dataArray;

@property(nonatomic,strong)QuestionsViewController *quesVc;


//#define  kheight (self.bgView.bounds.size.height)
//#define  kwidth  self.bgView.bounds.size.width

@end

@implementation TestViewController

-(NSMutableArray *)dataArray{

    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    [self requestData];
    
    
    
}


-(void)createScrollView{

    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    
    [self.view addSubview:scrollView];
    
    scrollView.contentSize = CGSizeMake(kScreenWidth *self.dataArray.count, kScreenHeight - 64);
    
    [scrollView addSubview:self.quesVc.view];
    
    scrollView.backgroundColor = [UIColor cyanColor];
}

-(void)createSameUI{

    [self.quesVc createSameUI:self.dataArray.count];
    
    
    
}
-(void)createDeffirentUI{

    [self.quesVc createDifferentUI];
    
}

-(void)createCommitUI{

    [self.quesVc createCommitUI];
    
    
}

-(void)requestData{
    
    NSString *url = [NSString stringWithFormat:@"http://app.ekaola.com/app/get_sence_json&pkgid=%@",self.senceId];
    
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSURLSessionDataTask *dataTask = [session dataTaskWithURL:[NSURL URLWithString:url] completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
//        NSString *st = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        
//        NSLog(@"%@",st);
        NSArray *rootArray = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
        NSDictionary *dict  = rootArray[0];
        
        NSArray *array1 = dict[@"content"];
        NSDictionary *dict1 = array1[0];
        NSString *xml = dict1[@"content"];
        NSRange range = [xml rangeOfString:@"\">"];
        if (range.length) {
            xml = [xml substringFromIndex:range.location +range.length];
            range = [xml rangeOfString:@"</div>"];
            xml = [xml substringToIndex:range.location];
        }
//                    NSLog(@"xml ========%@",xml);
        NSData *divData = [xml dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *rootDict = [NSJSONSerialization JSONObjectWithData:divData options:NSJSONReadingMutableLeaves error:nil];
        NSArray *dataArray1 = rootDict[@"data"];

        for (NSDictionary *dataDict in dataArray1) {
            NSString *type = dataDict[@"type"];
            

            if ([type isEqualToString:@"img_matching"]) {
                
                QuestionsModel *model = [[QuestionsModel alloc] init];
                model.mp3url = dataDict[@"audio"][@"path"];
                model.baseImgArr =dataDict[@"baseImgArr"];
                model.matchImgArr = dataDict[@"matchImgArr"];
                model.ques = dataDict[@"ques"];
                model.type = dataDict[@"type"];
                
                [self.dataArray addObject:model];
                
            }else if ([type isEqualToString:@"simple_choose"]){
                NSArray *array = dataDict[@"choices"];
                
                if ([array[0] isKindOfClass:[NSString class]]) {
                    QuestionsModel *model = [[QuestionsModel alloc] init];
                    model.contentArr = array;
                    
                    model.mp3url = dataDict[@"audio"][@"path"];
                    model.chooiceArray = array;
                    model.keysArray = dataDict[@"keys"];
                    model.ques = dataDict[@"ques"];
                    model.type = dataDict[@"type"];

                    [self.dataArray addObject:model];

                }else if ([array[0] isKindOfClass:[NSDictionary class]]){
                    QuestionsModel *model = [[QuestionsModel alloc] init];
                    model.contentArr = array;
                    model.mp3url = dataDict[@"audio"][@"path"];
                    NSMutableArray *urlArray = [NSMutableArray array];
                    
                    for (NSDictionary *dic in array ) {
                        NSString *url = dic[@"url"];
                        [urlArray addObject:url];
                        
                    }
                    model.chooiceArray = urlArray;
                    model.keysArray = dataDict[@"keys"];
                    model.ques = dataDict[@"ques"];
                    model.type = dataDict[@"type"];

                    [self.dataArray addObject:model];

                }
                
//                model.picArray = dataDict[@""];
                
            }
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            self.quesVc = [[QuestionsViewController alloc] init];
            self.quesVc.dataArray  = self.dataArray;

//            [self createSameUI];
//            [self createDeffirentUI];
            
            [self.view addSubview:self.quesVc.view];
            
        });
    }];
    
    [dataTask resume];
}
-(void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear: animated];
    
    
//    if (self.quesVc.playItem!=nil) {
//        if (self.quesVc.playItem.observationInfo) {
//            [self.quesVc.playItem removeObserver:self forKeyPath:@"status"];
//        }
//    }
    if (self.quesVc.timer.isValid) {
        [self.quesVc.timer invalidate];
        self.quesVc.timer = nil;
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
