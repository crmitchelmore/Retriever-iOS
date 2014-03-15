//
//  HistoryItem.h
//  Retriever
//
//  Created by Chris Mitchelmore on 15/03/2014.
//  Copyright (c) 2014 Retriever Company. All rights reserved.
//

#import "_HistoryItem.h"
@class RTVItem;
@interface HistoryItem : _HistoryItem


+ (instancetype)itemWithItem:(RTVItem *)item context:(NSManagedObjectContext *)context;
@end
