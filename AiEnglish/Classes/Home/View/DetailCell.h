//
//  DetailCell.h
//  AiEnglish
//
//  Created by kangGG on 16/7/11.
//  Copyright © 2016年 Kong....... All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SenceModel.h"
@interface DetailCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *freeLabel;

@property(nonatomic,strong)SenceModel *model;

@end
