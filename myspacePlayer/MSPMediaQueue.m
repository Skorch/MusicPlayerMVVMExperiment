//
//  MSPMediaQueue.m
//  myspacePlayer
//
//  Created by Andrew Beaupre on 10/2/13.
//  Copyright (c) 2013 Andrew Beaupre. All rights reserved.
//

#import "MSPMediaQueue.h"
#import <CoreData/CoreData.h>
#import "MSPMediaQueueFetchRequest.h"
#import "MSPGenreQueue.h"

@interface MSPMediaQueue()<NSFetchedResultsControllerDelegate>
{
    NSFetchedResultsController *_fetchedResultsController;

}

@property (nonatomic, readwrite) NSUInteger queueSize;

@property (nonatomic, strong) MSPMediaQueueFetchRequest *fetchRequest;

@end

@implementation MSPMediaQueue
{
    BOOL _firstPlay;
    
}


#pragma mark init / dealloc

- (id)init
{
    self = [super init];
    if (self) {
        
        _firstPlay = YES;
        
        _fetchRequest = [MSPMediaQueueFetchRequest fetchRequestWithEntityName:@"GenreQueue"];
        self.fetchRequest.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"queueName" ascending:YES]];
        self.fetchRequest.fetchLimit = 50;
        self.fetchRequest.genreId = @0;
        
        _fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:self.fetchRequest
                                                                        managedObjectContext:[(id)[[UIApplication sharedApplication] delegate] managedObjectContext]
                                                                          sectionNameKeyPath:nil
                                                                                   cacheName:@"genreQueue"];
        
        _fetchedResultsController.delegate = self;
        
        //        _mediaItems = [NSMutableArray array];
        
        [self refetchData];

        _queuePosition = @0;
        
    }
    return self;
}


- (void)refetchData {
    [_fetchedResultsController performSelectorOnMainThread:@selector(performFetch:) withObject:nil waitUntilDone:YES modes:@[ NSRunLoopCommonModes ]];
}
- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath
{
    self.mediaItems = anObject;

    self.queueSize = self.mediaItems.mediaItems.count;
    
    [self setItemAtPosition:0];

}


#pragma mark -
#pragma mark MSPMediaProtocal Implementation


- (void)changeToGenreId:(NSNumber *)genreId
{
    self.fetchRequest.genreId = genreId;
    
    
    [self refetchData];
    
}


- (void)setItemAtPosition:(NSInteger)newQueuePosition
{
    self.queuePosition = [NSNumber numberWithInt:newQueuePosition];
    
    self.currentItem = [self getCurrentItem];
}


- (MSPMediaItem *)getNextItem
{
    if([self.queuePosition intValue] < [self.mediaItems.mediaItems count]-1){
        
        self.queuePosition = [NSNumber numberWithInt:[self.queuePosition intValue] + 1];
        
        self.currentItem = [self getCurrentItem];
        
        return self.currentItem;
    }
    
    return  nil;

}

- (MSPMediaItem *)getPreviousItem
{
    if ([self.queuePosition intValue] > 0 ) {

        self.queuePosition = [NSNumber numberWithInt:[self.queuePosition intValue] - 1];
        
        self.currentItem = [self getCurrentItem];

        return self.currentItem;
    }
    
    return nil;
}

- (MSPMediaItem *)getCurrentItem
{
    return [self.mediaItems mediaItemAtChartPosition:self.queuePosition];
}

#pragma mark -


@end
