//
//  UserResultsTableViewController.m
//  ONETRAK_TestApp
//
//  Created by iStef on 20.09.17.
//  Copyright © 2017 Stefanov. All rights reserved.
//

#import "UserResultsTableViewController.h"
#import "Day+CoreDataClass.h"
#import "Day+CoreDataProperties.h"
#import "DataManager.h"
#import "UserStepsCell.h"
#import "GoalReachedCell.h"
#import "EmptyCell.h"

@interface UserResultsTableViewController ()

@property (assign, nonatomic) NSInteger stepsGoal;
@property (assign, nonatomic) BOOL firstTimeAnimate;
@property (assign, nonatomic) BOOL addingGoalAnimate;
@property (assign, nonatomic) BOOL addingStepsAnimate;


@end

@implementation UserResultsTableViewController

@synthesize fetchedResultsController = _fetchedResultsController;


- (void)viewDidLoad
{
    [super viewDidLoad];
        
    self.firstTimeAnimate = YES; //проверка для анимации звездочки
    
    self.stepsGoal = 4000;
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.navigationItem.title = @"Steps";
    
    UIBarButtonItem *deleteBarButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemTrash target:self action:@selector(deleteAllObjects:)];
    
    UIBarButtonItem *addBarButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Add"] style:UIBarButtonItemStylePlain target:self action:@selector(addNewDayAction:)];
                                     
    self.navigationItem.rightBarButtonItems = @[addBarButton, deleteBarButton];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Aim"] style:UIBarButtonItemStylePlain target:self action:@selector(designateStepsGoal:)];
    
    NSArray *users = [self.fetchedResultsController fetchedObjects];
    if (users.count == 0) {
        self.navigationItem.leftBarButtonItem.enabled = NO;
        self.navigationItem.rightBarButtonItems[1].enabled = NO;
    }else{
        self.navigationItem.leftBarButtonItem.enabled = YES;
        self.navigationItem.rightBarButtonItems[1].enabled = YES;
    }

}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    self.firstTimeAnimate = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSManagedObjectContext *)managedObjectContext
{
    if (!_managedObjectContext) {
        _managedObjectContext = [DataManager sharedManager].persistentContainer.viewContext;
    }
    return _managedObjectContext;
}


#pragma mark - Actions

-(void)addNewDayAction:(UIBarButtonItem *)item
{
    [self.tableView.layer removeAllAnimations];
    
    NSArray *days = [self.fetchedResultsController fetchedObjects];

    Day *newDay = [NSEntityDescription insertNewObjectForEntityForName:@"Day" inManagedObjectContext:[DataManager sharedManager].persistentContainer.viewContext];
    
    //Если дни не были добавлены, берем сегодняшнюю дату. Если были добавлены, берем последнюю добавленную дату и прибавляем сутки
    if (days.count == 0) {
        newDay.date = [NSDate dateWithTimeIntervalSinceNow:0];
        self.navigationItem.leftBarButtonItem.enabled = YES;
        self.navigationItem.rightBarButtonItems[1].enabled = YES;
    }else{
        Day *day = [days firstObject];
        newDay.date = [NSDate dateWithTimeInterval:86400 sinceDate:day.date];
    }
    
    //Генерируем количество разных шагов
    newDay.walkSteps = (arc4random() % 1900) + 100;
    newDay.aerobicSteps = (arc4random() % 2900) + 100;
    newDay.runSteps = (arc4random() % 4900) + 100;
    
    NSError *error = nil;
    
    if (![[DataManager sharedManager].persistentContainer.viewContext save:&error]) {
        NSLog(@"NEW USER SAVING ERROR: %@", error.localizedDescription);
    }
    
    //Анимируем элементы вновь добавленной ячейки
    self.addingGoalAnimate = YES;
    self.addingStepsAnimate = YES;
}

-(void)deleteAllObjects:(UIBarButtonItem *)item
{
    [self.tableView.layer removeAllAnimations];
    
    NSManagedObjectContext *context = [self.fetchedResultsController managedObjectContext];
    
    NSArray *days = [self.fetchedResultsController fetchedObjects];
    
    for (Day* day in days) {
        [context deleteObject:day];
    }
    
    NSError *error = nil;
    if (![context save:&error]) {
        NSLog(@"ERROR DURING COURSE DELETING: %@", error.localizedDescription);
        abort();
    }
    
    self.navigationItem.leftBarButtonItem.enabled = NO;
    self.navigationItem.rightBarButtonItems[1].enabled = NO;
}

-(void)designateStepsGoal:(UIBarButtonItem *)item
{
    [self.tableView.layer removeAllAnimations];

    UIAlertController *alertContr = [UIAlertController alertControllerWithTitle:@"Установите цель" message:@"Укажите ежедневное необходимое количество шагов" preferredStyle:UIAlertControllerStyleAlert];
    [alertContr addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.delegate = self;
        textField.keyboardType = UIKeyboardTypeNumberPad;
    }];
    [alertContr addAction:[UIAlertAction actionWithTitle:@"Готово" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        self.stepsGoal = alertContr.textFields.firstObject.text.integerValue;
        [self.tableView reloadData];
    }]];
    [self presentViewController:alertContr animated:YES completion:nil];
}


#pragma mark - UITableViewDataSource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    NSArray *allDays = [self.fetchedResultsController fetchedObjects];
    if (allDays.count == 0) {
        return 1;
        
    }else{
        id <NSFetchedResultsSectionInfo> sectionInfo = [self.fetchedResultsController sections][0];
        
        return [sectionInfo numberOfObjects];
    }
}
 
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *allDays = [self.fetchedResultsController fetchedObjects];
    if (allDays.count == 0) {
        return 1;
        
    }else{
        Day *day = [allDays objectAtIndex:section];
        NSInteger totalSteps = day.walkSteps + day.aerobicSteps + day.runSteps;
        
        if (totalSteps > self.stepsGoal) {
            return 2;
        }else{
            return 1;
        }
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *allDays = [self.fetchedResultsController fetchedObjects];
    
    if (allDays.count == 0) {
        static NSString *identifier = @"EmptyCell";
        
        EmptyCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        
        if (!cell) {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"EmptyCell" owner:self options:nil];
            cell = [nib firstObject];
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
        
    }else{
        
        Day *day = [self.fetchedResultsController objectAtIndexPath:[NSIndexPath indexPathForRow:indexPath.section inSection:0]];
        NSInteger totalSteps = day.walkSteps + day.aerobicSteps + day.runSteps;

        
        if (indexPath.row == 0) {
            
            static NSString *identifier = @"Cell";
            
            UserStepsCell *cell = (UserStepsCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
            
            if (!cell) {
                NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"UserStepsCell" owner:self options:nil];
                cell = [nib firstObject];
            }
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            NSDateFormatter *df = [[NSDateFormatter alloc]init];
            [df setDateFormat:@"dd.MM.yyyy"];
            NSString *userDate = [df stringFromDate:day.date];
            
            cell.dateLabel.text = userDate;
            
            cell.stepsGoalLabel.text = [NSString stringWithFormat:@"%ld / %ld steps", totalSteps, self.stepsGoal];
            
            cell.walkStepsAmount.text = [NSString stringWithFormat:@"%d", day.walkSteps];
            cell.aerobicStepsAmount.text = [NSString stringWithFormat:@"%d", day.aerobicSteps];
            cell.runStepsAmount.text = [NSString stringWithFormat:@"%d", day.runSteps];
            
            //Общая длина все прогресс баров без учета отступов
            CGFloat commonWidthOfBars = CGRectGetWidth(self.tableView.bounds) - 48;
            
            CGFloat anyViewWidth = (double)commonWidthOfBars/3 ;
            
            CGFloat lastBarMaxX = CGRectGetMaxX(self.tableView.bounds);
            
            //Добавляем сначала крайние прогресс бары
            CGRect walkFrame = CGRectMake(CGRectGetMinX(cell.dateLabel.frame), 46, anyViewWidth, 5);
            CGRect runFrame = CGRectMake(lastBarMaxX - anyViewWidth - 20, 46, anyViewWidth, 5);
            CGFloat deltaAerobicViewX = ((CGRectGetMinX(runFrame) - CGRectGetMaxX(walkFrame)) - anyViewWidth) / 2;
            //Теперь добавляем средний прогресс бар, опираясь на координаты крайних
            CGRect aerobicFrame = CGRectMake(CGRectGetMaxX(walkFrame) + deltaAerobicViewX, 46, anyViewWidth, 5);
            
            //Находим отношение отдельных видов шагов к общему количеству шагов
            CGFloat walkPart = (float)day.walkSteps/(float)totalSteps;
            CGFloat aerobicPart = (float)day.aerobicSteps/(float)totalSteps;
            CGFloat runPart = (float)day.runSteps/(float)totalSteps;
            
            //Создаем новые фреймы для прогресс баров, основной упор делая на длину по отношению к соответствующей части шагов
            CGRect newWalkProgressFrame = CGRectMake(CGRectGetMinX(walkFrame), CGRectGetMinY(walkFrame), commonWidthOfBars * walkPart, CGRectGetHeight(walkFrame));
            CGRect newAerobicProgressFrame = CGRectMake(CGRectGetMaxX(newWalkProgressFrame) + 5, CGRectGetMinY(aerobicFrame), commonWidthOfBars * aerobicPart, CGRectGetHeight(aerobicFrame));
            CGRect newRunProgressFrame = CGRectMake(CGRectGetMaxX(newAerobicProgressFrame) + 5, CGRectGetMinY(aerobicFrame), commonWidthOfBars * runPart, CGRectGetHeight(aerobicFrame));
            
            //Проверяем ячейку на первое появление, необходимое для добавления кастомного разделителя
            if (cell.firstAppearance) {
                UIView *upperSeparator = [[UIView alloc] initWithFrame:CGRectMake(0, 0.5, tableView.window.bounds.size.width, 0.5)];
                upperSeparator.backgroundColor = [UIColor lightGrayColor];
                [cell.contentView addSubview:upperSeparator];
                
                UIView *lowerSeparator = [[UIView alloc] initWithFrame:CGRectMake(0, cell.contentView.frame.size.height - 0.5, tableView.window.bounds.size.width, 0.5)];
                lowerSeparator.backgroundColor = [UIColor lightGrayColor];
                [cell.contentView addSubview:lowerSeparator];
                
                cell.firstAppearance = NO;
            }
            
            //Анимируем все ячейки при первом запуске приложения
            if (self.firstTimeAnimate) {
                cell.walkProgressBar.frame = walkFrame;
                cell.aerobicProgressBar.frame = aerobicFrame;
                cell.runProgressBar.frame = runFrame;
                
                [UIView animateWithDuration:2 delay:1 options:UIViewAnimationOptionCurveLinear
                                 animations:^{
                                     cell.walkProgressBar.frame = newWalkProgressFrame;
                                     cell.aerobicProgressBar.frame = newAerobicProgressFrame;
                                     cell.runProgressBar.frame = newRunProgressFrame;
                                 }
                                 completion:^(BOOL finished) {
                                     
                                 }];
                
            //Просто перерисовываем уже созданные ячейки
            }else if (indexPath.section != 0 && self.firstTimeAnimate == NO) {
                cell.walkProgressBar.frame = newWalkProgressFrame;
                cell.aerobicProgressBar.frame = newAerobicProgressFrame;
                cell.runProgressBar.frame = newRunProgressFrame;
                
            //Анимируем только первую ячейку первой секции при добавлении
            }else if (indexPath.section == 0 && self.firstTimeAnimate == NO && self.addingStepsAnimate){
                cell.walkProgressBar.frame = walkFrame;
                cell.aerobicProgressBar.frame = aerobicFrame;
                cell.runProgressBar.frame = runFrame;
                
                [UIView animateWithDuration:2 delay:1 options:UIViewAnimationOptionCurveLinear
                                 animations:^{
                                     cell.walkProgressBar.frame = newWalkProgressFrame;
                                     cell.aerobicProgressBar.frame = newAerobicProgressFrame;
                                     cell.runProgressBar.frame = newRunProgressFrame;
                                 }
                                 completion:^(BOOL finished) {
                                 }];
                
                self.addingStepsAnimate = NO; //отключаем повторную анимацию
            }
            
            return cell;
      
        }else{
            static NSString *identifier = @"GoalReached";
            
            GoalReachedCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            
            if (!cell) {
                NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"GoalReachedCell" owner:self options:nil];
                cell = [nib firstObject];
            }
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            //Проверяем ячейку на первое появление, необходимое для добавления кастомного разделителя
            if (cell.firstAppearance) {
                UIView *lowerSeparator = [[UIView alloc] initWithFrame:CGRectMake(0, cell.contentView.frame.size.height - 0.5, tableView.window.bounds.size.width, 0.5)];
                 lowerSeparator.backgroundColor = [UIColor lightGrayColor];
                 [cell.contentView addSubview:lowerSeparator];
                cell.firstAppearance = NO;
            }
            
            //Анимируем все ячейки при первом запуске приложения
            if (totalSteps > self.stepsGoal && self.firstTimeAnimate) {
                [UIView animateWithDuration:1 delay:1 options:UIViewAnimationOptionCurveLinear
                                 animations:^{
                                     cell.starImageView.transform = CGAffineTransformMakeScale(1.5, 1.5);
                                 }
                                 completion:^(BOOL finished) {
                        [UIView animateWithDuration:1 delay:0 options:UIViewAnimationOptionCurveLinear
                                 animations:^{
                                      cell.starImageView.transform = CGAffineTransformMakeScale(1, 1);
                                  }
                                  completion:^(BOOL finished) {
                                  }];
                     }];
            }
            
            //Анимируем только вторую ячейку первой секции при добавлении
            if (indexPath.section == 0 && totalSteps > self.stepsGoal &&
                self.firstTimeAnimate == NO && self.addingGoalAnimate) {
            
                [UIView animateWithDuration:1 delay:1 options:UIViewAnimationOptionCurveLinear
                                 animations:^{
                                     cell.starImageView.transform = CGAffineTransformMakeScale(1.5, 1.5);
                                 }
                                 completion:^(BOOL finished) {
                 [UIView animateWithDuration:1 delay:0 options:UIViewAnimationOptionCurveLinear
                                  animations:^{
                                      cell.starImageView.transform = CGAffineTransformMakeScale(1, 1);
                                  }
                                  completion:^(BOOL finished) {
                                  }];
             }];
                self.addingGoalAnimate = NO; //отключаем повторную анимацию
            }
            return cell;
        }
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}

- (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @" ";
}


#pragma mark - UITableViewDelegate

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    NSArray *allDays = [self.fetchedResultsController fetchedObjects];
    if (allDays.count == 0) {
        return nil;
    }else{
        if (section == 0) {
            UIView *headerView=[[UIView alloc]initWithFrame:CGRectMake(0,0, tableView.window.bounds.size.width, 50)];
            headerView.backgroundColor = [UIColor whiteColor];
            return headerView;
        }else{
            UIView *headerView=[[UIView alloc]initWithFrame:CGRectMake(0,0, tableView.window.bounds.size.width, 20)];
            headerView.backgroundColor = [UIColor whiteColor];

            return headerView;
        }
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *allDays = [self.fetchedResultsController fetchedObjects];
    if (allDays.count == 0) {
        return 44.f;
    }else{
        if (indexPath.row == 0) {
            return 101.f;
        }else{
            return 44.f;
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    NSArray *allDays = [self.fetchedResultsController fetchedObjects];
    if (allDays.count == 0) {
        return 0;
    }else{
        if (section == 0) {
            return 50.f;
        }else{
            return 20.f;
        }
    }
}


#pragma mark - Fetched Results Controller

-(NSFetchedResultsController *)fetchedResultsController
{
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    NSFetchRequest *request = [Day fetchRequest];
    
    NSSortDescriptor *dateDescriptor = [[NSSortDescriptor alloc] initWithKey:@"date" ascending:NO];
    
    [request setSortDescriptors:@[dateDescriptor]];
    
    [request setFetchBatchSize:20];
    
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:nil];
    
    aFetchedResultsController.delegate = self;
    
    NSError *error = nil;
    
    if (![aFetchedResultsController performFetch:&error]) {
        NSLog(@"USER ERROR: %@", error.localizedDescription);
        abort();
    }
    
    _fetchedResultsController = aFetchedResultsController;
    
    return _fetchedResultsController;
}

-(void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView reloadData];
}

@end
