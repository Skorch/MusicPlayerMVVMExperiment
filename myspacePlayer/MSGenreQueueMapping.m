//
//  MSPGenreQueueMapping.m
//  myspacePlayer
//
//  Created by Andrew Beaupre on 11/4/13.
//  Copyright (c) 2013 Andrew Beaupre. All rights reserved.
//

#import "MSGenreQueueMapping.h"
#import "MSPMediaQueueFetchRequest.h"
#import "MSHTTPRequestParameter.h"

@implementation MSGenreQueueMapping

static NSString * const kMSPEntityTypeGenreQueue = @"GenreQueue";
static NSString * const kMSPMediaQueueResponseSchemaBase = @"feed";
static NSString * const kMSMediaQueueResponseSchemaEntry = @"entry";

static NSString * const kMSGenreQueueChartPosition = @"chartPosition";

static NSString * const kMSGenreQueueMediaItems = @"mediaItems";
static NSString * const kMSGenreQueueName = @"queueName";

//GenreQueue attribute paths
static NSString * const kMSPGenreQueueResponseSchemaTitleLabel = @"title.label";

#pragma mark - MSModelIntegrationMapping

-(NSString *)entityName
{
    return kMSPEntityTypeGenreQueue;
}

-(NSString *)rootResponsePath
{
    return kMSPMediaQueueResponseSchemaBase;
}

-(MSHTTPRequestParameter *)requestPathForFetchRequest:(MSPMediaQueueFetchRequest *)fetchRequest
{
    MSHTTPRequestParameter *requestParameter = [[MSHTTPRequestParameter alloc]init];
    
    requestParameter.HTTPMethod = @"GET";
    requestParameter.urlPath = [NSString stringWithFormat:@"us/rss/topsongs/limit=%u/genre=%@/explicit=true/json", fetchRequest.fetchLimit, fetchRequest.genreId];
    
    return requestParameter;
}

-(NSString *)resourceIdentifierForRepresentation:(NSDictionary *)representation ofEntity:(NSEntityDescription *)entity
{
    return [self genreQueueIdFromResponseFragment:representation];
    
}

- (NSDictionary *)representationsForRelationshipsFromRepresentation:(NSDictionary *)representation
                                                           ofEntity:(NSEntityDescription *)entity
                                                       fromResponse:(NSHTTPURLResponse *)response;
{
    NSArray * items = [representation valueForKeyPath:kMSMediaQueueResponseSchemaEntry];
    
    NSMutableArray *modifiedItems = [NSMutableArray arrayWithCapacity:items.count];
    
    for (NSUInteger i = 0; i < items.count; i++) {
        
        NSMutableDictionary *modifiedItem = [NSMutableDictionary dictionaryWithDictionary: items[i]];
        
        [modifiedItem setValue:[NSNumber numberWithUnsignedInt:i] forKey:kMSGenreQueueChartPosition];
        
        [modifiedItems addObject:modifiedItem];
    }
    
    NSDictionary *relationships = [NSDictionary dictionaryWithObjectsAndKeys:modifiedItems, kMSGenreQueueMediaItems, nil];
    
    return relationships;
    
}

- (NSDictionary *)attributesForRepresentation:(NSDictionary *)representation
                                     ofEntity:(NSEntityDescription *)entity
{
    NSMutableDictionary *mutablePropertyValues = [NSMutableDictionary dictionary];
    
    NSLog(@"mapping property values for entity.name: %@", entity.name);
    
    [mutablePropertyValues setValue:[self genreQueueIdFromResponseFragment:representation] forKey:kMSGenreQueueName];
    
    return mutablePropertyValues;
}

#pragma mark - GenreQueue Mapping Functions

-(NSString *)genreQueueIdFromResponseFragment:(NSDictionary *)responseFragment
{
    return [responseFragment valueForKeyPath:kMSPGenreQueueResponseSchemaTitleLabel];
}


@end
