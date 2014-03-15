//
//  RTVSearchResponse.m
//  Retriever
//
//  Created by Chris Mitchelmore on 15/03/2014.
//  Copyright (c) 2014 Retriever Company. All rights reserved.
//

#import "RTVSearchResponse.h"

@implementation RTVSearchResponse


- (instancetype)initWithOriginalQuery:(NSString *)originalQuery matchedQuery:(NSString *)matchedQuery totalItems:(NSNumber *)totalItems responseType:(NSString *)responseType items:(NSArray *)items
{
    self = [super init];
    if ( self ){
        _originalQuery = originalQuery;
        _matchedQuery = matchedQuery;
        _totalItems = totalItems;
        _responseType = responseType;
        _items = items;
    }
    return self;
}

@end
