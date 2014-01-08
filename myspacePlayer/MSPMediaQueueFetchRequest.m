//
//  MSPMediaQueueFetchRequest.m
//  myspacePlayer
//
//  Created by Andrew Beaupre on 10/25/13.
//  Copyright (c) 2013 Andrew Beaupre. All rights reserved.
//

#import "MSPMediaQueueFetchRequest.h"

@implementation MSPMediaQueueFetchRequest

+(MSPMediaQueueFetchRequest *)fetchRequestWithEntityName:(NSString *)entityName
{
    return (MSPMediaQueueFetchRequest *)[super fetchRequestWithEntityName:entityName];
}

@end
