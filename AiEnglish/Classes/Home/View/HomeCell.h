//
//  HomeCell.h
//  AiEnglish
//
//  Created by kangGG on 16/7/11.
//  Copyright © 2016年 Kong....... All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeModel.h"
@interface HomeCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property(nonatomic,strong) HomeModel *model;

@end
