#import "Category.h"


@implementation Category

@dynamic expenses;
@dynamic title;
@dynamic totalExpenses;

- (void)computeTotalExpenses
{
    NSNumber *totalExpenses = [self valueForKeyPath:@"expenses.@sum.amount"];
    self.totalExpenses = totalExpenses;
}
@end
