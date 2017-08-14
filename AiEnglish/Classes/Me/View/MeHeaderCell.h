//
//  MeHeaderCell.h
//  AiEnglish
//
//  Created by kangGG on 17/2/15.
//  Copyright © 2017年 Kong....... All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MeModel.h"
@interface MeHeaderCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *headerImgView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;


@property(nonatomic,strong)MeModel *model;

@end
