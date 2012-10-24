#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Expense;

@interface Category : NSManagedObject

@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSSet *expenses;
@property (nonatomic, retain) NSNumber *totalExpenses;
@end

@interface Category (CoreDataGeneratedAccessors)

- (void)addExpensesObject:(Expense *)value;
- (void)removeExpensesObject:(Expense *)value;
- (void)addExpenses:(NSSet *)values;
- (void)removeExpenses:(NSSet *)values;
- (void)getTotalExpenses;

@end
