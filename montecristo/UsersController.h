#import <UIKit/UIKit.h>

@interface UsersController : UITableViewController

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) NSMutableArray *usersData;
@property (strong, nonatomic) NSNumber *overallExpenses;

- (void)readDataForTable;

@end
