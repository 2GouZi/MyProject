//
//  WordTestModel.h
//  AiEnglish
//
//  Created by kangGG on 16/7/25.
//  Copyright © 2016年 Kong....... All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CardModel : NSObject

@property(nonatomic,strong)NSString *backImgUrl;
@property(nonatomic,strong)NSString *frontImgUrl;
@property(nonatomic,strong)NSString *mp3Url;
@property(nonatomic,assign,getter=isFront)BOOL front;


@end
