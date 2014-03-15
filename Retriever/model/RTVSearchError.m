//
//  RTVSearchError.m
//  Retriever
//
//  Created by Chris Mitchelmore on 15/03/2014.
//  Copyright (c) 2014 Retriever Company. All rights reserved.
//

#import "RTVSearchError.h"

@implementation RTVSearchError

- (instancetype)initWithMessage:(NSString *)message corrections:(NSArray *)corrections suggestions:(NSArray *)suggestions
{
    self = [super init];
    if (self) {
        _message = message;
        _corrections = corrections;
        _suggestions = suggestions;
    }
    return self;
}


@end
