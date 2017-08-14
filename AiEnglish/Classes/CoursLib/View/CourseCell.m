//
//  CourseCell.m
//  AiEnglish
//
//  Created by kangGG on 16/7/11.
//  Copyright © 2016年 Kong....... All rights reserved.
//

#import "CourseCell.h"

#import "UIImageView+WebCache.h"
@implementation CourseCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)setModel:(CourseModel *)model{

    _model = model;
    
    self.imgView.clipsToBounds = YES;
    
    self.imgView.layer.cornerRadius = 5;
    
    [self.imgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://app.ekaola.com/%@",model.cover]]];
    
    self.titleLabel.text = model.title;
    self.priceLabel.clipsToBounds = YES;
    self.priceLabel.layer.cornerRadius = 25;
    self.priceLabel.textColor = [UIColor whiteColor];
    
    if ([model.price isEqualToString:@"0.00"]) {
        
        self.priceLabel.backgroundColor = [UIColor greenColor];
        self.priceLabel.alpha=0.5;
        self.priceLabel.text =@"免费";
    }else if([model.price isEqualToString:@"12.00"]){
        self.priceLabel.backgroundColor = [UIColor orangeColor];
        self.priceLabel.text =[NSString stringWithFormat:@"￥%@",model.price];
        
    }else{
    
        self.priceLabel.backgroundColor = [UIColor orangeColor];
        self.priceLabel.text =[NSString stringWithFormat:@"￥%@",model.price];

    }
    
    
}

@end
