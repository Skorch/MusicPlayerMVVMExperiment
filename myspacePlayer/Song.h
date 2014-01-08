//
//  Song.h
//  myspacePlayer
//
//  Created by Andrew Beaupre on 11/5/13.
//  Copyright (c) 2013 Andrew Beaupre. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Artist, MusicAlbum;

@interface Song : NSManagedObject

@property (nonatomic, retain) NSString * entityKey;
@property (nonatomic, retain) NSString * releaseEntityKey;
@property (nonatomic, retain) NSString * songTitle;
@property (nonatomic, retain) NSString * songSubTitle;
@property (nonatomic, retain) NSString * urlToStream;
@property (nonatomic, retain) NSString * urlToThumbnail;
@property (nonatomic, retain) Artist *artist;
@property (nonatomic, retain) MusicAlbum *album;

@end
