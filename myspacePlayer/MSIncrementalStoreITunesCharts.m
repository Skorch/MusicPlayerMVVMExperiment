//
//  MSPMediaQueueIncrementalStore.m
//  myspacePlayer
//
//  Created by Andrew Beaupre on 10/24/13.
//  Copyright (c) 2013 Andrew Beaupre. All rights reserved.
//

#import "MSIncrementalStoreITunesCharts.h"

@implementation MSIncrementalStoreITunesCharts

//Base Url
static NSString * const kMSPMediaQueueBaseURLString = @"https://itunes.apple.com/";


-(NSString *)baseURL
{
    return kMSPMediaQueueBaseURLString;
}

@end
