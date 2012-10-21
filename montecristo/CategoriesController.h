#import <UIKit/UIKit.h>

@interface CategoriesController : UITableViewController

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) NSMutableArray *categoriesData;

- (void)readDataForTable;

@end