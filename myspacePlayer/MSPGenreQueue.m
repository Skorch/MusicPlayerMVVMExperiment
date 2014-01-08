//
//  MSPGenreQueue.m
//  myspacePlayer
//
//  Created by Andrew Beaupre on 10/25/13.
//  Copyright (c) 2013 Andrew Beaupre. All rights reserved.
//

#import "MSPGenreQueue.h"
#import "MSPMediaItem.h"


@implementation MSPGenreQueue

@dynamic queueName;
@dynamic mediaItems;


-(MSPMediaItem *)mediaItemAtChartPosition:(NSNumber *)chartPosition
{
    /*
    MSPMediaItem *item = [[self.mediaItems allObjects] objectAtIndex:[chartPosition integerValue]];

    return item;
    */
    NSPredicate *filterPredicate = [NSPredicate predicateWithFormat:
                                    [NSString stringWithFormat:@"chartPosition == %@", chartPosition]];
    
    NSSet *filteredSet = [self.mediaItems filteredSetUsingPredicate:filterPredicate];
    
    MSPMediaItem *onlyItem = [filteredSet anyObject];
    
    return onlyItem;
    
}

@end
