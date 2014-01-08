//
//  MSPMediaQueue.h
//  myspacePlayer
//
//  Created by Andrew Beaupre on 10/2/13.
//  Copyright (c) 2013 Andrew Beaupre. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MSPMediaItem.h"


@class MSPMediaItem;
@class MSPGenreQueue;

@interface MSPMediaQueue : NSObject

- (MSPMediaItem *)getNextItem;
- (MSPMediaItem *)getPreviousItem;
- (MSPMediaItem *)getCurrentItem;
- (void)setItemAtPosition:(NSInteger)newQueuePosition;
- (void)changeToGenreId:(NSNumber *)genreId;

@property (nonatomic, strong) MSPGenreQueue *mediaItems;

@property (nonatomic, strong) NSNumber *queuePosition;

@property (nonatomic, readonly) NSUInteger queueSize;

@property (nonatomic, strong) MSPMediaItem *currentItem;

@end
