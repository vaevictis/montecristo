#import "CategoriesController.h"
#import "Category.h"
#import "CoreDataHelper.h"
#import "CategoryDetail.h"

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

//  Return the number of sections in the table
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

//  Return the number of rows in the section (the amount of items in our array)
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [categoriesData count];
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
    Category *currentCell = [categoriesData objectAtIndex:indexPath.row];

    //  Fill in the cell contents
    cell.textLabel.text = [currentCell title];
    cell.detailTextLabel.text = @"Lorem ipsum";

    return cell;
}

//  Swipe to delete has been used.  Remove the table item
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        //  Get a reference to the table item in our data array
        Category *itemToDelete = [self.categoriesData objectAtIndex:indexPath.row];

        //  Delete the item in Core Data
        [self.managedObjectContext deleteObject:itemToDelete];

        //  Remove the item from our array
        [categoriesData removeObjectAtIndex:indexPath.row];

        //  Commit the deletion in core data
        NSError *error;
        if (![self.managedObjectContext save:&error])
            NSLog(@"Failed to delete category item with error: %@", [error domain]);

        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
}

//  When add is pressed or a table row is selected
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    //  Get a reference to our detail view
    CategoryDetail *categoryDetail = (CategoryDetail *)[segue destinationViewController];

    //  Pass the managed object context to the destination view controller
    categoryDetail.managedObjectContext = managedObjectContext;

    //  If we are editing a category we need to pass some stuff, so check the segue title first
    if ([[segue identifier] isEqualToString:@"EditCategory"])
    {
        //  Get the row we selected to view
        NSInteger selectedIndex = [[self.tableView indexPathForSelectedRow] row];

        //  Pass the category object from the table that we want to view
        categoryDetail.currentCategory = [categoriesData objectAtIndex:selectedIndex];
    }
}

@end