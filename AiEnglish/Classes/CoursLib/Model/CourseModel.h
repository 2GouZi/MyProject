//
//  CourseModel.h
//  AiEnglish
//
//  Created by kangGG on 16/7/11.
//  Copyright © 2016年 Kong....... All rights reserved.
//

#import "JSONModel.h"

@interface CourseModel : JSONModel

@property(nonatomic,strong)NSString *cover;
@property(nonatomic,strong)NSString *price;
@property(nonatomic,strong)NSString *title;
@property(nonatomic,strong)NSString *pkgid;

@end
