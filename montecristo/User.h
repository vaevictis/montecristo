#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Expense;

@interface User : NSManagedObject

@property (nonatomic, retain) NSString * username;
@property (nonatomic, retain) NSSet *expenses;

@end

@interface User (CoreDataGeneratedAccessors)

- (void)addExpensesObject:(Expense *)value;
- (void)removeExpensesObject:(Expense *)value;
- (void)addExpenses:(NSSet *)values;
- (void)removeExpenses:(NSSet *)values;
- (void)computeTotalExpenses;

@end
