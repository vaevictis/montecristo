#import <UIKit/UIKit.h>
#import "Expense.h"

@interface ExpenseDetail : UITableViewController <UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@property (strong, nonatomic) Expense *currentExpense;
@property (strong, nonatomic) Category *currentCategory;

@property (strong, nonatomic) IBOutlet UITextField *titleField;
@property (strong, nonatomic) IBOutlet UITextField *amountField;
@property (strong, nonatomic) IBOutlet UIImageView *imageField;

@property (strong, nonatomic) UIImagePickerController *imagePicker;

@end
