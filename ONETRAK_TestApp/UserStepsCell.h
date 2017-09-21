//
//  UserStepsCell.h
//  ONETRAK_TestApp
//
//  Created by iStef on 20.09.17.
//  Copyright © 2017 Stefanov. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserStepsCell : UITableViewCell

@property (assign, nonatomic) BOOL firstAppearance;

@property (assign, nonatomic) CGFloat currentWidth;

@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *stepsGoalLabel;

@property (strong, nonatomic) UIView *walkProgressBar;
@property (strong, nonatomic) UIView *aerobicProgressBar;
@property (strong, nonatomic) UIView *runProgressBar;

@property (weak, nonatomic) IBOutlet UILabel *walkStepsAmount;
@property (weak, nonatomic) IBOutlet UILabel *aerobicStepsAmount;
@property (weak, nonatomic) IBOutlet UILabel *runStepsAmount;

@property (weak, nonatomic) IBOutlet UILabel *walkLabel;
@property (weak, nonatomic) IBOutlet UILabel *aerobicLabel;
@property (weak, nonatomic) IBOutlet UILabel *runLabel;


@end
