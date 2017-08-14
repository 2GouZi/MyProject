//
//  HeaderCell.h
//  AiEnglish
//
//  Created by kangGG on 17/2/14.
//  Copyright © 2017年 Kong....... All rights reserved.
//

#import <UIKit/UIKit.h>

#import "InfoModel.h"
@interface HeaderCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UIWebView *introWeb;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;

@property(nonatomic,strong)InfoModel *model;

@end
