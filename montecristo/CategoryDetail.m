#import "CategoryDetail.h"

@implementation CategoryDetail

@synthesize managedObjectContext;
@synthesize currentCategory;
@synthesize titleField;

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];

    // If we are editing an existing Category, then put the details from Core Data into the text fields for displaying
    if (currentCategory)
    {
        self.title      = [NSString stringWithFormat: @"Edit %@ category", currentCategory.title];
        titleField.text = currentCategory.title;
    } else {
        self.title = @"New category";
    }
}

#pragma mark - Button actions

- (IBAction)editSaveButtonPressed:(id)sender
{
    // If we are adding a new Category (because we didnt pass one from the table) then create an entry
    if (!currentCategory)
        self.currentCategory = (Category *)[NSEntityDescription insertNewObjectForEntityForName:@"Category" inManagedObjectContext:self.managedObjectContext];

    // For both new and existing Categorys, fill in the details from the form
    [self.currentCategory setTitle:[titleField text]];

    //  Commit item to core data
    NSError *error;
    if (![self.managedObjectContext save:&error])
        NSLog(@"Failed to add new Category with error: %@", [error domain]);

    //  Automatically pop to previous view now we're done adding
    [self.navigationController popViewControllerAnimated:YES];
}

//  Resign the keyboard after Done is pressed when editing text fields
- (IBAction)resignKeyboard:(id)sender
{
    [sender resignFirstResponder];
}

@end