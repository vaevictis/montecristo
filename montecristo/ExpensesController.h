#import <UIKit/UIKit.h>

@interface ExpensesController : UITableViewController

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) NSMutableArray *expensesData;

- (void)readDataForTable;

@end