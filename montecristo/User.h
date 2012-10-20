//
//  User.h
//  montecristo
//
//  Created by vaevictis on 21/10/12.
//  Copyright (c) 2012 boost. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface User : NSManagedObject

@property (nonatomic, retain) NSString * password;
@property (nonatomic, retain) NSString * username;

@end
