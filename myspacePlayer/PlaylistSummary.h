//
//  PlaylistSummary.h
//  myspacePlayer
//
//  Created by Andrew Beaupre on 11/5/13.
//  Copyright (c) 2013 Andrew Beaupre. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface PlaylistSummary : NSManagedObject

@property (nonatomic, retain) NSString * playlistEntityKey;
@property (nonatomic, retain) NSNumber * videoCount;
@property (nonatomic, retain) NSNumber * albumCount;
@property (nonatomic, retain) NSNumber * photoCount;
@property (nonatomic, retain) NSNumber * songCount;
@property (nonatomic, retain) NSManagedObject *statistics;

@end
