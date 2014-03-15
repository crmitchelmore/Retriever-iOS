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
                            RTVSearchError *rtvError = [[RTVSearchError alloc] initWithMessage:[NSString stringWithFormat:NSLocalizedString(@"Oops, we broke something. Try back soon. (%@)", nil), error.localizedDescription] corrections:nil suggestions:nil];
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
                            RTVSearchError *rtvError = [[RTVSearchError alloc] initWithMessage:NSLocalizedString(@"Oops, we broke something. Try back soon.", nil) corrections:nil suggestions:nil];
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

+ (NSURLSessionConfiguration *)configuration
{
    NSURLSessionConfiguration *sessionConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
    sessionConfig.allowsCellularAccess = YES;
    [sessionConfig setHTTPAdditionalHeaders: @{@"Accept": @"application/json"}];

    sessionConfig.timeoutIntervalForRequest = 30.0;
    sessionConfig.timeoutIntervalForResource = 60.0;
    sessionConfig.HTTPMaximumConnectionsPerHost = 1;
    
    
    return sessionConfig;
}
@end
