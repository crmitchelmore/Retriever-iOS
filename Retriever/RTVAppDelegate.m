//
//  RTVAppDelegate.m
//  Retriever
//
//  Created by Chris Mitchelmore on 15/03/2014.
//  Copyright (c) 2014 Retriever Company. All rights reserved.
//

#import "RTVAppDelegate.h"

#import <RestKit/RestKit.h>
#import <NewRelicAgent/NewRelicAgent.h>
#import <Mixpanel/Mixpanel.h>

@implementation RTVAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    [self rtv_setupMixPanel];
    [self rtv_setupNewRelic];
    [self rtv_configureRestKitForMagicalRecord];
    
    return YES;
}

- (void)rtv_setupMixPanel
{
    [Mixpanel sharedInstanceWithToken:RTV_MIXPANEL_TOKEN];
}

- (void)rtv_setupNewRelic
{
    NSString *key = RTV_NEWRELIC_TOKEN;
    if ( key.length ){
        [NewRelicAgent startWithApplicationToken:key];
    }
}

//---------------------------------------------------------------------

- (void)rtv_configureRestKitForMagicalRecord
{
    // Configure RestKit's Core Data stack
    NSURL *modelURL = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"retriever" ofType:@"momd"]];
    NSManagedObjectModel *managedObjectModel = [[[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL] mutableCopy];
    
    
    RKManagedObjectStore *managedObjectStore = [[RKManagedObjectStore alloc] initWithManagedObjectModel:managedObjectModel];
    NSString *storePath = [RKApplicationDataDirectory() stringByAppendingPathComponent:@"retriever.sqlite"];
    NSError *error = nil;
    
    [managedObjectStore addSQLitePersistentStoreAtPath:storePath fromSeedDatabaseAtPath:nil withConfiguration:nil options:nil error:&error];
    [managedObjectStore createManagedObjectContexts];
    
    
    // Configure MagicalRecord to use RestKit's Core Data stack
    [NSPersistentStoreCoordinator MR_setDefaultStoreCoordinator:managedObjectStore.persistentStoreCoordinator];
    [NSManagedObjectContext MR_setRootSavingContext:managedObjectStore.persistentStoreManagedObjectContext];
    [NSManagedObjectContext MR_setDefaultContext:managedObjectStore.mainQueueManagedObjectContext];
    
    
    RKObjectManager *objectManager = [RKObjectManager managerWithBaseURL:[NSURL URLWithString:RTV_API_ROOT_URL]];
    objectManager.managedObjectStore = managedObjectStore;

    [RKObjectManager setSharedManager:objectManager];
}
@end
