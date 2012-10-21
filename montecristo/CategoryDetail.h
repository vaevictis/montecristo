#import <UIKit/UIKit.h>
#import "Category.h"

@interface CategoryDetail : UITableViewController <UINavigationControllerDelegate>

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) Category *currentCategory;
@property (strong, nonatomic) IBOutlet UITextField *titleField;

@end
