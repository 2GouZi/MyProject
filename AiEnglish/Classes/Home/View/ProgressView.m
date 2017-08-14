//
//  progView.m
//  progress
//
//  Created by kangGG on 16/8/2.
//  Copyright © 2016年 Kong....... All rights reserved.
//

#import "ProgressView.h"

@implementation ProgressView
- (id)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    
    if (self) {
        
        self.backgroundColor = [UIColor clearColor];
        
        _percent = 0;
        
        _width = 0;
        
    }
    
    
    
    return self;
    
}
- (void)setPercent:(float)percent{
    
    _percent = percent;
    
    [self setNeedsDisplay];
    
}
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    
    [self addArcBackColor];
    
    [self drawArc];
    
    [self addCenterBack];
    
    [self addCenterLabel];
}

- (void)addArcBackColor{
    
    CGColorRef color = (_arcBackColor == nil) ? [UIColor lightGrayColor].CGColor : _arcBackColor.CGColor;
    
    
    CGContextRef contextRef = UIGraphicsGetCurrentContext();
    
    CGSize viewSize = self.bounds.size;
    
    CGPoint center = CGPointMake(viewSize.width / 2, viewSize.height / 2);
    
    // Draw the slices.
    
    CGFloat radius = viewSize.width / 2;
    
    CGContextBeginPath(contextRef);
    
    CGContextMoveToPoint(contextRef, center.x, center.y);
    
    CGContextAddArc(contextRef, center.x, center.y, radius,0,2*M_PI, 0);
    
    CGContextSetFillColorWithColor(contextRef, color);
    
    CGContextFillPath(contextRef);
    
}


- (void)drawArc{
    
    if (_percent == 0 || _percent > 1) {
        
        return;
        
    }
    if (_percent == 1) {
        
        CGColorRef color = (_arcFinishColor == nil) ? [UIColor greenColor].CGColor : _arcFinishColor.CGColor;
        CGContextRef contextRef = UIGraphicsGetCurrentContext();
        
        CGSize viewSize = self.bounds.size;
        
        CGPoint center = CGPointMake(viewSize.width / 2, viewSize.height / 2);
        
        // Draw the slices.
        
        CGFloat radius = viewSize.width / 2;
        
        CGContextBeginPath(contextRef);
        
        CGContextMoveToPoint(contextRef, center.x, center.y);
        
        CGContextAddArc(contextRef, center.x, center.y, radius,0,2*M_PI, 0);
        
        CGContextSetFillColorWithColor(contextRef, color);
        
        CGContextFillPath(contextRef);
        
    }else{
        
        
        
        float endAngle = 2*M_PI*(_percent - 0.25);
        
        
        
        CGColorRef color = (_arcUnfinishColor == nil) ? [UIColor blueColor].CGColor : _arcUnfinishColor.CGColor;
        
        CGContextRef contextRef = UIGraphicsGetCurrentContext();
        
        CGSize viewSize = self.bounds.size;
        
        CGPoint center = CGPointMake(viewSize.width / 2, viewSize.height / 2);
        
        // Draw the slices.
        
        CGFloat radius = viewSize.width / 2;
        
        CGContextBeginPath(contextRef);
        
        CGContextMoveToPoint(contextRef, center.x, center.y);
        
        CGContextAddArc(contextRef, center.x, center.y, radius,-M_PI_2,endAngle, 0);
        
        CGContextSetFillColorWithColor(contextRef, color);
        
        CGContextFillPath(contextRef);
        
    }
    
    
    
}


-(void)addCenterBack{
    
    float width = (_width == 0) ? 5 : _width;
    
    
    
    CGColorRef color = (_centerColor == nil) ? [UIColor whiteColor].CGColor : _centerColor.CGColor;
    
    CGContextRef contextRef = UIGraphicsGetCurrentContext();
    
    CGSize viewSize = self.bounds.size;
    
    CGPoint center = CGPointMake(viewSize.width / 2, viewSize.height / 2);
    
    // Draw the slices.
    
    CGFloat radius = viewSize.width / 2 - width;
    
    CGContextBeginPath(contextRef);
    
    CGContextMoveToPoint(contextRef, center.x, center.y);
    
    CGContextAddArc(contextRef, center.x, center.y, radius,0,2*M_PI, 0);
    
    CGContextSetFillColorWithColor(contextRef, color);
    
    CGContextFillPath(contextRef);
    
}


- (void)addCenterLabel{
    
    NSString *percent = @"";
    
    
    float fontSize = 13;
    
    UIColor *arcColor = [UIColor blueColor];
    
    if (_percent == 1) {
        
        percent = [NSString stringWithFormat:@"你的得分:\n%.0f",_percent*100];
        
        fontSize = 13;
        
        arcColor = (_arcFinishColor == nil) ? [UIColor greenColor] : _arcFinishColor;
        
        
        
    }else if(_percent < 1 && _percent >= 0){
        
        
        
        fontSize = 13;
        
        arcColor = (_arcUnfinishColor == nil) ? [UIColor blueColor] : _arcUnfinishColor;
        
        percent = [NSString stringWithFormat:@"你的得分:\n%.0f",_percent*100];
        
    }
    
    
    
    CGSize viewSize = self.bounds.size;
    
    NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
    
    paragraph.alignment = NSTextAlignmentCenter;
    
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont boldSystemFontOfSize:fontSize],NSFontAttributeName,arcColor,NSForegroundColorAttributeName,[UIColor clearColor],NSBackgroundColorAttributeName,paragraph,NSParagraphStyleAttributeName,nil];
    
    
    [percent drawInRect:CGRectMake(5, (viewSize.height-fontSize)/2, viewSize.width-10, 2 *(fontSize +5))withAttributes:attributes];
    
    
    
}




/*
具体的调用就是

ProgressView *progress = [[ProgressViewalloc]initWithFrame:CGRectMake(detil.width-65, 10, 60, 60)];

progress.arcFinishColor = COLOR_STRING(@"#75AB33");

progress.arcUnfinishColor = COLOR_STRING(@"#0D6FAE");

progress.arcBackColor = COLOR_STRING(@"#EAEAEA");

progress.percent = 1;

[detil addSubview:progress];
*/


@end
