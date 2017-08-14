//
//  HomeHeaderCell.h
//  AiEnglish
//
//  Created by kangGG on 16/7/21.
//  Copyright © 2016年 Kong....... All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SenceModel.h"

@interface HomeHeaderCell : UICollectionReusableView
@property(nonatomic,strong)SenceModel *model;

@property (weak, nonatomic) IBOutlet UILabel *studyLabel;
@property (weak, nonatomic) IBOutlet UILabel *recommendLabel;
@property (weak, nonatomic) IBOutlet UIImageView *studyImage;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIView *markView;
@property (weak, nonatomic) IBOutlet UIView *studyMark;
@end
