#import "ExpenseDetail.h"
#import "Category.h"
#import "CoreDataHelper.h"
#import "User.h"

@implementation ExpenseDetail

@synthesize managedObjectContext;
@synthesize currentExpense, currentCategory;
@synthesize titleField, amountField, imageField;
@synthesize imagePicker;
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

        if ([currentExpense picture])
            [imageField setImage:[UIImage imageWithData:[currentExpense picture]]];
    }
}

#pragma mark - Image editing

- (void)resizeAndSaveImage
{
    float resize = 74.0;
    float actualWidth = imageField.image.size.width;
    float actualHeight = imageField.image.size.height;
    float divBy, newWidth, newHeight;
    if (actualWidth > actualHeight) {
        divBy = (actualWidth / resize);
        newWidth = resize;
        newHeight = (actualHeight / divBy);
    } else {
        divBy = (actualHeight / resize);
        newWidth = (actualWidth / divBy);
        newHeight = resize;
    }
    CGRect rect = CGRectMake(0.0, 0.0, newWidth, newHeight);
    UIGraphicsBeginImageContext(rect.size);
    [imageField.image drawInRect:rect];
    UIImage *smallImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    NSData *imageData = UIImageJPEGRepresentation(smallImage, 1.0);
    [self.currentExpense setPicture:imageData];
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


    NSNumberFormatter *amountFormatter = [[NSNumberFormatter alloc] init];
    [amountFormatter setNumberStyle:NSNumberFormatterDecimalStyle];

    [self.currentExpense setAmount:[amountFormatter numberFromString:amountField.text]];
    self.currentExpense.category = currentCategory;
    self.currentExpense.user = selectedUser;

    if (imageField.image)
    {
        [self resizeAndSaveImage];
    }

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

- (IBAction)imageFromCamera:(id)sender
{
    imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.delegate = self;
    imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    imagePicker.cameraDevice = UIImagePickerControllerCameraDeviceRear;
    [self presentViewController:imagePicker animated:YES completion:nil];
}

#pragma mark - Image Picker Delegate Methods

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo
{
    [imagePicker dismissModalViewControllerAnimated:YES];
    [imageField setImage:image];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [imagePicker dismissViewControllerAnimated:YES completion:nil];
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