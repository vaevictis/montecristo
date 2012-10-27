#import "UserDetail.h"

@implementation UserDetail

@synthesize managedObjectContext;
@synthesize currentUser;
@synthesize usernameField;

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];

    if (currentUser)
    {
        usernameField.text = currentUser.username;
    }
}

#pragma mark - Core Data lifecycle

- (void)performSave
{
    if (!currentUser)
        self.currentUser = (User *)[NSEntityDescription insertNewObjectForEntityForName:@"User" inManagedObjectContext:self.managedObjectContext];

    self.currentUser.username = [usernameField text];

    NSError *error;
    if (![self.managedObjectContext save:&error]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Have you checked your entries?"
                                                        message:@"User name is compulsory."
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