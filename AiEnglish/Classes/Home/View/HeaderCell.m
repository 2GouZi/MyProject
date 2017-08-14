//
//  HeaderCell.m
//  AiEnglish
//
//  Created by kangGG on 17/2/14.
//  Copyright © 2017年 Kong....... All rights reserved.
//

#import "HeaderCell.h"

#import "UIImageView+WebCache.h"
#import "GDataXMLNode.h"
@implementation HeaderCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setModel:(InfoModel *)model{
    _model = model;
    
    self.backgroundColor = [UIColor colorWithRed:51/255.0 green:204/255.0 blue:255/255.0 alpha:1];
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    [self.introWeb loadHTMLString:model.intro baseURL:nil];
    self.introWeb.opaque = NO;
    
    self.introWeb.backgroundColor = [UIColor clearColor];
    
    self.introWeb.userInteractionEnabled = NO;
    
//    self.introWeb.delegate =self;
    
    if ([model.price isEqualToString:@"0.00"]) {
        
        self.priceLabel.text = @"";
        
    }else{
    
        self.priceLabel.text = [NSString stringWithFormat:@"￥%@",model.price];
    }
    [self.imgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://app.ekaola.com/%@",model.cover]]];
 
    
}

@end
