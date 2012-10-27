#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Category;
@class User;

@interface Expense : NSManagedObject

@property (nonatomic, retain) NSDate    * timestamp;
@property (nonatomic, retain) NSString  * title;
@property (nonatomic, retain) NSNumber  * amount;
@property (nonatomic, retain) Category  * category;
@property (nonatomic, retain) NSData    * picture;
@property (nonatomic, retain) User      * user;

@end
