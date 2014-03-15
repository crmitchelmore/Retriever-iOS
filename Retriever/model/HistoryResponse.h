//
//  HistoryResponse.h
//  Retriever
//
//  Created by Chris Mitchelmore on 15/03/2014.
//  Copyright (c) 2014 Retriever Company. All rights reserved.
//

#import "_HistoryResponse.h"

@class RTVSearchResponse;
@class HistoryItem;

@interface HistoryResponse : _HistoryResponse

+ (instancetype)historyResponseWithSearchResponse:(RTVSearchResponse *)searchResponse context:(NSManagedObjectContext *)context;

@end
