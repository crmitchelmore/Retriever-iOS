//
//  HistoryResponse.m
//  Retriever
//
//  Created by Chris Mitchelmore on 15/03/2014.
//  Copyright (c) 2014 Retriever Company. All rights reserved.
//

#import "HistoryResponse.h"
#import "HistoryItem.h"
#import "RTVSearchResponse.h"

@implementation HistoryResponse

+ (instancetype)historyResponseWithSearchResponse:(RTVSearchResponse *)searchResponse context:(NSManagedObjectContext *)context
{
    
    HistoryResponse *historyResponse = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([self class]) inManagedObjectContext:context];
    historyResponse.matchedQuery = searchResponse.matchedQuery;
    historyResponse.responseType = searchResponse.responseType;
    historyResponse.originalQuery = searchResponse.originalQuery;
    NSMutableSet *items = [NSMutableSet new];
    [searchResponse.items enumerateObjectsUsingBlock:^(RTVItem *item, NSUInteger idx, BOOL *stop) {
        [items addObject:[HistoryItem itemWithItem:item context:context]];
    }];
    historyResponse.date = [NSDate date];
    historyResponse.items = items;
    historyResponse.totalItems = searchResponse.totalItems;
    return historyResponse;
                                 
}

@end
