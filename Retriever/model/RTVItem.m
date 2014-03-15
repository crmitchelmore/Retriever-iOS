//
//  RTVItem.m
//  Retriever
//
//  Created by Chris Mitchelmore on 15/03/2014.
//  Copyright (c) 2014 Retriever Company. All rights reserved.
//

#import "RTVItem.h"

@implementation RTVItem

- (instancetype)initWithDisplayName:(NSString *)displayName
{
    self = [super init];
    if (self) {
        _displayName = displayName;
    }
    return self;
}

@end
