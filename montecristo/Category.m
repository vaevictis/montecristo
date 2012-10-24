//
//  Category.m
//  montecristo
//
//  Created by vaevictis on 21/10/12.
//  Copyright (c) 2012 boost. All rights reserved.
//

#import "Category.h"


@implementation Category

@dynamic expenses;
@dynamic title;
@dynamic totalExpenses;

- (void)getTotalExpenses
{
    NSNumber *totalExpenses = [self valueForKeyPath:@"expenses.@sum.amount"];
    self.totalExpenses = totalExpenses;
}
@end
