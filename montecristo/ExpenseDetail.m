#import "ExpenseDetail.h"
#import "Category.h"
#import "CoreDataHelper.h"
#import "User.h"

@implementation ExpenseDetail

@synthesize managedObjectContext;
@synthesize currentExpense, currentCategory;
@synthesize titleField, amountField;
@synthesize usersData;
@synthesize userPicker;
@synthesize selectedUser;

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];

    usersData  = [CoreDataHelper getObjectsForEntity:@"User" withSortKey:@"username" andSortAscending:YES andContext:managedObjectContext];

    if (currentExpense)
    {
        [titleField setText:[currentExpense title]];
        [amountField setText:[currentExpense.amount stringValue]];

        if ([currentExpense user]) {
            NSUInteger offsetRow = [usersData indexOfObject:currentExpense.user] + 1;
            [userPicker selectRow:offsetRow inComponent:0 animated:NO];
        }
    }
}

#pragma mark - Saving

-(void)performSaveAndExit
{
    if (!currentExpense) {
        self.currentExpense = (Expense *)[NSEntityDescription insertNewObjectForEntityForName:@"Expense" inManagedObjectContext:self.managedObjectContext];

        NSDate *now = [[NSDate alloc] init];
        [self.currentExpense setTimestamp:now];
    }

    [self.currentExpense setTitle:[titleField text]];

    if (currentExpense) {
        self.selectedUser = currentExpense.user;
    }

    NSNumberFormatter *amountFormatter = [[NSNumberFormatter alloc] init];
    [amountFormatter setNumberStyle:NSNumberFormatterDecimalStyle];

    [self.currentExpense setAmount:[amountFormatter numberFromString:amountField.text]];
    self.currentExpense.category = currentCategory;
    self.currentExpense.user = selectedUser;

    NSError *error;
    if (![self.managedObjectContext save:&error]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Have you checked your entries?"
                                                        message:@"Title is compulsory.\nAmount must be a number.\nAuthor must be chosen."
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}


#pragma mark - Button actions

- (IBAction)switchFieldOrCloseKeyboard:(id)sender
{
    UITextField *tf = (UITextField *)sender;
    if (tf.tag == 1) {
        [amountField becomeFirstResponder];
    } else {
        [sender resignFirstResponder];
    }
}

- (IBAction)editSaveButtonPressed:(id)sender
{
    [self performSaveAndExit];
}


#pragma mark - PickerView DataSource

- (NSInteger)numberOfComponentsInPickerView:
(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView
numberOfRowsInComponent:(NSInteger)component
{
    return [usersData count] + 1;
}

- (NSString *)pickerView:(UIPickerView *)pickerView
             titleForRow:(NSInteger)row
            forComponent:(NSInteger)component
{
    if (row == 0) {
        return @"Choose...";
    } else {
        return [[usersData objectAtIndex:row - 1] username];
    }
}


#pragma mark - PickerView Delegate
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row
      inComponent:(NSInteger)component
{
    if (row != 0)
        self.selectedUser = [usersData objectAtIndex:row - 1];
}
@end