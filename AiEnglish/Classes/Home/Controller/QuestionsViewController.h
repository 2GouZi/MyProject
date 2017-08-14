//
//  QuestionsViewController.h
//  AiEnglish
//
//  Created by kangGG on 16/7/27.
//  Copyright © 2016年 Kong....... All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
@interface QuestionsViewController : UIViewController

@property(nonatomic,strong)NSMutableArray *dataArray;
@property(nonatomic,strong)UIView *bgView;
@property(nonatomic,strong)AVPlayerItem *playItem;
@property(nonatomic,strong)AVPlayer *player;
@property(nonatomic,strong)NSTimer *timer;

-(void)createSameUI:(NSInteger)count;

-(void)createDifferentUI;
-(void)createCommitUI;
-(void)readyPlay;
//查看答案
-(void)playVoice:(NSString *)url;
@end
