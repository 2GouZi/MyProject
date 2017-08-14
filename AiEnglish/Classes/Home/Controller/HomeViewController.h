//
//  HomeViewController.h
//  kangEnglish
//
//  Created by kangGG on 16/7/9.
//  Copyright © 2016年 Kong....... All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SenceModel.h"
@interface HomeViewController : UIViewController
@property(nonatomic,strong)SenceModel *model;

@property(nonatomic,strong)UIImage *studyImage;

@property(nonatomic,strong)NSString *studyTitle;

@property(nonatomic,strong)NSString *senceid;
@end
