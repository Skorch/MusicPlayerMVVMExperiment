//
//  Playlist.h
//  myspacePlayer
//
//  Created by Andrew Beaupre on 11/5/13.
//  Copyright (c) 2013 Andrew Beaupre. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Playlist : NSManagedObject

@property (nonatomic, retain) NSString * entityKey;
@property (nonatomic, retain) NSString * ownerEntityKey;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * extendedDescription;
@property (nonatomic, retain) NSString * urlToCoverImage;
@property (nonatomic, retain) NSManagedObject *playlistSummary;
@property (nonatomic, retain) NSOrderedSet *songs;
@end

@interface Playlist (CoreDataGeneratedAccessors)

- (void)insertObject:(NSManagedObject *)value inSongsAtIndex:(NSUInteger)idx;
- (void)removeObjectFromSongsAtIndex:(NSUInteger)idx;
- (void)insertSongs:(NSArray *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeSongsAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInSongsAtIndex:(NSUInteger)idx withObject:(NSManagedObject *)value;
- (void)replaceSongsAtIndexes:(NSIndexSet *)indexes withSongs:(NSArray *)values;
- (void)addSongsObject:(NSManagedObject *)value;
- (void)removeSongsObject:(NSManagedObject *)value;
- (void)addSongs:(NSOrderedSet *)values;
- (void)removeSongs:(NSOrderedSet *)values;
@end
