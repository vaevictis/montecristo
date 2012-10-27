#import <UIKit/UIKit.h>

@interface BalanceController : UIViewController

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) IBOutlet UILabel *overallExpensesField;

@end
