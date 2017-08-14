//
//  HomeHeaderCell.m
//  AiEnglish
//
//  Created by kangGG on 16/7/21.
//  Copyright © 2016年 Kong....... All rights reserved.
//

#import "HomeHeaderCell.h"
#import "StudyViewController.h"
#import "UIImageView+WebCache.h"
@implementation HomeHeaderCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)setModel:(SenceModel *)model{
    
    _model = model;
    
//    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    self.recommendLabel.text = @"推荐课程";
    self.markView.backgroundColor = [UIColor colorWithRed:51/255.0 green:204/255.0 blue:255/255.0 alpha:1];
    
    self.studyMark.backgroundColor = [UIColor colorWithRed:51/255.0 green:204/255.0 blue:255/255.0 alpha:1];

}

@end
