#import "User.h"


@implementation User

@dynamic username;
@dynamic expenses;
@dynamic totalExpenses;

-(void)computeTotalExpenses
{
    NSNumber *total = [self valueForKeyPath:@"expenses.@sum.amount"];
    self.totalExpenses = total;
}
@end
