//
//  MSPlaylistFetchRequest.h
//  myspacePlayer
//
//  Created by Andrew Beaupre on 11/5/13.
//  Copyright (c) 2013 Andrew Beaupre. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface MSPlaylistFetchRequest : NSFetchRequest

@property (nonatomic, strong) NSString *profileName;

+(MSPlaylistFetchRequest *)fetchRequestWithEntityName:(NSString *)entityName;


@end
