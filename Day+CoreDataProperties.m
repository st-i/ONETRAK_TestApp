//
//  Day+CoreDataProperties.m
//  ONETRAK_TestApp
//
//  Created by iStef on 22.09.17.
//  Copyright © 2017 Stefanov. All rights reserved.
//

#import "Day+CoreDataProperties.h"

@implementation Day (CoreDataProperties)

+ (NSFetchRequest<Day *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"Day"];
}

@dynamic aerobicSteps;
@dynamic date;
@dynamic runSteps;
@dynamic walkSteps;

@end
