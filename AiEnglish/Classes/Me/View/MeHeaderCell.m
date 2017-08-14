//
//  MeHeaderCell.m
//  AiEnglish
//
//  Created by kangGG on 17/2/15.
//  Copyright © 2017年 Kong....... All rights reserved.
//

#import "MeHeaderCell.h"

@implementation MeHeaderCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.backgroundColor =[UIColor colorWithRed:51/255.0 green:204/255.0 blue:255/255.0 alpha:1];

    self.selectedBackgroundView.backgroundColor =[UIColor colorWithRed:51/255.0 green:204/255.0 blue:255/255.0 alpha:1];
    self.headerImgView.layer.cornerRadius = 50;
    self.headerImgView.clipsToBounds = YES;

    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setModel:(MeModel *)model{

    _model = model;
    
    self.headerImgView.layer.cornerRadius = 50;
    self.headerImgView.clipsToBounds = YES;
    
    self.nameLabel.textColor = [UIColor whiteColor];
    
    
}

@end
