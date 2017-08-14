//
//  MessageHeaderCell.m
//  AiEnglish
//
//  Created by kangGG on 17/2/16.
//  Copyright © 2017年 Kong....... All rights reserved.
//

#import "MessageHeaderCell.h"

@implementation MessageHeaderCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.headerInageView.layer.cornerRadius = 40;
    self.headerInageView.clipsToBounds = YES;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
