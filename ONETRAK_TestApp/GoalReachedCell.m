//
//  GoalReachedCell.m
//  ONETRAK_TestApp
//
//  Created by iStef on 21.09.17.
//  Copyright © 2017 Stefanov. All rights reserved.
//

#import "GoalReachedCell.h"

@implementation GoalReachedCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.firstAppearance = YES;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
