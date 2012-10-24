#import <UIKit/UIKit.h>
#import "Category.h"

@interface ExpensesController : UITableViewController

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) NSMutableArray *expensesData;
@property (strong, nonatomic) Category *currentCategory;

- (void)readDataForTable;

@end