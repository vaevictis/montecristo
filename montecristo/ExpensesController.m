#import "ExpensesController.h"
#import "Expense.h"
#import "CoreDataHelper.h"
#import "ExpenseDetail.h"
#import "Category.h"

@implementation ExpensesController

@synthesize managedObjectContext, expensesData, currentCategory;

//  When the view reappears, read new data for table
- (void)viewWillAppear:(BOOL)animated
{
    //  Repopulate the array with new table data
    [self readDataForTable];

    self.title = currentCategory.title;
}

//  Grab data for table - this will be used whenever the list appears or reappears after an add/edit
- (void)readDataForTable
{
    //  Grab the data
    NSPredicate *categoryExpenses = [NSPredicate predicateWithFormat:@"category == %@", currentCategory];

    expensesData = [CoreDataHelper searchObjectsForEntity:@"Expense"
                                            withPredicate:categoryExpenses
                                               andSortKey:@"timestamp"
                                         andSortAscending:NO
                                               andContext:managedObjectContext];

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

//  Return the number of sections in the table
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

//  Return the number of rows in the section (the amount of items in our array)
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [expensesData count];
}

//  Create / reuse a table cell and configure it for display
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }

    // Get the core data object we need to use to populate this table cell
    Expense *currentExpense = [expensesData objectAtIndex:indexPath.row];

    //  Fill in the cell contents
    cell.textLabel.text = currentExpense.title;
    cell.detailTextLabel.text = [currentExpense.amount stringValue];

    //  If a picture exists then use it
    if ([currentExpense picture])
    {
        cell.imageView.contentMode = UIViewContentModeScaleAspectFit;
        cell.imageView.image = [UIImage imageWithData:[currentExpense picture]];
    }

    return cell;
}

//  Swipe to delete has been used.  Remove the table item
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        //  Get a reference to the table item in our data array
        Expense *itemToDelete = [self.expensesData objectAtIndex:indexPath.row];

        //  Delete the item in Core Data
        [self.managedObjectContext deleteObject:itemToDelete];

        //  Remove the item from our array
        [expensesData removeObjectAtIndex:indexPath.row];

        //  Commit the deletion in core data
        NSError *error;
        if (![self.managedObjectContext save:&error])
            NSLog(@"Failed to delete expense item with error: %@", [error domain]);

        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

//  When add is pressed or a table row is selected
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    //  Get a reference to our detail view
    ExpenseDetail *expenseDetail = (ExpenseDetail *)[segue destinationViewController];

    //  Pass the managed object context to the destination view controller
    expenseDetail.managedObjectContext = managedObjectContext;

    // Pass the current category, be it in edition or creation of an expense
    expenseDetail.currentCategory = currentCategory;


    //  If we are editing a category we need to pass some stuff, so check the segue title first
    if ([[segue identifier] isEqualToString:@"EditExpense"])
    {
        //  Get the row we selected to view
        NSInteger selectedIndex = [[self.tableView indexPathForSelectedRow] row];

        //  Pass the expense object from the table that we want to view
        expenseDetail.currentExpense = [expensesData objectAtIndex:selectedIndex];
    }
}

@end
