#import <UIKit/UIKit.h>
#import "User.h"

@interface UserDetail : UITableViewController <UINavigationControllerDelegate>

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) User *currentUser;
@property (strong, nonatomic) IBOutlet UITextField *usernameField;

@end
