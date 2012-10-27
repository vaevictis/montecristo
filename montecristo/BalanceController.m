#import "BalanceController.h"
#import "Category.h"
#import "CoreDataHelper.h"

@implementation BalanceController

@synthesize managedObjectContext, overallExpensesField;

- (void)viewDidLoad
{
    [super viewDidLoad];
	[self computeOverallExpenses];
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

- (IBAction)backToCategoriesButtonPressed:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
