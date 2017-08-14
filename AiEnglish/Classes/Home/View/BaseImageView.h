//
//  BaseImageView.h
//  AiEnglish
//
//  Created by kangGG on 16/7/28.
//  Copyright © 2016年 Kong....... All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseImageView : UIImageView

@property(nonatomic,assign,getter=isRotate)BOOL rotate;
@property(nonatomic,assign,getter=isMatched)BOOL match;
-(void)changeBigandRotate;

-(void)changeSmallandRotate;


-(void)changeSmallAndRotateNoAnimatin;
@end
