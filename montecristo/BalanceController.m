#import "BalanceController.h"
#import "Category.h"
#import "User.h"
#import "CoreDataHelper.h"

@implementation BalanceController

@synthesize managedObjectContext, overallExpensesField, customView;

- (void)viewDidLoad
{
    [super viewDidLoad];
	[self computeOverallExpenses];
    [self displayUsersExpenses];
}

-(void)computeOverallExpenses{
    NSArray *categoriesData = [CoreDataHelper getObjectsForEntity:@"Category" withSortKey:@"title" andSortAscending:YES andContext:managedObjectContext];

    float total = 0.0;

    for (Category *cat in categoriesData) {
        [cat computeTotalExpenses];
        total += [[cat totalExpenses] floatValue];
    }

    self.overallExpensesField.text = [[NSNumber numberWithFloat:total] stringValue];
}

-(void)displayUsersExpenses
{
    NSArray *usersData = [CoreDataHelper getObjectsForEntity:@"User" withSortKey:@"username" andSortAscending:YES andContext:managedObjectContext];

    for (User *user in usersData) {
        [user computeTotalExpenses];

        NSString *totalForUser = [[user totalExpenses] stringValue];

        NSLog(@"expenses of %@: %@", user.username, totalForUser);
//        UILabel *label = [[UILabel alloc] init];
        NSLog(@"custom view: %@", self.customView);

//        [self.customView addSubView:label];

    }
}


- (IBAction)backToCategoriesButtonPressed:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
