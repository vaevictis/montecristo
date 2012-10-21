#import "ExpensesController.h"
#import "Expense.h"
#import "CoreDataHelper.h"

@implementation ExpensesController

@synthesize managedObjectContext, expensesData;

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
    expensesData = [CoreDataHelper getObjectsForEntity:@"Expense" withSortKey:@"timestamp" andSortAscending:NO andContext:managedObjectContext];

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
    Expense *currentCell = [expensesData objectAtIndex:indexPath.row];

    //  Fill in the cell contents
    cell.textLabel.text = [currentCell title];
    cell.detailTextLabel.text = @"Expense ipsum";

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
//- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
//{
//    //  Get a reference to our detail view
//    Expense *expenseDetail = (ExpenseDetail *)[segue destinationViewController];
//
//    //  Pass the managed object context to the destination view controller
//    categoryDetail.managedObjectContext = managedObjectContext;
//
//    //  If we are editing a category we need to pass some stuff, so check the segue title first
//    if ([[segue identifier] isEqualToString:@"EditExpense"])
//    {
//        //  Get the row we selected to view
//        NSInteger selectedIndex = [[self.tableView indexPathForSelectedRow] row];
//
//        //  Pass the expense object from the table that we want to view
//        expenseDetail.currentExpense = [expensesData objectAtIndex:selectedIndex];
//    }
//}

@end











//#import "ExpensesController.h"
//
//@interface ExpensesController ()
//
//@end
//
//@implementation ExpensesController
//
//- (id)initWithStyle:(UITableViewStyle)style
//{
//    self = [super initWithStyle:style];
//    if (self) {
//        // Custom initialization
//    }
//    return self;
//}
//
//- (void)viewDidLoad
//{
//    [super viewDidLoad];
//
//    // Uncomment the following line to preserve selection between presentations.
//    // self.clearsSelectionOnViewWillAppear = NO;
// 
//    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
//    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
//}
//
//- (void)didReceiveMemoryWarning
//{
//    [super didReceiveMemoryWarning];
//    // Dispose of any resources that can be recreated.
//}
//
//#pragma mark - Table view data source
//
//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
//{
//#warning Potentially incomplete method implementation.
//    // Return the number of sections.
//    return 0;
//}
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
//{
//#warning Incomplete method implementation.
//    // Return the number of rows in the section.
//    return 0;
//}
//
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    static NSString *CellIdentifier = @"Cell";
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
//    
//    // Configure the cell...
//    
//    return cell;
//}
//
///*
//// Override to support conditional editing of the table view.
//- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    // Return NO if you do not want the specified item to be editable.
//    return YES;
//}
//*/
//
///*
//// Override to support editing the table view.
//- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    if (editingStyle == UITableViewCellEditingStyleDelete) {
//        // Delete the row from the data source
//        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
//    }   
//    else if (editingStyle == UITableViewCellEditingStyleInsert) {
//        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
//    }   
//}
//*/
//
///*
//// Override to support rearranging the table view.
//- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
//{
//}
//*/
//
///*
//// Override to support conditional rearranging of the table view.
//- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    // Return NO if you do not want the item to be re-orderable.
//    return YES;
//}
//*/
//
//#pragma mark - Table view delegate
//
//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    // Navigation logic may go here. Create and push another view controller.
//    /*
//     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
//     // ...
//     // Pass the selected object to the new view controller.
//     [self.navigationController pushViewController:detailViewController animated:YES];
//     */
//}
//
//@end
