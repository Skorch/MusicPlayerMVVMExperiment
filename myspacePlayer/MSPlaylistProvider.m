//
//  MSPlaylistProvider.m
//  myspacePlayer
//
//  Created by Andrew Beaupre on 11/6/13.
//  Copyright (c) 2013 Andrew Beaupre. All rights reserved.
//

#import "MSPlaylistProvider.h"
#import "MSPlaylistFetchRequest.h"
#import <CoreData/CoreData.h>

@interface MSPlaylistProvider ()<NSFetchedResultsControllerDelegate>

@property (nonatomic, strong) MSPlaylistFetchRequest *fetchRequest;

@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;

@property (nonatomic, strong, readwrite) NSArray *playlists;

@end
@implementation MSPlaylistProvider


- (id)init
{
    self = [super init];
    if (self) {
        
        _fetchRequest = [MSPlaylistFetchRequest fetchRequestWithEntityName:@"Playlist"];
        self.fetchRequest.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"entityKey" ascending:YES]];
        self.fetchRequest.fetchLimit = 10;
        self.fetchRequest.fetchOffset = 0;
        self.fetchRequest.profileName = @"drew";
        
        _fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:self.fetchRequest
                                                                        managedObjectContext:[(id)[[UIApplication sharedApplication] delegate] managedObjectContext]
                                                                          sectionNameKeyPath:nil
                                                                                   cacheName:@"playlists"];
        
        _fetchedResultsController.delegate = self;
        
        
    }
    return self;
}

-(void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    //signal reload data
    self.playlists = controller.fetchedObjects;
    
}


@end
