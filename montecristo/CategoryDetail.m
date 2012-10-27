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

    NSError *error;
    if (![self.managedObjectContext save:&error]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Have you checked your entries?"
                                                        message:@"Title is compulsory."
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
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