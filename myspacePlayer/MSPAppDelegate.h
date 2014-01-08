//
//  MSPAppDelegate.h
//  myspacePlayer
//
//  Created by Andrew Beaupre on 10/2/13.
//  Copyright (c) 2013 Andrew Beaupre. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MSPMediaPlayerView.h"

@interface MSPAppDelegate : UIResponder <UIApplicationDelegate>

@property (retain, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@end
