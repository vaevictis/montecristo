#import "CategoryDetail.h"

@implementation CategoryDetail

@synthesize managedObjectContext;
@synthesize currentCategory;
@synthesize titleField;

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];

    if (currentCategory)
    {
        self.title      = [NSString stringWithFormat: @"Edit %@ category", currentCategory.title];
        titleField.text = currentCategory.title;
    } else {
        self.title = @"New category";
    }
}

#pragma mark - Core Data lifecycle

- (void)performSave
{
    if (!currentCategory)
        self.currentCategory = (Category *)[NSEntityDescription insertNewObjectForEntityForName:@"Category" inManagedObjectContext:self.managedObjectContext];

    [self.currentCategory setTitle:[titleField text]];

    //  Commit item to core data
    NSError *error;
    if (![self.managedObjectContext save:&error])
        NSLog(@"Failed to add new Category with error: %@", [error domain]);

    //  Automatically pop to previous view now we're done adding
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - Button actions


- (IBAction)editSaveButtonPressed:(id)sender
{
    [self performSave];
}

-(IBAction)doneEditing:(id)sender
{
    [sender resignFirstResponder];
    [self performSave];
}

@end