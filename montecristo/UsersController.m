#import "UsersController.h"
#import "CoreDataHelper.h"
#import "ExpensesController.h"
#import "User.h"
#import "Expense.h"
#import "UserDetail.h"


@interface UsersController ()

@end

@implementation UsersController

@synthesize managedObjectContext, usersData, overallExpenses;

- (void)viewWillAppear:(BOOL)animated
{
    [self readDataForTable];
    [self computeUsersExpenses];
    [self computeOverallExpenses];
    self.title = [NSString stringWithFormat:@"total: %@", [overallExpenses stringValue]];
}

- (void)readDataForTable
{
    usersData = [CoreDataHelper getObjectsForEntity:@"User" withSortKey:@"username" andSortAscending:YES andContext:managedObjectContext];

    [self.tableView reloadData];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [usersData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }

    User *currentCell = [usersData objectAtIndex:indexPath.row];
    [currentCell computeTotalExpenses];

    cell.textLabel.text = [NSString stringWithFormat:@"%@  (%@)", [currentCell username], [[currentCell totalExpenses] stringValue]];

    NSNumber *currentCellBalance = [self computeBalance:currentCell];

    if ([currentCellBalance floatValue] > 0.0) {
        cell.detailTextLabel.textColor = [UIColor colorWithRed: 104.0/255.0 green: 200.0/255.0 blue: 33.0/255.0 alpha:1.0];
    } else if ([currentCellBalance floatValue] < 0.0) {
        cell.detailTextLabel.textColor = [UIColor colorWithRed: 176.0/255.0 green: 0.0 blue: 45.0/255.0 alpha:1.0];
    }

    cell.detailTextLabel.text = [[self computeBalance:currentCell] stringValue];

    return cell;
}

-(NSNumber *)computeBalance:(User *)user
{
    float totalExpensesFloat = [[user totalExpenses] floatValue];
    float overallExpensesFloat = [[self overallExpenses] floatValue];

    NSNumber *userSizeNumber = [NSNumber numberWithUnsignedInt:[self.usersData count] ];

    float userSizeFloat =  [userSizeNumber floatValue];

    float balanceFloat = totalExpensesFloat - (overallExpensesFloat / userSizeFloat);

    return [NSNumber numberWithFloat:balanceFloat];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        User *itemToDelete = [self.usersData objectAtIndex:indexPath.row];
        [self.managedObjectContext deleteObject:itemToDelete];
        [usersData removeObjectAtIndex:indexPath.row];

        NSError *error;
        if (![self.managedObjectContext save:&error])
            NSLog(@"Failed to delete category item with error: %@", [error domain]);

        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        [self computeOverallExpenses];
        [self computeUsersExpenses];
    }
}


#pragma mark - Computations

-(void)computeUsersExpenses
{
    for (User *user in usersData) {
        [user computeTotalExpenses];
    }
}

-(void)computeOverallExpenses{
    NSArray *expensesData = [CoreDataHelper getObjectsForEntity:@"Expense"
                                                    withSortKey:@"title"
                                               andSortAscending:YES
                                                     andContext:managedObjectContext];

    float total = 0.0;

    for (Expense *exp in expensesData) {
        total += [[exp amount] floatValue];
    }

    NSNumber *grandTotal = [NSNumber numberWithFloat:total];

    self.overallExpenses = grandTotal;
}

#pragma mark - segues handling

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    UserDetail *userDetail = (UserDetail *)[segue destinationViewController];

    userDetail.managedObjectContext = managedObjectContext;

    if ([[segue identifier] isEqualToString:@"EditUser"])
    {
        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
        NSInteger selectedIndex = [indexPath row];

        userDetail.currentUser = [usersData objectAtIndex:selectedIndex];
    }
}

@end
