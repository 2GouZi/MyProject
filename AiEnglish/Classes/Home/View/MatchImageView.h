//
//  MatchImageView.h
//  AiEnglish
//
//  Created by kangGG on 16/7/28.
//  Copyright © 2016年 Kong....... All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MatchImageView : UIImageView

@property(nonatomic,assign,getter=isRotate)BOOL rotate;
@property(nonatomic,assign)CGPoint mCenter;
-(void)changeBigandRotate;

-(void)changeSmallandRotate;

//移动到匹配的位置
-(void)backToMatchCenter:(CGPoint)baseCenter;

//移动到原来的位置

//-(void)backToOriginCenter:(NSInteger)index;

-(void)changeSmallAndRotateNoAnimatin;


@end
