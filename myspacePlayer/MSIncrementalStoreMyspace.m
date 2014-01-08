//
//  MSPIncrementalStoreMySpace.m
//  myspacePlayer
//
//  Created by Andrew Beaupre on 11/5/13.
//  Copyright (c) 2013 Andrew Beaupre. All rights reserved.
//

#import "MSIncrementalStoreMyspace.h"

@implementation MSIncrementalStoreMyspace

static NSString * const kMSPIncrementalStoreBaseUrlProduction = @"https://myspace.com/ajax/";

-(NSString *)baseURL
{
    return kMSPIncrementalStoreBaseUrlProduction;
}
@end
