//
//  MusicAlbum.h
//  myspacePlayer
//
//  Created by Andrew Beaupre on 11/5/13.
//  Copyright (c) 2013 Andrew Beaupre. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface MusicAlbum : NSManagedObject

@property (nonatomic, retain) NSString * entityKey;
@property (nonatomic, retain) NSString * title;

@end
