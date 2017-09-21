//
//  UserResultsTableViewController.h
//  ONETRAK_TestApp
//
//  Created by iStef on 20.09.17.
//  Copyright © 2017 Stefanov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface UserResultsTableViewController : UITableViewController <NSFetchedResultsControllerDelegate, UITextFieldDelegate>

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@end
