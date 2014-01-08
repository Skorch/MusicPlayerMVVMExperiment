//
//  MSPMediaItem.h
//  myspacePlayer
//
//  Created by Andrew Beaupre on 10/24/13.
//  Copyright (c) 2013 Andrew Beaupre. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface MSPMediaItem : NSManagedObject

@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * artistName;
@property (nonatomic, retain) NSString * albumTitle;
@property (nonatomic, retain) NSString * urlToThumbnail;
@property (nonatomic, retain) NSString * urlToFile;
@property (nonatomic, retain) NSNumber * id;
@property (nonatomic, retain) NSNumber * chartPosition;
@property (nonatomic, retain) NSNumber * genreId;
@end
