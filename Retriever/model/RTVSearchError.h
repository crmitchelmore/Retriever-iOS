//
//  RTVSearchError.h
//  Retriever
//
//  Created by Chris Mitchelmore on 15/03/2014.
//  Copyright (c) 2014 Retriever Company. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RTVSearchError : NSObject

@property (nonatomic, strong, readonly) NSString *message;
@property (nonatomic, strong, readonly) NSArray *corrections;
@property (nonatomic, strong, readonly) NSArray *suggestions;

- (instancetype)initWithMessage:(NSString *)message corrections:(NSArray *)corrections suggestions:(NSArray *)suggestions;

@end
