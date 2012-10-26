#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Category;

@interface Expense : NSManagedObject

@property (nonatomic, retain) NSDate    * timestamp;
@property (nonatomic, retain) NSString  * title;
@property (nonatomic, retain) NSNumber  * amount;
@property (nonatomic, retain) Category  * category;
@property (nonatomic, retain) NSData    * picture;

@end
