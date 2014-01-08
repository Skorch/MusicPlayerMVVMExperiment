//
//  MSPAppDelegate.m
//  myspacePlayer
//
//  Created by Andrew Beaupre on 10/2/13.
//  Copyright (c) 2013 Andrew Beaupre. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>
#import "MSPAppDelegate.h"
#import "MSPMediaPlayerView.h"
#import "MSIncrementalStoreITunesCharts.h"
#import "MSIncrementalStoreMyspace.h"


@implementation MSPAppDelegate

@synthesize managedObjectContext = __managedObjectContext;
@synthesize managedObjectModel = __managedObjectModel;
@synthesize persistentStoreCoordinator = __persistentStoreCoordinator;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.

    self.window.backgroundColor = [UIColor whiteColor];
    
    MSPMediaPlayerView *mainWindowViewController = [[MSPMediaPlayerView alloc] init];

    [[self window] setRootViewController:mainWindowViewController];

    
    // Allow audio to continue playing when the app is put into the background
    NSError *setAudioSessionError = nil;
    
    if (![[AVAudioSession sharedInstance] setCategory: AVAudioSessionCategoryPlayback error: &setAudioSessionError])
    {
        NSLog(@"Error setting category! %@", setAudioSessionError);
        
        //TODO:  any problems with the player should bubble up to the UI through notifications
        
    }
    if (![[AVAudioSession sharedInstance] setActive:YES error: &setAudioSessionError])
    {
        NSLog(@"Error setting category! %@", setAudioSessionError);
        
        //TODO:  any problems with the player should bubble up to the UI through notifications
        
    }

    // Receive remote control events (such as multi-tasking tray play/pause/next buttons)
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    

    [self.window makeKeyAndVisible];
    

    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
 
    [self saveContext];
    
    // Turn on remote control event delivery
    [[UIApplication sharedApplication] endReceivingRemoteControlEvents];

}

- (void)saveContext {
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

#pragma mark - Core Data

// Returns the managed object context for the application.
// If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
- (NSManagedObjectContext *)managedObjectContext {
    if (__managedObjectContext != nil) {
        return __managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        __managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
        [__managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    
    return __managedObjectContext;
}

// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
- (NSManagedObjectModel *)managedObjectModel
{
    if (__managedObjectModel != nil) {
        return __managedObjectModel;
    }
    
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"MSPDataModels" withExtension:@"momd"];
    __managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    
    return __managedObjectModel;
}

// Returns the persistent store coordinator for the application.
// If the coordinator doesn't already exist, it is created and the application's store added to it.
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    if (__persistentStoreCoordinator != nil) {
        return __persistentStoreCoordinator;
    }
    
    __persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    
    AFIncrementalStore *incrementalStore = (AFIncrementalStore *)[__persistentStoreCoordinator addPersistentStoreWithType:[MSIncrementalStoreITunesCharts type] configuration:nil URL:nil options:nil error:nil];
    //    AFIncrementalStore *incrementalStore = (AFIncrementalStore *)[__persistentStoreCoordinator addPersistentStoreWithType:[MSIncrementalStoreMyspace type] configuration:nil URL:nil options:nil error:nil];
    
    NSURL *storeURL = nil;//[[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"MSPMediaQueue1a.sqlite"];
    
    NSDictionary *options = @{
                              NSInferMappingModelAutomaticallyOption : @(YES),
                              NSMigratePersistentStoresAutomaticallyOption: @(YES)
                              };
    
    //    [fileManager removeItemAtPath:iCloudData error:&error];
    
    NSError *error = nil;
    //NSSQLiteStoreType
    //NSInMemoryStoreType
    if (![incrementalStore.backingPersistentStoreCoordinator addPersistentStoreWithType:NSInMemoryStoreType configuration:nil URL:storeURL options:options error:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    NSLog(@"SQLite URL: %@", storeURL);
    
    return __persistentStoreCoordinator;
}

#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory {
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}


@end
