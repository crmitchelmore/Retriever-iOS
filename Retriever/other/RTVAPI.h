//
//  RTVAPI.h
//  Retriever
//
//  Created by Chris Mitchelmore on 15/03/2014.
//  Copyright (c) 2014 Retriever Company. All rights reserved.
//

#import <Foundation/Foundation.h>
@class RTVSearchResponse;
@class RTVSearchError;
typedef void (^RTVSearchSuccessBlock)(RTVSearchResponse*);
typedef void (^RTVFailureBlock)(RTVSearchError*);

@interface RTVAPI : NSObject


+ (void)searchForPhrase:(NSString *)phrase filter:(NSDictionary *)filter success:(RTVSearchSuccessBlock)success failure:(RTVFailureBlock)failure;

@end
