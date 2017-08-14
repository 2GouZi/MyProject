//
//  InfoModel.h
//  AiEnglish
//
//  Created by kangGG on 16/7/11.
//  Copyright © 2016年 Kong....... All rights reserved.
//

#import "JSONModel.h"

@interface InfoModel : JSONModel

@property(nonatomic,strong)NSString *cover;

@property(nonatomic,strong)NSString *intro;
@property(nonatomic,strong)NSString *price;
@property(nonatomic,strong)NSString *title;
@property(nonatomic,strong)NSString *pkgid;
@property(nonatomic,assign)NSInteger purchase;

@end
