//
//  QuestionsModel.h
//  AiEnglish
//
//  Created by kangGG on 16/7/26.
//  Copyright © 2016年 Kong....... All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QuestionsModel : NSObject
@property(nonatomic,strong)NSString *ques;
@property(nonatomic,strong)NSString *mp3url;
@property(nonatomic,strong)NSArray *chooiceArray;
@property(nonatomic,strong)NSArray *picArray;
@property(nonatomic,strong)NSArray *baseImgArr;
@property(nonatomic,strong)NSArray *matchImgArr;
@property(nonatomic,strong)NSArray *contentArr;
@property(nonatomic,strong)NSArray *keysArray;
@property(nonatomic,strong)NSString *type;

@end
