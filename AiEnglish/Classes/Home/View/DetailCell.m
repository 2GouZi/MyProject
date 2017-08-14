//
//  DetailCell.m
//  AiEnglish
//
//  Created by kangGG on 16/7/11.
//  Copyright © 2016年 Kong....... All rights reserved.
//

#import "DetailCell.h"
#import "UIImageView+WebCache.h"
@implementation DetailCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code


}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setModel:(SenceModel *)model{

    _model = model;
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
//    [self.imgView setimagew]
    [self.imgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://app.ekaola.com/%@",model.cover]]placeholderImage:[UIImage imageNamed:@"icon"]];
    
    self.titleLabel.text =model.title;
    
    self.titleLabel.numberOfLines=0;
    
    self.freeLabel.clipsToBounds = YES;
    
    self.freeLabel.layer.cornerRadius =3;
    
    if ([model.free isEqualToString:@"1"]) {
        self.freeLabel.hidden = NO;
        self.freeLabel.backgroundColor = [UIColor orangeColor];
        self.freeLabel.text = @"免费试学";
        
    }else{
    
        self.freeLabel.hidden =YES;
        
    }
    
}
@end
