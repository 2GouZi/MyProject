//
//  WordViewController.m
//  AiEnglish
//
//  Created by kangGG on 16/7/25.
//  Copyright © 2016年 Kong....... All rights reserved.
//

#import "WordViewController.h"
#import "GDataXMLNode.h"
#import "CardModel.h"
#import "UIImageView+WebCache.h"
#import <AVFoundation/AVFoundation.h>
#import "QuestionsModel.h"
#import "QuestionsViewController.h"
#import "RDVTabBarController.h"
@interface WordViewController ()<UIScrollViewDelegate>
@property(nonatomic,strong)NSMutableArray *dataArray;
//@property(nonatomic,strong)NSMutableArray *picArray;
@property(nonatomic,strong)NSMutableArray *cardArray;
@property(nonatomic,strong)AVPlayerItem *playItem;
@property(nonatomic,strong)AVPlayer *player;
@property(nonatomic,assign)NSInteger index;
@property(nonatomic,strong)UIScrollView *scrollView;
@property(nonatomic,strong)UIImageView *cardImageView;

@property(nonatomic,strong)QuestionsViewController *QuestionsVC;





@end

@implementation WordViewController

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    [self.rdv_tabBarController setTabBarHidden:YES];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithRed:51/255.0 green:204/255.0 blue:255/255.0 alpha:1];
    
//    self.front = YES;
    
  
    
    [self requestData];
}

-(void)createUI{
    _index = 0;

    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth  , kScreenHeight)];
    self.scrollView = scrollView;
    
    [self.view addSubview:scrollView];
    
    scrollView.bounces = NO;
    scrollView.pagingEnabled = YES;
    scrollView.contentSize = CGSizeMake(kScreenWidth * (_cardArray.count + 1), kScreenHeight -64);
    
    scrollView.delegate =self;
    for (int i = 0; i < self.cardArray.count; i ++) {
        
        CardModel *model = self.cardArray[i];
        
        UIImageView *cardImageView = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth * i + 20  , 20, kScreenWidth-40, kScreenHeight - 64 - 40)];
        
        cardImageView.tag = 100+i;
        
        cardImageView.userInteractionEnabled = YES;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapCard:)];
        
        [cardImageView addGestureRecognizer:tap];
        
        [cardImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://app.ekaola.com/%@",model.frontImgUrl]]];
        [scrollView addSubview: cardImageView];
        
    }
    
    QuestionsViewController *QuesVc = [[QuestionsViewController alloc] init];
    self.QuestionsVC = QuesVc;
    QuesVc.dataArray =self.dataArray;
    QuesVc.view.frame = CGRectMake(kScreenWidth * self. cardArray.count , 0, kScreenWidth, kScreenHeight - 64);
    [self.scrollView addSubview:QuesVc.view];
    CardModel *model = self.cardArray[_index];
    NSString *url = [NSString stringWithFormat:@"http://app.ekaola.com/%@",model.mp3Url];
    [self playVoice:url];
    
}

-(void)requestData{
    
    self.dataArray = [NSMutableArray array];
//    self.picArray = [NSMutableArray array];
    self.cardArray = [NSMutableArray array];

    NSString *url = [NSString stringWithFormat:@"http://app.ekaola.com/app/get_sence_json&pkgid=%@",self.senceid];

    NSURLSession *session = [NSURLSession sharedSession];
    
    NSURLSessionDataTask *dataTask = [session dataTaskWithURL:[NSURL URLWithString:url] completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
//        NSString *st = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSArray *rootArray = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
        for (NSDictionary *dict  in rootArray) {
            NSArray *array1 = dict[@"content"];
            NSDictionary *dict1 = array1[0];
            NSString *xml = dict1[@"content"];
//            NSLog(@"xml: %@",xml);
            NSRange range = [xml rangeOfString:@"\">"];
            if (range.length) {
                xml = [xml substringFromIndex:range.location +range.length];
                range = [xml rangeOfString:@"</div>"];
                xml = [xml substringToIndex:range.location];
            }
//            NSLog(@"xml ========%@",xml);
            NSData *divData = [xml dataUsingEncoding:NSUTF8StringEncoding];
            NSDictionary *rootDict = [NSJSONSerialization JSONObjectWithData:divData options:NSJSONReadingMutableLeaves error:nil];
            NSArray *testObjArray = rootDict[@"testObj"];
            for (NSDictionary *wordDict in testObjArray) {
//                model
                CardModel *model = [[CardModel alloc] init];
                NSDictionary *backDict = wordDict[@"back"];
                model.backImgUrl = backDict[@"imgUrl"];
                NSDictionary *frontDict = wordDict[@"front"];
                NSDictionary *audioDict = frontDict[@"audio"];
                model.mp3Url = audioDict[@"url"];
                model.front = YES;
                model.frontImgUrl = frontDict[@"imgUrl"];
                [self.cardArray addObject:model];
            }
            NSArray *dataArray1 = rootDict[@"data"];
            for (NSDictionary *dataDict in dataArray1) {
                NSString *ques = dataDict[@"ques"];
                if ([ques containsString:@"听录音，选出与所听内容相符合的图片。"]) {
                    QuestionsModel *model = [[QuestionsModel alloc] init];
                    model.ques = ques;
                    NSArray *keysArray = dataDict[@"keys"];
                    model.keysArray = keysArray;

                    NSDictionary *audioDict = dataDict[@"audio"];
                    NSString *mp3Url = audioDict[@"path"];
                    model.mp3url = mp3Url;
                    NSArray *choicesArray = dataDict[@"choices"];
                    if([choicesArray[0] isKindOfClass:[NSDictionary class]]){
                        NSMutableArray *picQuesArray = [NSMutableArray array];
                        if (choicesArray) {//题目：听录音，选出与所听内容相符合的图片。
                            for (NSDictionary *choicesDict in choicesArray) {
                                NSString *picUrl = choicesDict[@"url"];
                                [picQuesArray addObject:picUrl];
                                model.picArray =picQuesArray;
                            }
                        }
//                    [self.picArray addObject:picQuesArray];
                    }
                    [self.dataArray addObject:model];
 
                }else if ([ques containsString:@"选出不同类的一项。"]){
                    QuestionsModel *model = [[QuestionsModel alloc] init];
                    model.ques = ques;
                    NSArray *keysArray = dataDict[@"keys"];
                    model.keysArray = keysArray;

                    NSArray *choicesArray = dataDict[@"choices"];
                    if ([choicesArray[0] isKindOfClass:[NSString class]]) {//选出不同类的一项
                        model.chooiceArray = choicesArray;
                    }
                    [self.dataArray addObject:model];

                }else if ([ques containsString:@"配对题，"]){
                    QuestionsModel *model = [[QuestionsModel alloc] init];
                    model.ques = ques;
                    NSArray *baseImgArr = dataDict[@"baseImgArr"];
                    model.baseImgArr = baseImgArr;
                    NSArray *matchImgArr = dataDict[@"matchImgArr"];
                    model.matchImgArr = matchImgArr;
                    [self.dataArray addObject:model];

                }else if ([ques containsString:@"听写单词。"]){
                    QuestionsModel *model = [[QuestionsModel alloc] init];
                    model.ques = ques;
                    NSDictionary *audioDict = dataDict[@"audio"];
                    NSString *mp3Url = audioDict[@"path"];
                    model.mp3url = mp3Url;
                    NSArray *keysArray = dataDict[@"keys"];
                    model.keysArray = keysArray;
                    
                    [self.dataArray addObject:model];
                    
                }
                
            }
//            NSLog(@"%ld,",self.dataArray.count);
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self createUI];
        });
    }];
    
    [dataTask resume];
}

-(void)playVoice:(NSString *)url{
    
    if (self.playItem!=nil) {
        if (self.playItem.observationInfo) {
            [self.playItem removeObserver:self forKeyPath:@"status"];
        }
    }
    self.playItem = [[AVPlayerItem alloc] initWithURL:[NSURL URLWithString:url]];
    
    self.player = [[AVPlayer alloc] initWithPlayerItem:self.playItem];
    
    [self.playItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
    
}
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{

    if ([keyPath isEqualToString:@"status"]) {
        switch (self.playItem.status) {
            case AVPlayerItemStatusUnknown:
        break;
            case AVPlayerItemStatusReadyToPlay:
                
                [self.player play];
                break;
            case AVPlayerItemStatusFailed:
                break;
        }
    }
    
}

-(void)tapCard:(UITapGestureRecognizer *)sender {

    CardModel *model = self.cardArray[_index];
    
    UIImageView *imageView = (UIImageView *)sender.view;
    if (model.isFront) {
        [imageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://app.ekaola.com/%@",model.backImgUrl]]];
        CATransition *transition = [CATransition animation];
        transition.type = @"oglFlip";
        transition.subtype =kCATransitionFromLeft;
        transition.duration = 1;
        [imageView.layer addAnimation:transition forKey:nil];
        model.front = NO;
//        [self.cardArray replaceObjectAtIndex:_index withObject:model];
    }else{
        [imageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://app.ekaola.com/%@",model.frontImgUrl]]];
        CATransition *transition = [CATransition animation];
        transition.type = @"oglFlip";
        transition.subtype =kCATransitionFromRight;
        transition.duration = 1;
        [imageView.layer addAnimation:transition forKey:nil];
        NSString *url = [NSString stringWithFormat:@"http://app.ekaola.com/%@",model.mp3Url];
        [self performSelector:@selector(playVoice:) withObject:url afterDelay:1];
        model.front = YES;
//        [self.cardArray replaceObjectAtIndex:_index withObject:model];
    }
}
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{

//    NSInteger last = _index;
    
    if (scrollView.contentOffset.x / kScreenWidth != _index) {
        CardModel *lastModel = self.cardArray[_index];
        
        if (!lastModel.front) {
            NSString *url = [NSString stringWithFormat:@"http://app.ekaola.com/%@",lastModel.frontImgUrl];
            
            UIImageView *imgView = [self.view viewWithTag:100+_index];
            [imgView sd_setImageWithURL:[NSURL URLWithString:url]];
            lastModel.front = YES;
        }

        _index = scrollView.contentOffset.x / kScreenWidth;
        [self.player pause];
        if (_index < self.cardArray.count) {
            
            CardModel *model = self.cardArray[_index];
            NSString *url = [NSString stringWithFormat:@"http://app.ekaola.com/%@",model.mp3Url];
            [self playVoice:url];
        }else{

            [[NSNotificationCenter defaultCenter] postNotificationName:@"playVoice" object:nil userInfo:nil];
            
        }

    }
    
}

-(void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    
    if (self.playItem!=nil) {
        
        if (self.playItem.observationInfo) {
            
            [self.playItem removeObserver:self forKeyPath:@"status"];
        }
        self.playItem = nil;
    }
    
    [self.player pause];
    
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
