//
//  MSPGenreQueue.h
//  myspacePlayer
//
//  Created by Andrew Beaupre on 10/25/13.
//  Copyright (c) 2013 Andrew Beaupre. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class MSPMediaItem;

@interface MSPGenreQueue : NSManagedObject

@property (nonatomic, retain) NSString * queueName;
@property (nonatomic, retain) NSSet *mediaItems;
@end

@interface MSPGenreQueue (CoreDataGeneratedAccessors)

- (void)addMediaItemsObject:(MSPMediaItem *)value;
- (void)removeMediaItemsObject:(MSPMediaItem *)value;
- (void)addMediaItems:(NSSet *)values;
- (void)removeMediaItems:(NSSet *)values;

-(MSPMediaItem *)mediaItemAtChartPosition:(NSNumber *)chartPosition;

@end
