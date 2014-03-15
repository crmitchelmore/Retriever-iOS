//
//  RTVItem.h
//  Retriever
//
//  Created by Chris Mitchelmore on 15/03/2014.
//  Copyright (c) 2014 Retriever Company. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RTVItem : NSObject

@property (nonatomic, strong, readonly) NSString *displayName;

- (instancetype)initWithDisplayName:(NSString *)displayName;

@end
