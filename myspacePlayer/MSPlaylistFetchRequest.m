//
//  MSPlaylistFetchRequest.m
//  myspacePlayer
//
//  Created by Andrew Beaupre on 11/5/13.
//  Copyright (c) 2013 Andrew Beaupre. All rights reserved.
//

#import "MSPlaylistFetchRequest.h"

@implementation MSPlaylistFetchRequest

+(MSPlaylistFetchRequest *)fetchRequestWithEntityName:(NSString *)entityName
{
    return (MSPlaylistFetchRequest *)[super fetchRequestWithEntityName:entityName];
    
}

@end
