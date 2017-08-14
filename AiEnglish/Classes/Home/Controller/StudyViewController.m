//
//  StudyViewController.m
//  AiEnglish
//
//  Created by kangGG on 17/2/15.
//  Copyright © 2017年 Kong....... All rights reserved.
//

#import "StudyViewController.h"
#import <AudioToolbox/AudioToolbox.h>
#import "UIImageView+WebCache.h"
#import <AVFoundation/AVFoundation.h>
#import "SenceModel.h"
#import "CategoryCell.h"
#import "AFHTTPSessionManager.h"
#import "RDVTabBarController.h"
@interface StudyViewController ()<UIScrollViewDelegate,UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)NSMutableArray *mp3Array;
@property(nonatomic,strong)NSMutableArray *imgArray;
@property(nonatomic,strong)NSMutableArray *pageArray;

@property(nonatomic,strong)UIScrollView *scrollView;
@property(nonatomic,strong)UIImageView *imgView ;
@property(nonatomic,strong)UIView *coverView;
@property(nonatomic,strong)AVPlayer *player;
@property(nonatomic,strong)AVPlayerItem *songItem;

@property(nonatomic,assign)float progress;
@property(nonatomic,strong)NSString *playTime;
@property(nonatomic,strong)NSString *playDuration;

@property(nonatomic,strong)id timeObserve;
@property (nonatomic,assign)NSInteger index;

@property(nonatomic,assign)NSInteger page;


//@property(nonatomic,assign) NSInteger page;

@end

@implementation StudyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    _page =0;
    [self createUI];
    [self requestData];
    
}

-(void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:animated];
    
    [self.rdv_tabBarController setTabBarHidden:YES];
    
}

-(void)createUI{
    

    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenHeight -44 -64, kScreenWidth, 44)];
//    view.backgroundColor = [UIColor colorWithRed:51/255.0 green:204/255.0 blue:1.0 alpha:1];
    view.backgroundColor = [UIColor whiteColor];
    
    
    [self.view addSubview:view];
    UIImageView *imageV = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 32, 32)];
    imageV.userInteractionEnabled = YES;
    imageV.image = [UIImage imageNamed:@"category"];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(category)];
    [imageV addGestureRecognizer:tap];
    [view addSubview:imageV];
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-64-44)];
    [self.view addSubview:self.scrollView];
    self.scrollView.delegate =self;
    self.scrollView.pagingEnabled = YES;
    self.scrollView.bounces = NO;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.contentSize = CGSizeMake(kScreenWidth * self.imgArray.count, kScreenHeight-64-44);
    for (int i =0 ; i< self.imgArray.count; i ++) {
        self.imgView = [[UIImageView alloc] initWithFrame:CGRectMake( i *kScreenWidth,0, kScreenWidth, kScreenHeight -64-44)];
        
        [self.imgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://app.ekaola.com%@",self.imgArray[i]]]];
        [self.scrollView addSubview: self.imgView];
    }

//    [self.view bringSubviewToFront:view];
    
    [self starPlay];
    
    
}
-(void)starPlay{
    
    _index = 0;
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://app.ekaola.com/%@",self.pageArray[_page][_index]]];

    if (_songItem!=nil) {
        
        if (self.songItem.observationInfo) {
            
            [self.songItem removeObserver:self forKeyPath:@"status"];
        }
        self.songItem = nil;
    }

    self.songItem = [[AVPlayerItem alloc] initWithURL:url];
    
    AVPlayer *player =[[AVPlayer alloc] initWithPlayerItem:self.songItem];
    self.player = player;
    
    
    [self.songItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playbackFinished:) name:AVPlayerItemDidPlayToEndTimeNotification object:self.songItem];
    
}

- (void)playbackFinished:(NSNotification *)notice {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [NSThread sleepForTimeInterval:1];
    [self nextSong ];
    
    

}
-(void)nextSong{
//    __weak typeof (self) weakSelf = self;
    
    _index ++;
    if (_index < [self.pageArray[_page] count]) {
        
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://app.ekaola.com/%@",self.pageArray[_page][_index]]];
        if (_songItem!=nil) {
            
            if (self.songItem.observationInfo) {
                
                [self.songItem removeObserver:self forKeyPath:@"status"];
            }
            self.songItem = nil;
        }

        self.songItem = [[AVPlayerItem alloc] initWithURL:url];
        
        AVPlayer *player =[[AVPlayer alloc] initWithPlayerItem:self.songItem];
        
        self.player = player;
        
    [self.songItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playbackFinished:) name:AVPlayerItemDidPlayToEndTimeNotification object:self.songItem];

    }
    
}
- (void)observeValueForKeyPath:(nullable NSString *)keyPath ofObject:(nullable id)object change:(nullable NSDictionary<NSString*, id> *)change context:(nullable void *)context{
            if ([keyPath isEqualToString:@"status"]) {
                switch (self.player.status) {
                    case AVPlayerStatusUnknown:
                        break;
                    case AVPlayerStatusReadyToPlay:
                        [self.player play];
                        break;
                    case AVPlayerStatusFailed:
                        break;
                    default:
                        break;
                }
            }
}



-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{

    if (self.scrollView.contentOffset.x/kScreenWidth !=_page) {
        
        [self.player pause];
        
        _page = self.scrollView.contentOffset.x/kScreenWidth;
        
        [self starPlay];
    }
}

-(void)requestData{
    

    //app.ekaola.com/app/get_download_info?version=2
    // POST
    self.imgArray = [NSMutableArray array];
    self.pageArray = [NSMutableArray array];
    
    NSString *url = [NSString stringWithFormat:@"http://app.ekaola.com/app/get_sence_json&pkgid=%@",self.senceid];
    
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSURLSessionDataTask *task = [session dataTaskWithURL:[NSURL URLWithString:url] completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
//        NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        
        NSArray *array = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
        
        for (NSDictionary *dict in array) {
            NSArray *array1 = dict[@"content"];
            
            self.mp3Array = [NSMutableArray array];

            BOOL once = 1;
            for (NSDictionary *dic in array1) {
            
//                [self paserData:dic];
                 NSString *string;
                
                string = dic[@"content"];
                 NSRange range;
                 range = [string rangeOfString:@"src=\""];
                
                if (range.length) {
                    if (once) {
                        
                        string = [string substringFromIndex:(range.location +range.length)];
                        
                        range = [string rangeOfString:@"\">"];
                        
                        string = [string substringToIndex:range.location];
                        
                        [self.imgArray addObject:string];
                        once = 0;
                    }
       
                }else{
                
                    NSRange range = [string rangeOfString:@"url"];
                       
                    if (range.length) {
                        
                        string = [string substringFromIndex:(range.location + range.length +3)];
                        
                        range =[string rangeOfString:@"mp3"];
                        
                        string = [string substringToIndex:range.location+range.length];
                        
                        [self.mp3Array addObject:string];
                    }                
                }
                
            }
        
            [self.pageArray addObject:self.mp3Array];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self createUI];

        });
        
    }];
    
    [task resume];
}
//点击目录执行的操作
-(void)category{
    UIView *cover = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    cover.backgroundColor = [UIColor colorWithWhite:0 alpha:0.65];
    self.coverView = cover;
    [self.view addSubview:cover];
    UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.frame];
    [cover addSubview:tableView];
    tableView.backgroundColor = [UIColor whiteColor];
    tableView.alpha =1;
    [tableView registerNib:[UINib nibWithNibName:@"CategoryCell" bundle:nil] forCellReuseIdentifier:@"category"];
    
    tableView.dataSource =self;
    tableView.delegate =self;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{

    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return 11;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    if (indexPath.row==0) {
        CategoryCell *cell = [tableView dequeueReusableCellWithIdentifier:@"category"];
        cell.back.clipsToBounds = YES;
        cell.back.layer.cornerRadius = 10;
        [cell.back setTitle:@"X" forState:UIControlStateNormal];
        [cell.back setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [cell.back setBackgroundColor:[UIColor colorWithRed:255/255.0 green:98/255.0 blue:89/255.0 alpha:1]];
        [cell.back addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
        
        return cell;
    }else{
    
        static NSString *ID = @"cell";
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
        if (cell ==nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
            
        }
        SenceModel *model = self.categoryArray[indexPath.row-1];
        
        cell.textLabel.text =model.title;
        
        return cell;
    }
}
-(void)backClick{

    self.coverView.hidden = YES;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    if (indexPath.row==0) {
        return 60;
    }else{
    
        return 38;
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    
    SenceModel *model = self.categoryArray[indexPath.row-1];
    
    self.senceid = model.senceid;
    
//    self.scrollView = nil;
    
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    
    [userDef setObject:self.senceid forKey:kSenceid];
    
    [userDef setObject:model.title forKey:kTitle];
    
    [userDef synchronize];
    
    [self requestData];
    
    self.coverView.hidden = YES;
    
}

-(void)viewWillDisappear:(BOOL)animated{

    [super viewWillDisappear:animated];
    if (_songItem!=nil) {
        
        if (self.songItem.observationInfo) {
            
            [self.songItem removeObserver:self forKeyPath:@"status"];
        }
        self.songItem = nil;
    }

    [self.player pause];

}

-(void)viewDidDisappear:(BOOL)animated{

    [super viewDidDisappear:animated];
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
