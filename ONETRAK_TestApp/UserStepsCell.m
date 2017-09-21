//
//  UserStepsCell.m
//  ONETRAK_TestApp
//
//  Created by iStef on 20.09.17.
//  Copyright © 2017 Stefanov. All rights reserved.
//

#import "UserStepsCell.h"

@implementation UserStepsCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.firstAppearance = YES;
    
    CGFloat commonBarsWidth = CGRectGetWidth(self.contentView.bounds) - 48;
    
    CGFloat anyViewWidth = (double)commonBarsWidth/3;
    
    CGFloat lastBarMaxX = commonBarsWidth;
    
    self.walkProgressBar = [[UIView alloc]initWithFrame:CGRectMake(CGRectGetMinX(self.dateLabel.frame), 46, anyViewWidth, 5)];
    self.walkProgressBar.backgroundColor = [UIColor colorWithRed:209.f/256.f green:242.f/256.f blue:255.f/256.f alpha:1];
    
    self.runProgressBar= [[UIView alloc]initWithFrame:CGRectMake(lastBarMaxX - anyViewWidth - 20, 46, anyViewWidth, 5)];
    self.runProgressBar.backgroundColor = [UIColor colorWithRed:102.f/256.f green:165.f/256.f blue:196.f/256.f alpha:1];
    
    CGFloat deltaAerobicViewX = ((CGRectGetMinX(self.runProgressBar.frame) - CGRectGetMaxX(self.walkProgressBar.frame)) - anyViewWidth) / 2;
    self.aerobicProgressBar=[[UIView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.walkProgressBar.frame) + deltaAerobicViewX, 46, anyViewWidth, 5)];
    self.aerobicProgressBar.backgroundColor = [UIColor colorWithRed:104.f/256.f green:210.f/256.f blue:238.f/256.f alpha:1];
    
    /*UIBezierPath *maskPath = [UIBezierPath
                              bezierPathWithRoundedRect:self.walkProgressBar.bounds
                              byRoundingCorners:(UIRectCornerTopLeft | UIRectCornerBottomLeft)
                              cornerRadii:CGSizeMake(2.5, 2.5)
                              ];
    
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    
    maskLayer.frame = self.walkProgressBar.bounds;
    maskLayer.path = maskPath.CGPath;
    
    self.walkProgressBar.layer.mask = maskLayer;*/
    
    [self.contentView addSubview:self.walkProgressBar];
    [self.contentView addSubview:self.aerobicProgressBar];
    [self.contentView addSubview:self.runProgressBar];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
