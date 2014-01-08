//
//  GenreList.m
//  myspacePlayer
//
//  Created by Andrew Beaupre on 10/25/13.
//  Copyright (c) 2013 Andrew Beaupre. All rights reserved.
//

#import "MSPGenreList.h"


@implementation MSPGenreList

- (id)init
{
    self = [super init];
    if (self) {
        
        _genres = [NSDictionary dictionaryWithObjectsAndKeys:
                   @20, @"Alternative",
                   @7, @"Electronic",
                   nil];
    }
    return self;
}
@end
