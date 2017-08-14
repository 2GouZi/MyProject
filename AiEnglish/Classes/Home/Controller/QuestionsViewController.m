//
//  QuestionsViewController.m
//  AiEnglish
//
//  Created by kangGG on 16/7/27.
//  Copyright © 2016年 Kong....... All rights reserved.
//

#import "QuestionsViewController.h"
//#import "Masonry.h"
#import "QuestionsModel.h"
#import "UIImageView+WebCache.h"
#import <AVFoundation/AVFoundation.h>
#import "BaseImageView.h"
#import "MatchImageView.h"
#import "MBProgressHUD.h"
#import "ProgressView.h"

#import "UMSocialData.h"
#import "UMSocialSnsService.h"
#import "UMSocialSnsPlatformManager.h"
#import "MBProgressHUD.h"
@interface QuestionsViewController ()<UITextFieldDelegate,UIScrollViewDelegate,UMSocialUIDelegate>

@property(nonatomic,assign)NSInteger index;
@property(nonatomic,assign)NSInteger time;
@property(nonatomic,strong)UILabel *labelA;

@property(nonatomic,strong)UIProgressView *progressView;
@property(nonatomic,strong)UIButton *playAgainBtn;
@property(nonatomic,strong)UIButton *nextBtn;
@property(nonatomic,strong)UILabel *QuestionLabel;
//@property(nonatomic,strong)UIButton *btn;

//截图 图片
@property(nonatomic,strong)NSMutableArray *imgArray;
@property(nonatomic,strong)BaseImageView *baseImageView;
@property(nonatomic,strong)MatchImageView *matchImageView;

/*
 *题目是否已经完成
 */
@property(nonatomic,assign,getter=isFnished)BOOL finished;
/*
 *是否是查看结果状态
 */
@property(nonatomic,assign,getter=isCheck)BOOL check;
/*
 *答案
 */
@property(nonatomic,assign)NSInteger answer;
@property(nonatomic,strong)NSString *answerWord;
@property(nonatomic,assign)NSInteger scores;
@property(nonatomic,strong)NSMutableArray *scoresArray;


@property(nonatomic,strong)NSMutableArray *baseRectArray;
@property(nonatomic,strong)NSMutableArray *matchStarRectArray;
//记录答案
@property(nonatomic,strong)NSMutableArray *answerArray;
@property(nonatomic,assign)BOOL trues;



@property(nonatomic,strong)NSMutableArray *tagArray;
@property(nonatomic,assign)NSInteger tagIndex;



/*
*拖动的imageview停止时 是否在baseImageview的范围内
*/
@property(nonatomic,assign,getter=isRect)BOOL rect;

#define  kheight (self.bgView.bounds.size.height)
#define  kwidth  self.bgView.bounds.size.width

@end

@implementation QuestionsViewController

-(NSMutableArray *)answerArray{

    if (_answerArray ==nil) {
        _answerArray = [[NSMutableArray alloc] init];
        
    }
    return _answerArray;
}
-(NSMutableArray *)scoresArray{

    if (_scoresArray ==nil) {
        _scoresArray = [[NSMutableArray alloc] init];
        
    }
    return _scoresArray;
}

-(void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:animated];
}

- (void)viewDidLoad{
    [super viewDidLoad];
    self.imgArray = [NSMutableArray array];
    self.index = 0;
    self.check = NO;
    self.answer = 0;
    self.scores = 0;
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.bgView = [[UIView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:self.bgView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(readyPlay) name:@"playVoice" object:nil];
    
    [self createSameUI:self.dataArray.count];
    [self createDifferentUI];

}



-(void)createSameUI:(NSInteger)count{
    self.finished = NO;
    CGFloat padding = 20;
//progressView
    UIProgressView *progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(padding, padding, kwidth -4*padding-5, 10)];
    self.progressView = progressView;
    progressView.progress = (1.0 +_index)/count;
    progressView.progressTintColor = [UIColor colorWithRed:51/255.0 green:204/255.0 blue:1.0 alpha:1];
    progressView.trackTintColor = [UIColor grayColor];
    [self.bgView addSubview:progressView];
//progressLabel
    UILabel *progressLabel = [[UILabel alloc] initWithFrame:CGRectMake(kwidth - 3*padding, padding-10, 2 *padding, padding)];
    NSString *str = [NSString stringWithFormat:@"%ld/%ld",_index + 1,count];
    progressLabel.font = [UIFont systemFontOfSize:9];
    progressLabel.text =str;
    progressLabel.textAlignment = NSTextAlignmentCenter;
    [self.bgView addSubview:progressLabel];
//  下一题
    UIButton *nextBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    nextBtn.frame = CGRectMake(padding, kheight - padding -64-30, kwidth - 2 *padding, 30);
    self.nextBtn = nextBtn;
    nextBtn.autoresizesSubviews = YES;
    [self.bgView addSubview:nextBtn];
    [nextBtn addTarget:self action:@selector(nextQuestion:) forControlEvents:UIControlEventTouchUpInside];
    if (self.index ==self.dataArray.count - 1) {
        [nextBtn setTitle:@"提交" forState:UIControlStateNormal];
    }else{
    
        [nextBtn setTitle:@"下一题" forState:UIControlStateNormal];
    }
    [nextBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [nextBtn setBackgroundColor:[UIColor colorWithRed:51/255.0 green:204/255.0 blue:1.0 alpha:1]];
    
}

-(void)createDifferentUI{

    QuestionsModel *model = self.dataArray[_index];
    CGFloat padding = 20;
    NSString *question = model.ques;
    
    //第一题
    if ([question containsString:@"选出与所听内容"]||[model.contentArr[0] isKindOfClass:[NSDictionary class] ]) {
        //playBtn
        UIButton *playBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        playBtn.frame = CGRectMake(padding, 2*padding +5, padding, padding);
        self.playAgainBtn = playBtn;
        [self.bgView addSubview:playBtn];
        UIImage *image = [UIImage imageNamed:@"player"];
        [playBtn setImage:[image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
        [playBtn addTarget:self action:@selector(playAgain:) forControlEvents:UIControlEventTouchUpInside];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(padding, 2*padding +5, padding, padding)];
        label.backgroundColor = [UIColor blackColor];
        label.tag = 3;
        label.alpha = 0.5;
        label.hidden = NO;
        label.clipsToBounds = YES;
        label.layer.cornerRadius =10;
        [self.bgView addSubview:label];
        
        //questionLabel
        UILabel *quesLabel = [[UILabel alloc] initWithFrame:CGRectMake(2*padding +5, 2*padding +5, kwidth - 3 *padding-5, padding)];
        self.QuestionLabel = quesLabel;
        [self.bgView addSubview:quesLabel];
        quesLabel.text =model.ques;
        quesLabel.font = [UIFont systemFontOfSize:13];
        
        NSMutableArray *array = [NSMutableArray array];
        NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
        NSString *title = [userDef objectForKey:kTitleName];
        if ([title containsString:@"配套练习"]) {
            array = [NSMutableArray arrayWithArray:model.chooiceArray];
        }else if([title containsString:@"词汇练习"]){
            array =[NSMutableArray arrayWithArray:model.picArray];
            
        }

        if (self.isCheck) {
            
            for (int i= 0; i < array.count; i ++) {
                UIImageView *imgView =  [[UIImageView alloc] initWithFrame:CGRectMake((i %2) *((kwidth - 3 *padding)/2 +padding) + padding , (i/2) *((kwidth - 3*padding)/2 + 3 * padding) + 4*padding, (kwidth - 3*padding)/2, (kwidth - 3*padding)/2)];
                imgView.tag = 10 + i;
                imgView.clipsToBounds  = YES;
                imgView.layer.cornerRadius = 5;
                imgView.layer.borderColor = [UIColor grayColor].CGColor;
                imgView.layer.borderWidth = 4;
                [self.bgView addSubview:imgView];
                NSString *url1 = [NSString stringWithFormat:@"http://app.ekaola.com/%@",array[i]];
                [imgView sd_setImageWithURL:[NSURL URLWithString:url1]];
                
                UIImageView *ansView = [[UIImageView alloc] initWithFrame:CGRectMake( i%2*((kwidth - 3*padding)/2 +padding) + ((kwidth - 3*padding)/2 - padding ), 4*padding + i/2 *(kwidth - 3*padding)/2 + (kwidth - 3*padding)/2, 2*padding, 2*padding)];
                ansView.clipsToBounds = YES;
                ansView.tag = 200 +i;
                ansView.layer.cornerRadius = padding;
                [self.bgView addSubview:ansView];
                

            }
            
        }else{
        
            //imageview1
            
            for (int i = 0; i <array.count; i ++) {
                
                UIImageView *imageView1 = [[UIImageView alloc] initWithFrame:CGRectMake((i%2) *((kwidth - 3 *padding)/2 +padding) + padding ,(i/2) *((kwidth - 3*padding)/2 +padding)+4*padding, (kwidth - 3*padding)/2, (kwidth - 3*padding)/2)];
                imageView1.tag = 10 + i;
                imageView1.userInteractionEnabled =YES;
                imageView1.clipsToBounds = YES;
                imageView1.layer.cornerRadius = 5;
                imageView1.layer.borderColor = [UIColor grayColor].CGColor;
                imageView1.layer.borderWidth = 4;
                [self.bgView addSubview:imageView1];
                NSString *url1 = [NSString stringWithFormat:@"http://app.ekaola.com/%@",array[i]];
                [imageView1 sd_setImageWithURL:[NSURL URLWithString:url1]];
                UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImageView:)];
                [imageView1 addGestureRecognizer:tap1];
            }
        }
        
    }
    //第二题
    else if ([question containsString:@"配对题"]||[question containsString:@"图片排序"]||[model.ques containsString:@"连接起来"]){
        
        if ([question containsString:@"听录音"]) {
            //playBtn
            UIButton *playBtn = [UIButton buttonWithType:UIButtonTypeSystem];
            playBtn.frame = CGRectMake(padding, 2*padding +5, padding, padding);
            self.playAgainBtn = playBtn;
            [self.bgView addSubview:playBtn];
            UIImage *image = [UIImage imageNamed:@"player"];
            [playBtn setImage:[image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
            [playBtn addTarget:self action:@selector(playAgain:) forControlEvents:UIControlEventTouchUpInside];
            
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(padding, 2*padding +5, padding, padding)];
            label.backgroundColor = [UIColor blackColor];
            label.tag = 3;
            label.alpha = 0.5;
            label.hidden = NO;
            label.clipsToBounds = YES;
            label.layer.cornerRadius =10;
            [self.bgView addSubview:label];
            
            //questionLabel
            UILabel *quesLabel = [[UILabel alloc] initWithFrame:CGRectMake(2*padding +5, 2*padding +5, kwidth - 3 *padding-5, padding)];
            self.QuestionLabel = quesLabel;
            [self.bgView addSubview:quesLabel];
            quesLabel.text =model.ques;
            quesLabel.font = [UIFont systemFontOfSize:13];
        }else{
        
            //questionLabel
            
            UILabel *quesLabel = [[UILabel alloc] initWithFrame:CGRectMake(padding, 2*padding +5, kwidth - 2*padding, padding)];
            self.QuestionLabel = quesLabel;
            [self.bgView addSubview:quesLabel];
            quesLabel.text =model.ques;
            quesLabel.font = [UIFont systemFontOfSize:13];
        }
        //baseImageView
        self.baseRectArray = [NSMutableArray array];
        self.matchStarRectArray = [NSMutableArray array];
        
        CGFloat width = (kheight -90 - 64 - 30-70)/4 *5/4;
        CGFloat height = (kheight -90 - 64 - 30-70)/4;
        
        //查看结果界面
        if (self.isCheck) {
            for (int i = 0; i < model.baseImgArr.count; i ++) {
                BaseImageView *baseImageView = [[BaseImageView alloc] initWithFrame:CGRectMake(padding *2, 90 + i*(padding/2 +height), width, height)];
                [self.bgView addSubview:baseImageView];
                [baseImageView changeSmallAndRotateNoAnimatin];
                NSString *url = [NSString stringWithFormat:@"http://app.ekaola.com/%@",model.baseImgArr[i]];
                [baseImageView sd_setImageWithURL:[NSURL URLWithString:url]];
                CGPoint point = baseImageView.center;
                [self.baseRectArray addObject:[NSValue valueWithCGPoint:point]];

            }
            for (int i = 0; i < model.matchImgArr.count; i ++) {
                NSLog(@" aa: %ld,",model.matchImgArr.count);
                
                //匹配的位置。
                MatchImageView *matchImageView = [[MatchImageView alloc] initWithFrame:CGRectMake(kwidth - 2*padding - ((kheight -90 - 64 -90-70 - 20)/4 *5/4), 100 + i *(10 + height ),width -20,height - 20)];
                [self.bgView addSubview:matchImageView];
                [matchImageView changeSmallAndRotateNoAnimatin];
                CGPoint baseCenter = [self.baseRectArray[i]CGPointValue];
                matchImageView.center =CGPointMake( 0.9*(baseCenter.x + 0.5*width), 0.9 *(baseCenter.y +0.5*height) );
                
                NSInteger tag = [self.tagArray[i] intValue];
                
                NSString *url = [NSString stringWithFormat:@"http://app.ekaola.com/%@",model.matchImgArr[tag - 30]];
                [matchImageView sd_setImageWithURL:[NSURL URLWithString:url]];
                
                //答案的位置。
                MatchImageView *answerMatch = [[MatchImageView alloc] initWithFrame:CGRectMake(kwidth - 2*padding - ((kheight -90 - 64 -90-70 - 20)/4 *5/4), 100 + i *(10 + height ),width -20,height - 20)];
                [self.bgView addSubview:answerMatch];
                NSString *ansUrl = [NSString stringWithFormat:@"http://app.ekaola.com/%@",model.matchImgArr[i]];
                [answerMatch sd_setImageWithURL:[NSURL URLWithString:ansUrl]];
                
                UIImageView *ansView = [[UIImageView alloc] initWithFrame:CGRectMake(width +2*padding, 90 +i * (padding  +height), padding, padding)];
                ansView.tag =400+ i;
                [self.bgView addSubview:ansView];

            }

        }else{
            
            self.tagArray = [NSMutableArray array];
            for (int i = 0; i < model.baseImgArr.count; i ++) {
                BaseImageView *baseImageView = [[BaseImageView alloc] initWithFrame:CGRectMake(padding *2, 90 + i*(padding/2 +height), width, height)];
                baseImageView.tag = 40+i;
                [self.bgView addSubview:baseImageView];
                NSString *url = [NSString stringWithFormat:@"http://app.ekaola.com/%@",model.baseImgArr[i]];
                [baseImageView sd_setImageWithURL:[NSURL URLWithString:url]];
                CGRect rect = baseImageView.frame;
                [self.baseRectArray addObject:[NSValue valueWithCGRect:rect]];
                //给tagArray 挖四个坑
                NSInteger tag = 0;
                NSNumber *num = [NSNumber numberWithInteger:tag];
                [self.tagArray addObject:num];
                
                NSLog(@"count: %ld",self.tagArray.count);
            }
            //grayView
            
            for (int i = 0; i < model.matchImgArr.count; i ++) {
                UIView *bView = [[UIView alloc] initWithFrame:CGRectMake(kwidth - 2*padding - ((kheight -90 - 64 -90-70 - 20)/4 *5/4), 100 +i *(10 +height),width - 20,height -20)];
                bView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
                bView.clipsToBounds = YES;
                bView.layer.cornerRadius = 10;
                [self.bgView addSubview:bView];

            }
            //matchImageVeiw
            NSMutableArray *array =[NSMutableArray array];
            for (int i = 0; i < model.matchImgArr.count; i ++) {
                [array addObject:@(i)];
            }
            NSInteger count = model.matchImgArr.count;
            for (int i = 0; i < model.matchImgArr.count; i ++) {
                NSInteger dx = arc4random() %count;
                count--;
                MatchImageView *matchImageView = [[MatchImageView alloc] initWithFrame:CGRectMake(kwidth - 2*padding - ((kheight -90 - 64 -90-70 - 20)/4 *5/4), 100 + [array[dx] intValue] *(10 + height ),width -20,height - 20)];
                [self.bgView addSubview:matchImageView];
                matchImageView.userInteractionEnabled = YES;
                matchImageView.tag = 30+i;
                [array removeObjectAtIndex:dx];
                NSString *url = [NSString stringWithFormat:@"http://app.ekaola.com/%@",model.matchImgArr[i]];
                [matchImageView sd_setImageWithURL:[NSURL URLWithString:url]];
                UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panImageView:)];
                [matchImageView addGestureRecognizer:pan];
                CGPoint point = matchImageView.center;
                [self.matchStarRectArray addObject:[NSValue valueWithCGPoint:point]];
                
            }
        }

    }
    //第三题
    else if ([question containsString:@"选出不同类的一项。"]||([model.contentArr[0] isKindOfClass:[NSString class]]&& ![question containsString:@"听录音"])){
        
        //questionLabel
        UILabel *quesLabel = [[UILabel alloc] initWithFrame:CGRectMake(padding, 2*padding +5, kwidth - 2*padding, padding)];
        self.QuestionLabel = quesLabel;
        [self.bgView addSubview:quesLabel];
        
        quesLabel.text =model.ques;
        quesLabel.font = [UIFont systemFontOfSize:13];
    
        for (int i = 0; i < model.chooiceArray.count; i ++) {
            UILabel *labelA = [[UILabel alloc] initWithFrame:CGRectMake(padding, 70 + i *(30 + padding), kwidth - 2*padding, 30)];
            [self.bgView addSubview:labelA];
            labelA.tag = 50 + i;
            labelA.userInteractionEnabled = YES;
            labelA.clipsToBounds = YES;
            labelA.layer.cornerRadius = 3;
            labelA.text = model.chooiceArray[i];
            labelA.textColor = [UIColor whiteColor];
            labelA.textAlignment = NSTextAlignmentCenter;
            labelA.backgroundColor = [UIColor grayColor];
            if (!self.isCheck) {
                UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapLabel:)];
                [labelA addGestureRecognizer:tap];
                
            }
            UIImageView *ansView = [[UIImageView alloc] initWithFrame:CGRectMake(kwidth - 3*padding, 70 +i * (30 + padding), 30, 30)];
//            ansView.backgroundColor = [UIColor redColor];
            [self.bgView addSubview:ansView];
            ansView.clipsToBounds = YES;
            ansView.tag = 300 +i;
            ansView.layer.cornerRadius = 15;
   
        }
        
    }
    //第四题
    else if ([question containsString:@"听写单词。"]){

        if (self.isCheck) {
            for (int i = 0; i < 2; i ++) {
                UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(2 *padding , 80 + i*(7 * padding ), kwidth - 4*padding , 5 *padding)];
                label.tag = 500+i;
                [self.bgView addSubview:label];
                label.clipsToBounds = YES;
                label.layer.borderWidth = 1;
                label.layer.borderColor = [UIColor colorWithRed:51/255.0 green:204/255.0 blue:1.0 alpha:1].CGColor;
                label.layer.cornerRadius = 10;

            }
            UIImageView *ansView = [[UIImageView alloc] initWithFrame:CGRectMake((kwidth - padding)/2, 9 *padding, padding, padding)];
            [self.bgView addSubview:ansView];
            ansView.tag = 503;
            
            
        }else{
            //textField
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(2 *padding , 80, kwidth - 4*padding , 5 *padding)];
            [self.bgView addSubview:label];
            label.clipsToBounds = YES;
            label.userInteractionEnabled = YES;
            label.layer.borderWidth = 1;
            label.layer.borderColor = [UIColor colorWithRed:51/255.0 green:204/255.0 blue:1.0 alpha:1].CGColor;
            label.layer.cornerRadius = 10;
            
            UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(10, 0, kwidth - 4*padding , 2 *padding)];
            [label addSubview:textField];
            
            textField.borderStyle = UITextBorderStyleNone;
            textField.placeholder = @"example：Hello";
            textField.delegate =self;
 
        }
        
        //playBtn
        UIButton *playBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        playBtn.frame = CGRectMake(padding, 2*padding +5, padding, padding);
        
        self.playAgainBtn = playBtn;
        [self.bgView addSubview:playBtn];
        UIImage *image = [UIImage imageNamed:@"player"];
        [playBtn setImage:[image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
        [playBtn addTarget:self action:@selector(playAgain:) forControlEvents:UIControlEventTouchUpInside];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(padding, 2*padding +5, padding, padding)];
        label.backgroundColor = [UIColor blackColor];
        label.tag = 3;
        label.alpha = 0.5;
        label.hidden = NO;
        label.clipsToBounds = YES;
        label.layer.cornerRadius =10;
        [self.bgView addSubview:label];
        //questionLabel
        UILabel *quesLabel = [[UILabel alloc] initWithFrame:CGRectMake(2*padding +5, 2*padding +5, kwidth - 3 *padding-5, padding)];
        self.QuestionLabel = quesLabel;
        [self.bgView addSubview:quesLabel];
        
        quesLabel.text =model.ques;
        quesLabel.font = [UIFont systemFontOfSize:13];
        
        
    }
    //第五题
    else if ([question containsString:@"选出你听到的内容"]||([model.contentArr[0] isKindOfClass:[NSString class]]&&[question containsString:@"听录音"]) ){
        UIButton *playBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        playBtn.frame = CGRectMake(padding, 2*padding +5, padding, padding);
        self.playAgainBtn = playBtn;
        [self.bgView addSubview:playBtn];
        UIImage *image = [UIImage imageNamed:@"player"];
        [playBtn setImage:[image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
        [playBtn addTarget:self action:@selector(playAgain:) forControlEvents:UIControlEventTouchUpInside];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(padding, 2*padding +5, padding, padding)];
        label.backgroundColor = [UIColor blackColor];
        label.tag = 3;
        label.alpha = 0.5;
        label.hidden = NO;
        label.clipsToBounds = YES;
        label.layer.cornerRadius =10;
        
        [self.bgView addSubview:label];
        //questionLabel
        UILabel *quesLabel = [[UILabel alloc] initWithFrame:CGRectMake(2*padding +5, 2*padding +5, kwidth - 3 *padding-5, padding)];
        self.QuestionLabel = quesLabel;
        [self.bgView addSubview:quesLabel];
        
        quesLabel.text =model.ques;
        quesLabel.font = [UIFont systemFontOfSize:13];
        
        for (int i = 0; i < model.chooiceArray.count; i ++) {
            UILabel *labelA = [[UILabel alloc] initWithFrame:CGRectMake(padding, 70 + i *(30 + padding), kwidth - 2*padding, 30)];
            [self.bgView addSubview:labelA];
            labelA.tag = 1000 + i;
            labelA.userInteractionEnabled = YES;
            labelA.clipsToBounds = YES;
            labelA.layer.cornerRadius = 3;
            labelA.text = model.chooiceArray[i];
            labelA.textColor = [UIColor whiteColor];
            labelA.textAlignment = NSTextAlignmentCenter;
            labelA.backgroundColor = [UIColor grayColor];
            if (!self.isCheck) {
                UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapLabelB:)];
                [labelA addGestureRecognizer:tap];
            }
            UIImageView *ansView = [[UIImageView alloc] initWithFrame:CGRectMake(kwidth - 3*padding, 70 +i * (30 + padding), 30, 30)];
            //            ansView.backgroundColor = [UIColor redColor];
            [self.bgView addSubview:ansView];
            ansView.clipsToBounds = YES;
            ansView.tag = 3000 +i;
            ansView.layer.cornerRadius = 15;
        
            
            
        }
        

    }
    
}

-(void)createCommitUI{
    CGFloat padding = 20;
    CGFloat margin =  10;
    self.view.backgroundColor = [UIColor whiteColor];
    ProgressView *progressView = [[ProgressView alloc] initWithFrame:CGRectMake((kScreenWidth - 100)/2, 3*padding, 100, 100)];
    [self.view addSubview:progressView];
    progressView.arcFinishColor = [UIColor redColor];
    progressView.arcUnfinishColor = [UIColor colorWithRed:51/255.0 green:204/255.0 blue:1.0 alpha:1];
    progressView.arcBackColor = [UIColor grayColor];
    float score = (float)self.scoresArray.count;
    NSInteger count = self.dataArray.count;
    progressView.percent = score / count;
    
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake((kScreenWidth - 30)/2, 40, 30, 60)];
    [self.view addSubview:imgView];
    imgView.image = [UIImage imageNamed:@"综合练习"];
    
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    NSString *name = [userDef objectForKey:kName];
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(padding, 200, kScreenWidth - 2*padding, padding)];
    [self.view addSubview:nameLabel];
    nameLabel.text = [NSString stringWithFormat:@"%@同学",name];
    nameLabel.font = [UIFont systemFontOfSize:14];
    nameLabel.textAlignment = NSTextAlignmentCenter;
    for (int i = 0; i < 3;  i ++) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(padding, 240 + i * (padding +margin), kScreenWidth - 2*padding, padding)];
        [self.view addSubview: label];
        
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize: 11];
//        label.text =@"你的得分:";

        if (i ==0) {
            label.text = [NSString stringWithFormat:@"你的得分:"];

        }else if (i ==1){
            label.text = [NSString stringWithFormat:@"做对了%.0f 道题",score];
            NSMutableAttributedString *attributString = [[NSMutableAttributedString alloc] initWithString:label.text];
            [attributString addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(3, 1)];
            [attributString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15] range:NSMakeRange(3, 1)];

            label.attributedText = attributString;

        }else{
            label.text = [NSString stringWithFormat:@"做错了%.0f 道题",count - score];
            NSMutableAttributedString *attributString = [[NSMutableAttributedString alloc] initWithString:label.text];
            [attributString addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(3, 1)];
            [attributString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15] range:NSMakeRange(3, 1)];

            label.attributedText = attributString;
        }

    }
    //查看练习答案
    UIButton *answerBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.view addSubview:answerBtn];
    answerBtn.clipsToBounds = YES;
    answerBtn.layer.borderWidth = 1;
    answerBtn.layer.borderColor = [UIColor blackColor].CGColor;
    answerBtn.layer.cornerRadius = 3;
    [answerBtn setTitle:@"查看练习答案" forState:UIControlStateNormal];
    [answerBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    answerBtn.frame = CGRectMake(100, 360, kScreenWidth - 200, padding +margin);
    [answerBtn addTarget:self action:@selector(checkAnswer) forControlEvents:UIControlEventTouchUpInside];
    //分享
    UIButton *shareBtn =[UIButton buttonWithType:UIButtonTypeSystem];
    [self.view addSubview:shareBtn];
    shareBtn.frame = CGRectMake(padding, 410, kScreenWidth*0.5 - margin - padding, padding +margin);
    [shareBtn setTitle:@"马上分享" forState:UIControlStateNormal];
    [shareBtn setBackgroundColor:[UIColor colorWithRed:51/255.0 green:204/255.0 blue:1.0 alpha:1]];
    [shareBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [shareBtn addTarget:self action:@selector(share) forControlEvents:UIControlEventTouchUpInside];
    
    //继续
    UIButton *stuBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.view addSubview:stuBtn];
    stuBtn.frame = CGRectMake(kScreenWidth*0.5+margin, 410, kScreenWidth*0.5 - padding - margin, padding +margin);
    [stuBtn setTitle:@"继续学习" forState:UIControlStateNormal];
    [stuBtn setTitleColor: [UIColor whiteColor] forState:UIControlStateNormal];
    [stuBtn setBackgroundColor:[UIColor colorWithRed:51/255.0 green:204/255.0 blue:1.0 alpha:1]];
    [stuBtn addTarget:self action:@selector(goOnStudy) forControlEvents:UIControlEventTouchUpInside];
}
// 轻按手势<---->(第一题)
-(void)tapImageView:(UITapGestureRecognizer *)sender{
    
    UIImageView *imgView = (UIImageView *)sender.view;
    
    UIImageView *imageV1 = [self.bgView viewWithTag:10];
    UIImageView *imageV2 = [self.bgView viewWithTag:11];
    
    imageV1.layer.borderColor = [UIColor grayColor].CGColor;
    imageV2.layer.borderColor = [UIColor grayColor].CGColor;
    imgView.layer.borderColor = [UIColor colorWithRed:51/255.0 green:204/255.0 blue:1.0 alpha:1].CGColor;
    NSInteger tag = imgView.tag;
    self.answer = tag-10 ;
    
    QuestionsModel *model = self.dataArray[_index];
    if ([model.keysArray[0] isEqualToString:[NSString stringWithFormat:@"%ld",self.answer]]) {
        self.scores = 1;
    }else{
        self.scores = 0;
    }
    self.finished =YES;
    
}
// 第二题 配对题
-(void)panImageView:(UIPanGestureRecognizer *)sender{
    
    MatchImageView *matchView = (MatchImageView *)sender.view;
    
    [self.bgView bringSubviewToFront:matchView];
    if (sender.state == UIGestureRecognizerStateChanged) {
        CGPoint translation = [sender translationInView:self.view];
        
        matchView.center = CGPointMake(sender.view.center.x + translation.x, sender.view.center.y + translation.y);
        
        [sender setTranslation:CGPointZero inView:self.view];
        
    }else if (sender.state == UIGestureRecognizerStateEnded){
        //        MatchImageView *matchView =(MatchImageView *)sender.view;
        BaseImageView *baseView;
        self.tagIndex = 0;
        self.rect = NO;
        
        NSInteger tag = 40;
        for (NSValue *rectValue in self.baseRectArray) {
            BOOL rec = CGRectContainsPoint(rectValue.CGRectValue, matchView.center);
            
            if (rec) {
                baseView = [self.view viewWithTag:tag];
                self.rect = YES;
            }
            tag ++;
            
        }
        
        if (self.isRect) {
            
            if (!baseView.isRotate && !matchView.isRotate) {
                [matchView changeSmallandRotate];
                [matchView backToMatchCenter:baseView.center];
                
                [baseView changeSmallandRotate];
                
                //1.判断点所在的坑
                NSInteger tag = 0;
                for (NSValue *rectValue in self.baseRectArray) {
                    BOOL rec = CGRectContainsPoint(rectValue.CGRectValue, matchView.center);
                    if (rec) {
                        self.tagIndex = tag;
                    }
                    tag ++;
                    
                }
                [self.tagArray replaceObjectAtIndex:self.tagIndex withObject:[NSNumber numberWithInteger:matchView.tag]];
                
            }else if (!baseView.isRotate &&matchView.isRotate){
                
                [baseView changeSmallandRotate];
                
                [matchView backToMatchCenter:baseView.center];
                //取出matchView离开时的baseView
                NSInteger tag = 40;
                for (NSNumber *num in self.tagArray) {
                    
                    if ([num isEqualToNumber:[NSNumber numberWithInteger:matchView.tag]]) {
                        
                        baseView = [self.view viewWithTag:tag];
                        [baseView changeBigandRotate];
                    }
                    tag ++;
                }
                [self.tagArray replaceObjectAtIndex:baseView.tag - 40 withObject:[NSNumber numberWithInteger:0]];
                
                NSInteger tagIndex = 0;
                for (NSValue *rectValue in self.baseRectArray) {
                    BOOL rec = CGRectContainsPoint(rectValue.CGRectValue, matchView.center);
                    if (rec) {
                        self.tagIndex = tagIndex;
                    }
                    tagIndex ++;
                    
                }
                [self.tagArray replaceObjectAtIndex:self.tagIndex withObject:[NSNumber numberWithInteger:matchView.tag]];
                
            }else if (baseView.isRotate && !matchView.isRotate){
                
                NSValue *center = self.matchStarRectArray[matchView.tag -30];
                matchView.center = center.CGPointValue;
                
            }else if (baseView.isRotate && matchView.isRotate){
                
                NSInteger tag = 40;
                
                for (NSNumber *num  in self.tagArray) {
                    if ([num isEqualToNumber:[NSNumber numberWithInteger:matchView.tag]]) {
                        baseView = [self.view viewWithTag:tag];
                    }
                    tag ++;
                }
                [matchView backToMatchCenter:baseView.center];
                
            }
        }else{
            
            if (matchView.isRotate) {
                [matchView changeBigandRotate];
                NSValue *center = self.matchStarRectArray[matchView.tag -30];
                matchView.center = center.CGPointValue;
                
                NSInteger tag = 40;
                for (NSNumber *num in self.tagArray) {
                    
                    if ([num isEqualToNumber:[NSNumber numberWithInteger:matchView.tag]]) {
                        
                        baseView = [self.view viewWithTag:tag];
                        self.tagIndex = tag - 40;
                    }
                    tag ++;
                }
                [self.tagArray replaceObjectAtIndex:self.tagIndex withObject:[NSNumber numberWithInteger:0]];
                [baseView changeBigandRotate];
                
            }else{
                NSValue *center = self.matchStarRectArray[matchView.tag -30];
                matchView.center = center.CGPointValue;
                
            }
        }
        BOOL rec = ![self.tagArray containsObject:[NSNumber numberWithInteger:0]];
        self.finished = rec;
    }
    
}

// 第三题 选出不同类的一项
-(void)tapLabel:(UITapGestureRecognizer *)sender{
    QuestionsModel *model = self.dataArray[_index];
    
    for (int i = 0;  i < model.chooiceArray.count; i ++) {
        UILabel *label = [self.view viewWithTag:50 + i];
        label.backgroundColor = [UIColor grayColor];
    }
    
    sender.view.backgroundColor = [UIColor colorWithRed:51/255.0 green:204/255.0 blue:1.0 alpha:1];
    if ([model.keysArray[0]isEqualToString:[NSString stringWithFormat:@"%ld",sender.view.tag - 50]]) {
        self.scores = 1;
    }else{
        self.scores = 0;
    }
    self.answer = sender.view .tag - 50;
    self.finished = YES;
    
}
// 第四题 听写单词
-(BOOL)textFieldShouldReturn:(UITextField *)textField{

    QuestionsModel *model = self.dataArray[_index];
    [textField resignFirstResponder];
    
    self.answerWord = textField.text;
    
    if (textField.text.length) {
        
        self.finished =YES;
        
        if ([model.keysArray[0] caseInsensitiveCompare:textField.text] == NSOrderedSame) {
            self.scores = 1;
        }else{
            self.scores = 0;
        }
    }
    return  YES;
    
}
//第五种题目
-(void)tapLabelB:(UITapGestureRecognizer *)sender{
    QuestionsModel *model = self.dataArray[_index];
    
    for (int i = 0;  i < model.chooiceArray.count; i ++) {
        UILabel *label = [self.view viewWithTag:1000 + i];
        label.backgroundColor = [UIColor grayColor];
    }
    
    sender.view.backgroundColor = [UIColor colorWithRed:51/255.0 green:204/255.0 blue:1.0 alpha:1];
    if ([model.keysArray[0]isEqualToString:[NSString stringWithFormat:@"%ld",sender.view.tag - 1000]]) {
        self.scores = 1;
    }else{
        self.scores = 0;
    }
    self.answer = sender.view .tag - 1000;
    
    self.finished = YES;
    
}

-(void)readyPlay{
    self.time = 3;
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(textByTime) userInfo:nil repeats:YES];
    
    [[NSRunLoop currentRunLoop ] addTimer:self.timer forMode:NSDefaultRunLoopMode];
}
//

-(void)textByTime{
    UILabel *label = [self.view viewWithTag:3];
    label.text =[NSString stringWithFormat:@"%ld",self.time];
    label.hidden = NO;
    label.textColor = [UIColor whiteColor];
    label.font = [UIFont systemFontOfSize:11];
    label.textAlignment = NSTextAlignmentCenter;
    
    if (self.time > 0) {
        self.time --;
    }else{
        label.hidden = YES;
        QuestionsModel *model = self.dataArray[self.index];
        NSString *url = [NSString stringWithFormat:@"http://app.ekaola.com/%@",model.mp3url];
        UIImage *pause = [UIImage imageNamed:@"pause"];
        [self.playAgainBtn setImage:[pause imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
        [self playVoice:url];
        
        if (self.timer.isValid) {
            [self.timer invalidate];
            self.timer = nil;
        }

    }
}

//下一题点击方法
-(void)nextQuestion:(UIButton *)sender{

    if (self.isFnished) {//下一题

        QuestionsModel *model = self.dataArray[self.index];
        if ([model.ques containsString:@"选出与所听内容"]||[model.contentArr[0] isKindOfClass:[NSDictionary class]]) {
            
            NSNumber *num = [NSNumber numberWithInteger:self.answer];
            [self.answerArray addObject:num];
            if (self.scores ==1) {
                NSNumber *scr = [NSNumber numberWithInteger:self.scores];
                [self.scoresArray addObject:scr];
            }
        }
        else if ([model.ques containsString:@"选出不同类的一项"]||([model.type containsString:@"simple_choose"]&& ![model.ques containsString:@"听录音"])){
        
            NSNumber *num = [NSNumber numberWithInteger:self.answer];
            [self.answerArray addObject:num];
            
            if (self.scores ==1) {
                NSNumber *scr = [NSNumber numberWithInteger:self.scores];
                [self.scoresArray addObject:scr];
                
            }

        }
        else if([model.ques containsString:@"配对题"]|| [model.ques containsString:@"图片排序"]||[model.ques containsString:@"连接起来"]){
            
            [self.answerArray addObject:self.tagArray];
            
           __block NSInteger tag = 30;
           __block int score = 0;
            [self.tagArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                
                if ([obj integerValue] == tag) {
                    score ++;
                }else{
                    *stop=YES;
                }
                tag ++;
            }];

            if (score==self.tagArray.count) {
                NSNumber *sco = [NSNumber numberWithInteger:score];
                [self.scoresArray addObject:sco];
            }
        }
        else if([model.ques containsString:@"听写单词"]){
        
            [self.answerArray addObject:self.answerWord];
            if (self.scores ==1) {
                
                NSNumber *scr = [NSNumber numberWithInteger:self.scores];
                [self.scoresArray addObject:scr];

            }
            
        }
        else if ([model.ques containsString:@"选出你听到的内容"]||([model.contentArr[0] isKindOfClass:[NSString class]]&&[model.ques containsString:@"听录音"])){
            NSNumber *num = [NSNumber numberWithInteger:self.answer];
            [self.answerArray addObject:num];
            if (self.scores ==1) {
                NSNumber *scr = [NSNumber numberWithInteger:self.scores];
                [self.scoresArray addObject:scr];
                
            }

        }
        if (_index < self.dataArray.count -1) {
            
            NSLog(@"%ld self.index==self.dataArray.count %ld",_index,self.dataArray.count - 1);
            _index ++;
            
            QuestionsModel *model = self.dataArray[self.index];
            
            [self.player pause];
            
            if (self.timer.isValid) {
                [self.timer invalidate];
                self.timer = nil;
            }
            [self.bgView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
            [self createSameUI:self.dataArray.count];
            [self createDifferentUI];
            if (!([model.ques isEqualToString:@"配对题，"]||[model.ques isEqualToString:@"选出不同类的一项。"])) {
                [self readyPlay];
            }
            
            
        }else{

            [self.player pause];
            if (self.timer.isValid) {
                [self.timer invalidate];
                self.timer = nil;
            }

            [self.view.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
            [self createCommitUI];
            
        }
    }else{//弹窗
        
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.label.text =@"请先完成题目在提交";
        hud.label.font = [UIFont systemFontOfSize:13];
        [hud hideAnimated:YES afterDelay:1];
    
    }
}
//查看答案
-(void)checkAnswer{

    CGFloat padding = 20;
    self.check = YES;
    self.index = 0;
    [self.view.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    self.view.backgroundColor = [UIColor colorWithRed:51/255.0 green:204/255.0 blue:1.0 alpha:1];
    UIScrollView *answerSCroll = [[UIScrollView alloc] initWithFrame:CGRectMake(padding, 2*padding , kScreenWidth - 2 *padding, kScreenHeight - 4 *padding - 64)];
    answerSCroll.contentSize = CGSizeMake((kScreenWidth - 2*padding) * self.dataArray.count, kScreenHeight - 4*padding - 64);
    answerSCroll.bounces = NO;
    answerSCroll.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:answerSCroll];
    answerSCroll.pagingEnabled = YES;
    answerSCroll.delegate = self;
    
//    backBtn
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    backBtn.frame = CGRectMake(kScreenWidth -3*padding,padding, padding, padding);
    backBtn.clipsToBounds = YES;
    backBtn.layer.cornerRadius = 10;
    [backBtn setTitle:@"X" forState:UIControlStateNormal];
    [backBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [backBtn setBackgroundColor:[UIColor colorWithRed:255/255.0 green:98/255.0 blue:89/255.0 alpha:1]];
    [backBtn addTarget:self action:@selector(backToCheckAnswer) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backBtn];
    
    for (int i = 0 ; i < self.dataArray.count; i ++) {
        self.index = i;
        UIImageView *imageView =[[UIImageView alloc] initWithFrame:CGRectMake(i *(kScreenWidth - 2*padding), 0, (kScreenWidth - 2*padding - 5), (kScreenHeight - 64 - 4*padding))];
        imageView.transform = CGAffineTransformMakeScale(0.9, 1.0);
        imageView.userInteractionEnabled = YES;
        self.bgView = [[UIView alloc] initWithFrame:imageView.bounds];
        _bgView.backgroundColor = [UIColor whiteColor];
        self.tagArray = self.answerArray[i];

        [self createSameUI:self.dataArray.count];
        [self createDifferentUI];
        
        QuestionsModel *model = self.dataArray[_index];
        NSString *keys = model.keysArray[0];
        UIImage *trueImage = [UIImage imageNamed:@"3"];
        UIImage *wrongImage = [UIImage imageNamed:@"2"];

        if (i == 0 && [model.ques containsString:@"听录音"]) {
            //   准备播放
            [self readyPlay];

        }
        if ([model.ques containsString:@"选出与所听内容"]||[model.contentArr[0] isKindOfClass:[NSDictionary class]]) {
            NSMutableArray *array = [NSMutableArray array];
            NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
            NSString *title = [userDef objectForKey:kTitleName];
            if ([title containsString:@"配套练习"]) {
                array = [NSMutableArray arrayWithArray:model.chooiceArray];
            }else if([title containsString:@"词汇练习"]){
                array =[NSMutableArray arrayWithArray:model.picArray];
                
            }

            NSInteger tag =  [self.answerArray[i] integerValue];
            UIImageView *imgView = [self.bgView viewWithTag:tag + 10];
            imgView.layer.borderColor = [UIColor colorWithRed:51/255.0 green:204/255.0 blue:1.0 alpha:1].CGColor;
            
            for (int i = 0 ; i < array.count; i ++) {
                
                if ([keys isEqualToString:[NSString stringWithFormat:@"%ld",tag ] ]) {//正确
                    UIImageView *ansView = [self.bgView viewWithTag:200 + i];
                    ansView.image = [trueImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
                }else{
                    
                    UIImageView *imageView = [self.bgView viewWithTag:200 + tag];
                    imageView.image = [wrongImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
                    
                    UIImageView *trueImageV = [self.bgView viewWithTag:200 + keys.integerValue];
                    trueImageV.image = [trueImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];

                }
            }

        }
        else if ([model.ques containsString:@"配对题"]||[model.ques containsString:@"图片排序"]||[model.ques containsString:@"连接起来"]){
            
//            NSArray *ansArray =self.answerArray[i];

            for (int i = 0 ;  i < _tagArray.count; i ++) {
                if ([_tagArray[i] isEqualToNumber:[NSNumber numberWithInteger:30 + i]]) {
                    UIImageView *ansView = [self.bgView viewWithTag:400 + i];
                    ansView.image = [trueImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
                }else{
                    UIImageView *ansView = [self.bgView viewWithTag:400 + i ];
                    ansView.image = [wrongImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];

                }
            }
            
        }
        else if ([model.ques containsString:@"选出不同类的一项"]||([model.type containsString:@"simple_choose"]&& ![model.ques containsString:@"听录音"])){
            NSInteger answer = [self.answerArray[i] integerValue];
            
            for (int i = 0 ; i < model.chooiceArray.count; i ++) {
                if ([keys isEqualToString:[NSString stringWithFormat:@"%ld",answer]] && answer ==i) {
                    UIImageView *ansView = [self.bgView viewWithTag:300 + i];
                    ansView.image = [trueImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
                    UILabel *labelA = [self.bgView viewWithTag:50 + i];
                    labelA.backgroundColor = [UIColor colorWithRed:51/255.0 green:204/255.0 blue:1.0 alpha:1];
                }else{
                
                    if (answer ==i){
                        UIImageView *imageView = [self.bgView viewWithTag:300 + i];
                        imageView.image = [wrongImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
                        UILabel *labelA = [self.bgView viewWithTag:50 + i];
                        labelA.backgroundColor = [UIColor colorWithRed:51/255.0 green:204/255.0 blue:1.0 alpha:1];
                        NSInteger tag = keys.integerValue;
                        UIImageView *ansView = [self.bgView viewWithTag:tag + 300];
                        ansView.image = [trueImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
                        
                    }
                }
            }
        }
        else if([model.ques containsString:@"听写单词"]){
            UIImageView *ansView = [self.bgView viewWithTag:503];
            UILabel *labelA = [self.bgView viewWithTag:500];
            UILabel *labelB = [self.bgView viewWithTag:501];
            labelA.text = self.answerArray[i];
            labelA.textAlignment = NSTextAlignmentCenter;
            labelB.text = [NSString stringWithFormat:@"答案:%@",keys];
            labelB.textAlignment = NSTextAlignmentCenter;
            if ([keys caseInsensitiveCompare:self.answerArray[i]] ==NSOrderedSame) {
                ansView.image = [trueImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
                
            }else{
                ansView.image = [wrongImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
            }
        }
        else if ([model.ques containsString:@"选出你听到的内容"]||([model.contentArr[0] isKindOfClass:[NSString class]]&&[model.ques containsString:@"听录音"])){
            NSInteger answer = [self.answerArray[i] integerValue];

            for (int i = 0;  i < model.chooiceArray.count; i ++) {
                if ([keys isEqualToString:[NSString stringWithFormat:@"%ld",answer]] && answer ==i) {
                    UIImageView *ansView = [self.bgView viewWithTag:3000 + i];
                    ansView.image = [trueImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
                    UILabel *labelA = [self.bgView viewWithTag:1000 + i];
                    labelA.backgroundColor = [UIColor colorWithRed:51/255.0 green:204/255.0 blue:1.0 alpha:1];
                    
                }else{
                    if (answer ==i){
                        UIImageView *imageView = [self.bgView viewWithTag:3000 + i];
                        imageView.image = [wrongImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
                        
                        UILabel *labelA = [self.bgView viewWithTag:1000 + i];
                        labelA.backgroundColor = [UIColor colorWithRed:51/255.0 green:204/255.0 blue:1.0 alpha:1];
                        NSInteger tag = keys.integerValue;
                        UIImageView *ansView = [self.bgView viewWithTag:tag + 3000];
                        ansView.image = [trueImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
                        
                    }
                    
                }
            }
        }
        
        self.nextBtn.hidden = YES;
        [imageView addSubview:self.bgView];
        [answerSCroll addSubview:imageView];
        
    }

}
-(void)share{
    [UMSocialData defaultData].extConfig.wechatTimelineData.url = @"http://www.engua.com";
//      分享title
    [UMSocialData defaultData].extConfig.wechatTimelineData.title = @"爱英语";
    [UMSocialData defaultData].extConfig.wxMessageType = UMSocialWXMessageTypeApp;
    
    [UMSocialSnsService presentSnsIconSheetView:self appKey:@"wx1b008cf4b693f89e" shareText:@"分享" shareImage:[UIImage imageNamed:@"1"] shareToSnsNames:@[UMShareToWechatTimeline,UMShareToSina,] delegate:self];
}
-(void)goOnStudy{
    
    MBProgressHUD *mbProgress = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    mbProgress.mode = MBProgressHUDModeText;
    mbProgress.label.text = @"请先购买课程";
    mbProgress.label.font = [UIFont systemFontOfSize:13];
    [mbProgress hideAnimated:YES afterDelay:1.5];

}

-(void)backToCheckAnswer{
    
    self.check = NO;
    self.index = 0;
    [self.player pause];
    if (self.timer.valid) {
        [self.timer invalidate];
        self.timer = nil;
    }
    
    [self.view.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];

    [self createCommitUI];
    
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    float padding = 20;
    if (scrollView.contentOffset.x/(kScreenWidth - 2* padding) != _index) {
        _index = scrollView.contentOffset.x/(kScreenWidth -2*padding);
        [self.player pause];
        if (self.timer.valid) {
            [self.timer invalidate];
            self.timer =nil;
        }
        [self readyPlay];
    }
}
//点击再次播放
-(void)playAgain:(UIButton *)sender{
    
    UIImage *pause = [UIImage imageNamed:@"pause"];
    [sender setImage:[pause imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    
    QuestionsModel *model = self.dataArray[_index];
    NSString *url = [NSString stringWithFormat:@"http://app.ekaola.com/%@",model.mp3url];

    [self playVoice:url];
    
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
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(playAgainBtnSetImage) name:AVPlayerItemDidPlayToEndTimeNotification object:self.playItem];
    
    
}

-(void)playAgainBtnSetImage{

    [[NSNotificationCenter defaultCenter]removeObserver:self name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
    
    UIImage *play = [UIImage imageNamed:@"player"];
    [self.playAgainBtn setImage:[play imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    
    [self.player pause];
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{
    
    if ([keyPath isEqualToString:@"status"]) {
        switch (self.playItem.status) {
            case AVPlayerItemStatusUnknown:
                //                NSLog(@"未知错误");
                break;
            case AVPlayerItemStatusReadyToPlay:
                
                [self.player play];
                //NSLog(@"播放成功");
                break;
            case AVPlayerItemStatusFailed:
                //                NSLog(@"播放失败");
                break;
        }
    }
    
}

-(void)viewWillDisappear:(BOOL)animated{

    [super viewWillDisappear: animated];
    
    NSLog(@"questionVC disappear");
    
    if (self.playItem!=nil) {
        if (self.playItem.observationInfo) {
            [self.playItem removeObserver:self forKeyPath:@"status"];
        }
    }
    if (self.timer.isValid) {
        [self.timer invalidate];
        self.timer = nil;
    }
    
    
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
