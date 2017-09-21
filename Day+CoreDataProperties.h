//
//  Day+CoreDataProperties.h
//  ONETRAK_TestApp
//
//  Created by iStef on 22.09.17.
//  Copyright © 2017 Stefanov. All rights reserved.
//

#import "Day+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface Day (CoreDataProperties)

+ (NSFetchRequest<Day *> *)fetchRequest;

@property (nonatomic) int32_t aerobicSteps;
@property (nullable, nonatomic, copy) NSDate *date;
@property (nonatomic) int32_t runSteps;
@property (nonatomic) int32_t walkSteps;

@end

NS_ASSUME_NONNULL_END
