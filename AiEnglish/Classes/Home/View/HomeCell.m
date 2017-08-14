//
//  HomeCell.m
//  AiEnglish
//
//  Created by kangGG on 16/7/11.
//  Copyright © 2016年 Kong....... All rights reserved.
//

#import "HomeCell.h"
#import "UIImageView+WebCache.h"
@implementation HomeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)setModel:(HomeModel *)model{

    _model = model;
    
    //http://app.ekaola.com/assets/package/cover/corp_phpzzCwKh1460538158.jpg
    self.imgView.clipsToBounds=YES;
    self.imgView.layer.cornerRadius = 5;
    
    [self.imgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://app.ekaola.com/%@",model.pic]]];
    
    
    self.titleLabel.text = model.title;
    
}
@end
