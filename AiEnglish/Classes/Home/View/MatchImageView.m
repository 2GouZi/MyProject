//
//  MatchImageView.m
//  AiEnglish
//
//  Created by kangGG on 16/7/28.
//  Copyright © 2016年 Kong....... All rights reserved.
//

#import "MatchImageView.h"

@implementation MatchImageView

-(instancetype)initWithFrame:(CGRect)frame{

    if (self = [super initWithFrame:frame]) {
        
        self.rotate = NO;
        self.layer.borderWidth =1;
        self.clipsToBounds = YES;
        self.layer.cornerRadius = 10;
        self.layer.borderColor = [UIColor colorWithRed:51/255.0 green:204/255.0 blue:1.0 alpha:1].CGColor;

    }
    return self;
}

-(void)changeBigandRotate{
    
    [UIView animateWithDuration:1 animations:^{
        
        self.transform = CGAffineTransformScale(self.transform, 10/7.0, 10/7.0);
        self.transform = CGAffineTransformRotate(self.transform, -M_PI_4 *0.5);
        
    }];
    self.rotate = NO;
    
}

-(void)changeSmallandRotate{
    
    [UIView animateWithDuration:1 animations:^{
        
        self.transform = CGAffineTransformScale(self.transform, 0.7, 0.7);
        self.transform = CGAffineTransformRotate(self.transform, M_PI_4 *0.5);
        
    }];
    self.rotate = YES;
    
}
-(void)backToMatchCenter:(CGPoint)baseCenter{

    self.center = CGPointMake(baseCenter.x +30, baseCenter.y +20);
    

}

-(void)changeSmallAndRotateNoAnimatin{

    self.transform = CGAffineTransformScale(self.transform, 0.7, 0.7);
    self.transform = CGAffineTransformRotate(self.transform, M_PI_4 *0.5);
    self.rotate = YES;

}
//-(void)backToOriginCenter:(NSInteger)index{
//    
//    self.center = [self.StarRectArray[index] CGPointValue];
//}
@end
