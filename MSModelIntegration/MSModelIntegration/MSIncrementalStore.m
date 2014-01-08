//
//  MSIncrementalStore.m
//  myspacePlayer
//
//  Created by Andrew Beaupre on 11/5/13.
//  Copyright (c) 2013 Andrew Beaupre. All rights reserved.
//

#import "MSIncrementalStore.h"
#import "MSIncrementalStoreHTTPClient.h"

@implementation MSIncrementalStore

NSString * const MSIncrementalStoreUnimplementedMethodException = @"com.myspace.incremental-store.exceptions.unimplemented-method";

+ (void)initialize {
    [NSPersistentStoreCoordinator registerStoreClass:self forStoreType:[self type]];
}

+ (NSString *)type {
    return NSStringFromClass(self);
}

- (id<AFIncrementalStoreHTTPClient>)HTTPClient {
    
    return [MSIncrementalStoreHTTPClient sharedClientWithBaseURL: self.baseURL];
}

- (NSString *)baseURL
{
    @throw([NSException exceptionWithName:MSIncrementalStoreUnimplementedMethodException reason:NSLocalizedString(@"Unimplemented method: +baseURL. Must be overridden in a subclass", nil) userInfo:nil]);
}
@end
