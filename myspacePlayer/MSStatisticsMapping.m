//
//  MSStatisticsMapping.m
//  myspacePlayer
//
//  Created by Andrew Beaupre on 11/6/13.
//  Copyright (c) 2013 Andrew Beaupre. All rights reserved.
//


#import "MSStatisticsMapping.h"

@interface MSStatisticsMapping ()


@end

@implementation MSStatisticsMapping
static NSString * const kMSPEntityTypeStatistics = @"Statistics";

static NSString * const kMSPlaylistMappingResponseSchemaBase = @"";

static NSString * const kMSPlaylistMappingModelAttributeKeyEntityKey = @"entityKey";
static NSString * const kMSPlaylistMappingModelAttributeKeyConnectCount = @"songCount";
static NSString * const kMSPlaylistMappingModelAttributeKeyCommentCount = @"videoCount";
static NSString * const kMSPlaylistMappingModelAttributeKeyShareCount = @"albumCount";
static NSString * const kMSPlaylistMappingModelAttributeKeyLikeCount = @"photoCount";

static NSString * const kMSPlaylistMappingResponsePathEntityKey = @"entityKey";
static NSString * const kMSPlaylistMappingResponsePathStatisticsConnectCount = @"connectCount";
static NSString * const kMSPlaylistMappingResponsePathStatisticsCommentCount = @"commentCount";
static NSString * const kMSPlaylistMappingResponsePathStatisticsShareCount = @"shareCount";
static NSString * const kMSPlaylistMappingResponsePathStatisticsLikeCount = @"likeCount";


- (id)init
{
    self = [super init];
    if (self) {
        
        self.idMappingBlock = ^NSString *(NSDictionary * representation){
            return [representation valueForKeyPath:kMSPlaylistMappingResponsePathEntityKey];
        };
        
        
        self.attributeKeyMappingBlocks = [NSDictionary dictionaryWithObjectsAndKeys:
                                          //====[ Connect Count ]====
                                          (NSNumber *)^(NSDictionary *representation){
                                              NSString *stringValue = [representation valueForKeyPath:kMSPlaylistMappingResponsePathStatisticsConnectCount];
                                              return [NSNumber numberWithInt:[stringValue integerValue]];
                                          },kMSPlaylistMappingModelAttributeKeyConnectCount,
                                          
                                          //====[ Comment Count ]====
                                          (NSNumber *)^(NSDictionary *representation){
                                              NSString *stringValue = [representation valueForKeyPath:kMSPlaylistMappingResponsePathStatisticsCommentCount];
                                              return [NSNumber numberWithInt:[stringValue integerValue]];
                                          },kMSPlaylistMappingModelAttributeKeyCommentCount,
                                          
                                          //====[ Share Count ]====
                                          (NSNumber *)^(NSDictionary *representation){
                                              NSString *stringValue = [representation valueForKeyPath:kMSPlaylistMappingResponsePathStatisticsShareCount];
                                              return [NSNumber numberWithInt:[stringValue integerValue]];
                                          },kMSPlaylistMappingModelAttributeKeyShareCount,
                                          
                                          //====[ Like Count ]====
                                          (NSNumber *)^(NSDictionary *representation){
                                              NSString *stringValue = [representation valueForKeyPath:kMSPlaylistMappingResponsePathStatisticsLikeCount];
                                              return [NSNumber numberWithInt:[stringValue integerValue]];
                                          },kMSPlaylistMappingModelAttributeKeyLikeCount
                                          
                                          , nil];
    }
    return self;
}

#pragma mark - Mapping Descriptions

-(NSString *)entityName
{
    return kMSPEntityTypeStatistics;
}

-(NSString *)rootResponsePath
{
    return kMSPlaylistMappingResponseSchemaBase;
}

#pragma mark - Response Mapping

-(NSString *)resourceIdentifierForRepresentation:(NSDictionary *)representation ofEntity:(NSEntityDescription *)entity
{
    return self.idMappingBlock(representation);
}

@end
