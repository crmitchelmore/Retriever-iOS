//
//  HistoryItem.m
//  Retriever
//
//  Created by Chris Mitchelmore on 15/03/2014.
//  Copyright (c) 2014 Retriever Company. All rights reserved.
//

#import "HistoryItem.h"
#import "RTVItem.h"

@implementation HistoryItem

+ (instancetype)itemWithItem:(RTVItem *)item context :(NSManagedObjectContext *)context
{
    HistoryItem *historyItem = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([self class]) inManagedObjectContext:context];
    historyItem.displayName = item.displayName;
    return historyItem;
}

@end
