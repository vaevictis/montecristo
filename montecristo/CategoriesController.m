#import "CategoriesController.h"
#import "Category.h"
#import "CoreDataHelper.h"
#import "CategoryDetail.h"
#import "ExpensesController.h"
#import "BalanceController.h"

@implementation CategoriesController

@synthesize managedObjectContext, categoriesData;

//  When the view reappears, read new data for table
- (void)viewWillAppear:(BOOL)animated
{
    //  Repopulate the array with new table data
    [self readDataForTable];
}

//  Grab data for table - this will be used whenever the list appears or reappears after an add/edit
- (void)readDataForTable
{
    //  Grab the data
    categoriesData = [CoreDataHelper getObjectsForEntity:@"Category" withSortKey:@"title" andSortAscending:YES andContext:managedObjectContext];

    //  Force table refresh
    [self.tableView reloadData];
}

#pragma mark - Actions

//  Button to log out of app (dismiss the modal view!)
- (IBAction)logoutButtonPressed:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [categoriesData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }

    Category *currentCell = [categoriesData objectAtIndex:indexPath.row];
    [currentCell computeTotalExpenses];

    cell.textLabel.text = [currentCell title];
    cell.detailTextLabel.text = [[currentCell totalExpenses] stringValue];

    return cell;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
                                            forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        Category *itemToDelete = [self.categoriesData objectAtIndex:indexPath.row];
        [self.managedObjectContext deleteObject:itemToDelete];
        [categoriesData removeObjectAtIndex:indexPath.row];

        NSError *error;
        if (![self.managedObjectContext save:&error])
            NSLog(@"Failed to delete category item with error: %@", [error domain]);

        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender 
{
    CategoryDetail *categoryDetail = (CategoryDetail *)[segue destinationViewController];

    categoryDetail.managedObjectContext = managedObjectContext;

    if ([[segue identifier] isEqualToString:@"EditCategory"])
    {
        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
        NSInteger selectedIndex = [indexPath row];

        categoryDetail.currentCategory = [categoriesData objectAtIndex:selectedIndex];
    }

    if ([[segue identifier] isEqualToString:@"Expenses"]) {
        ExpensesController *expensesController = (ExpensesController *)[segue destinationViewController];

        expensesController.managedObjectContext = managedObjectContext;

        NSInteger selectedIndex = [[self.tableView indexPathForSelectedRow] row];
        expensesController.currentCategory = [categoriesData objectAtIndex:selectedIndex];
    }

    if ([[segue identifier] isEqualToString:@"Balance"]) {
        BalanceController *balanceController = (BalanceController *)[segue destinationViewController];
        balanceController.managedObjectContext = self.managedObjectContext;
    }
}

@end