//
//  RTVSearchResponse.h
//  Retriever
//
//  Created by Chris Mitchelmore on 15/03/2014.
//  Copyright (c) 2014 Retriever Company. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RTVItem.h"
@interface RTVSearchResponse : NSObject


@property (nonatomic, strong, readonly) NSString *originalQuery;
@property (nonatomic, strong, readonly) NSString *matchedQuery;
@property (nonatomic, strong, readonly) NSNumber *totalItems;
@property (nonatomic, strong, readonly) NSString *responseType;
@property (nonatomic, strong, readonly) NSArray *items;

- (instancetype)initWithOriginalQuery:(NSString *)originalQuery matchedQuery:(NSString *)matchedQuery totalItems:(NSNumber *)totalItems responseType:(NSString *)responseType items:(NSArray *)items;

@end
