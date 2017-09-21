//
//  DataManager.h
//  ONETRAK_TestApp
//
//  Created by iStef on 20.09.17.
//  Copyright © 2017 Stefanov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface DataManager : NSObject

+(DataManager *)sharedManager;

@property (readonly, strong) NSPersistentContainer *persistentContainer;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

-(NSArray *)allDays;

- (void)saveContext;

@end
