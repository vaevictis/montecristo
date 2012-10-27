#import "User.h"


@implementation User

@dynamic username;
@dynamic expenses;
@dynamic totalExpenses;

-(void)computeTotalExpenses
{
    NSNumber *totalExpenses = [self valueForKeyPath:@"expenses.@sum.amount"];
    self.totalExpenses = totalExpenses;
}
@end
