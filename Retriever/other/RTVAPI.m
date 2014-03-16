//
//  RTVAPI.m
//  Retriever
//
//  Created by Chris Mitchelmore on 15/03/2014.
//  Copyright (c) 2014 Retriever Company. All rights reserved.
//

#import "RTVAPI.h"
//Model
#import "RTVSearchResponse.h"
#import "RTVSearchError.h"
#include <CommonCrypto/CommonDigest.h>


@implementation RTVAPI

static const NSString * kRTVResponseOriginalQueryKey = @"query";
static const NSString * kRTVResponseMatchedQueryKey = @"matched";
static const NSString * kRTVResponseTotalItemsKey = @"total_items";
static const NSString * kRTVResponseTypeKey = @"handler";
static const NSString * kRTVResponseItemsKey = @"items";

static const NSString * kRTVResponseItemDisplayNameKey = @"display_name";

static const NSString * kRTVErrorKey = @"error";
static const NSString * kRTVErrorMessageKey = @"message";
static const NSString * kRTVErrorCorrectionsKey = @"corrections";
static const NSString * kRTVErrorSuggestionsKey = @"suggestions";

static NSString * const kAFCharactersToBeEscapedInQueryString = @":/?&=;+!@#$()',*";

static NSString * AFPercentEscapedQueryStringKeyFromStringWithEncoding(NSString *string, NSStringEncoding encoding) {
    static NSString * const kAFCharactersToLeaveUnescapedInQueryStringPairKey = @"[].";
    
	return (__bridge_transfer  NSString *)CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (__bridge CFStringRef)string, (__bridge CFStringRef)kAFCharactersToLeaveUnescapedInQueryStringPairKey, (__bridge CFStringRef)kAFCharactersToBeEscapedInQueryString, CFStringConvertNSStringEncodingToEncoding(encoding));
}


+ (void)searchForPhrase:(NSString *)phrase filter:(NSDictionary *)filter success:(RTVSearchSuccessBlock)success failure:(RTVFailureBlock)failure
{

    static NSURLSession *session = nil;
    if ( session ){
        [session invalidateAndCancel];
    }
    session = [NSURLSession sessionWithConfiguration:[self configuration]];
    [[session dataTaskWithURL: [self urlForEndpoint:[NSString stringWithFormat:@"retrieve?q=%@", AFPercentEscapedQueryStringKeyFromStringWithEncoding(phrase, NSUTF8StringEncoding)]]
            completionHandler:^(NSData *data,
                                NSURLResponse *response,
                                NSError *error) {
                if ( error ){
                   
                        dispatch_async(dispatch_get_main_queue(), ^{
                            RTVSearchError *rtvError = [[RTVSearchError alloc] initWithMessage:[NSString stringWithFormat:NSLocalizedString(@"Sorry, we couldn't connect this time.", nil), error.localizedDescription] corrections:nil suggestions:nil];
                            failure(rtvError);
                        });

                    
                }else{
                    NSError *jsonError;
                    
                    
                    NSDictionary *responseJSON =
                    [NSJSONSerialization JSONObjectWithData:data
                                                    options:NSJSONReadingAllowFragments
                                                      error:&jsonError];
                    
                    if ( jsonError ) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            RTVSearchError *rtvError = [[RTVSearchError alloc] initWithMessage:NSLocalizedString(@"Sorry, we couldn't connect this time.", nil) corrections:nil suggestions:nil];
                            failure(rtvError);
                        });
                    }else{
                        
                        NSHTTPURLResponse *httpResp = (NSHTTPURLResponse*) response;
                        if (httpResp.statusCode == 200) {
                            
                            
                            
                            NSArray *jsonItems = responseJSON[kRTVResponseItemsKey];
                            NSMutableArray *items = [@[] mutableCopy];
                            [jsonItems enumerateObjectsUsingBlock:^(NSDictionary *item, NSUInteger idx, BOOL *stop) {
                                [items addObject:[[RTVItem alloc] initWithDisplayName:item[kRTVResponseItemDisplayNameKey]]];
                            }];
                            
                            RTVSearchResponse *searchResponse = [[RTVSearchResponse alloc] initWithOriginalQuery:responseJSON[kRTVResponseOriginalQueryKey] matchedQuery:responseJSON[kRTVResponseMatchedQueryKey] totalItems:responseJSON[kRTVResponseTotalItemsKey] responseType:responseJSON[kRTVResponseTypeKey] items:items];
                            dispatch_async(dispatch_get_main_queue(), ^{
                                success(searchResponse);
                            });
                            
                            
                        }else{
                            NSDictionary *errorJSON = responseJSON[kRTVErrorKey];
                            RTVSearchError *searchError = [[RTVSearchError alloc] initWithMessage:errorJSON[kRTVErrorMessageKey] corrections:errorJSON[kRTVErrorCorrectionsKey] suggestions:errorJSON[kRTVErrorSuggestionsKey]];
                            dispatch_async(dispatch_get_main_queue(), ^{
                                failure(searchError);
                            });
                        }
                    }
                }
            }] resume];
    
    
}

+ (NSString *)apiPath
{
    return [RTV_API_ROOT_URL stringByAppendingPathComponent:RTV_INTERMIDIARY_PATH];
}

+ (NSURL *)urlForEndpoint:(NSString *)endpoint
{
    
    NSString *fullPath = [[self apiPath] stringByAppendingPathComponent:endpoint];
    return [NSURL URLWithString:fullPath];
}

- (NSString *)sha1:(NSString *)string
{
	NSData *stringBytes = [string dataUsingEncoding: NSUTF8StringEncoding];
	unsigned char digest[CC_SHA1_DIGEST_LENGTH];
	
	if (CC_SHA1([stringBytes bytes], [stringBytes length], digest)) {
		NSMutableString* hashed = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
		for(int i = 0; i < CC_SHA1_DIGEST_LENGTH; i++) {
			[hashed appendFormat:@"%02x", digest[i]];
		}
		return hashed;
	}
	
	return nil;
}

+ (NSURLSessionConfiguration *)configuration
{
    NSUserDefaults *d = [NSUserDefaults standardUserDefaults];
    NSString *uuid = [d stringForKey:@"rtvUUID"];
    if ( !uuid.length ){
        NSUUID *aUUID = [NSUUID new];
        uuid = aUUID.UUIDString;
        [d setObject:uuid forKey:@"rtvUUID"];
        [d synchronize];
    }
    
    NSURLSessionConfiguration *sessionConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
    sessionConfig.allowsCellularAccess = YES;
    NSString *time = [NSString stringWithFormat:@"%f",[NSDate timeIntervalSinceReferenceDate]];
    NSString *shortTime = [time substringToIndex:5];
    NSString *token = [NSString stringWithFormat:@"Retriver-%@-%@-1",shortTime,RTV_API_VERSION];
    [sessionConfig setHTTPAdditionalHeaders: @{@"Accept": @"application/json",
                                               @"X-Reference": time,
                                               @"X-API-Version" : RTV_API_VERSION,
                                               @"X-Authentication" : token,
                                               @"X-User" : uuid}];

    sessionConfig.timeoutIntervalForRequest = 30.0;
    sessionConfig.timeoutIntervalForResource = 60.0;
    sessionConfig.HTTPMaximumConnectionsPerHost = 1;
    
    
    return sessionConfig;
}
@end
