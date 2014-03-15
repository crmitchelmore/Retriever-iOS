//
//  RTVAppDelegate.m
//  Retriever
//
//  Created by Chris Mitchelmore on 15/03/2014.
//  Copyright (c) 2014 Retriever Company. All rights reserved.
//

#import "RTVAppDelegate.h"

#import <NewRelicAgent/NewRelic.h>
#import <Mixpanel/Mixpanel.h>

@implementation RTVAppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{

    [self rtv_setupMixPanel];
    [self rtv_setupNewRelic];
    [self.window makeKeyAndVisible];
    
    return YES;
}


/////////////////////////////////////////////////////////////////////////
#pragma mark - Private API
/////////////////////////////////////////////////////////////////////////


- (void)rtv_setupMixPanel
{
    [Mixpanel sharedInstanceWithToken:RTV_MIXPANEL_TOKEN];
}

//---------------------------------------------------------------------

- (void)rtv_setupNewRelic
{
    NSString *key = RTV_NEWRELIC_TOKEN;
    if ( key.length ){
        [NewRelicAgent startWithApplicationToken:key];
    }
}



@end
