#import <UIKit/UIKit.h>
#import "Expense.h"

@interface ExpenseDetail : UITableViewController <UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIPickerViewDelegate, UIPickerViewDataSource>

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@property (strong, nonatomic) Expense *currentExpense;
@property (strong, nonatomic) Category *currentCategory;

@property (strong, nonatomic) IBOutlet UITextField *titleField;
@property (strong, nonatomic) IBOutlet UITextField *amountField;
@property (strong, nonatomic) IBOutlet UIImageView *imageField;

@property (strong, nonatomic) UIImagePickerController *imagePicker;

@property (strong, nonatomic) NSArray *usersData;
@property (strong, nonatomic) IBOutlet UIPickerView *userPicker;
@end
