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

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];

    usersData  = [CoreDataHelper getObjectsForEntity:@"User" withSortKey:@"username" andSortAscending:YES andContext:managedObjectContext];

    if (currentExpense)
    {
        [titleField setText:[currentExpense title]];
        [amountField setText:[currentExpense.amount stringValue]];

        NSUInteger row = [usersData indexOfObject:currentExpense.user];
        [userPicker selectRow:row inComponent:0 animated:NO];

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
    if (!currentExpense)
        self.currentExpense = (Expense *)[NSEntityDescription insertNewObjectForEntityForName:@"Expense" inManagedObjectContext:self.managedObjectContext];

    [self.currentExpense setTitle:[titleField text]];

    NSNumberFormatter *amountFormatter = [[NSNumberFormatter alloc] init];
    [amountFormatter setNumberStyle:NSNumberFormatterDecimalStyle];

    [self.currentExpense setAmount:[amountFormatter numberFromString:amountField.text]];
    self.currentExpense.category = currentCategory;

    if (imageField.image)
    {
        [self resizeAndSaveImage];
    }

    NSError *error;
    if (![self.managedObjectContext save:&error])
        NSLog(@"Failed to add new expense with error: %@", [error domain]);

    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Button actions

- (IBAction)switchFieldOrSave:(id)sender
{
    UITextField *tf = (UITextField *)sender;
    if (tf.tag == 1) {
        [amountField becomeFirstResponder];
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:1 inSection:1];
        [self.tableView scrollToRowAtIndexPath:indexPath
                              atScrollPosition:UITableViewScrollPositionTop
                                      animated:YES];
    } else {
        [sender resignFirstResponder];
        [self performSaveAndExit];
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
    return [usersData count];
}

- (NSString *)pickerView:(UIPickerView *)pickerView
             titleForRow:(NSInteger)row
            forComponent:(NSInteger)component
{
    return [[usersData objectAtIndex:row] username];
}

#pragma mark - PickerView Delegate
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row
      inComponent:(NSInteger)component
{
    [self.currentExpense setUser:[usersData objectAtIndex:row]];
}
@end