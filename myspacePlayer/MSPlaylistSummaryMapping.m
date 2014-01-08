//
//  MSPlaylistSummaryMapping.m
//  myspacePlayer
//
//  Created by Andrew Beaupre on 11/5/13.
//  Copyright (c) 2013 Andrew Beaupre. All rights reserved.
//

#import "MSPlaylistSummaryMapping.h"
#import "MSPlaylistFetchRequest.h"

@interface MSPlaylistSummaryMapping ()

@end

@implementation MSPlaylistSummaryMapping

static NSString * const kMSPEntityTypePlaylistSummary = @"PlaylistSummary";

static NSString * const kMSPlaylistMappingModelAttributeKeyEntityKey = @"entityKey";
static NSString * const kMSPlaylistMappingModelAttributeKeySongCount = @"songCount";
static NSString * const kMSPlaylistMappingModelAttributeKeyVideoCount = @"videoCount";
static NSString * const kMSPlaylistMappingModelAttributeKeyAlbumCount = @"albumCount";
static NSString * const kMSPlaylistMappingModelAttributeKeyPhotoCount = @"photoCount";
static NSString * const kMSPlaylistMappingModelAttributeKeyStatistics = @"statistics";

static NSString * const kMSPlaylistMappingResponsePathEntityKey = @"entityKey";

static NSString * const kMSPlaylistMappingResponsePathSummarySongCount = @"songCount";
static NSString * const kMSPlaylistMappingResponsePathSummaryVideoCount = @"videoCount";
static NSString * const kMSPlaylistMappingResponsePathSummaryAlbumCount = @"albumCount";
static NSString * const kMSPlaylistMappingResponsePathSummaryPhotoCount = @"photoCount";
static NSString * const kMSPlaylistMappingResponsePathSummaryStatistics = @"statistics";

static NSString * const kMSPlaylistMappingResponseSchemaBase = @"items";


- (id)init
{
    self = [super init];
    if (self) {
        
        self.idMappingBlock = ^NSString *(NSDictionary * representation){
            return [representation valueForKeyPath:kMSPlaylistMappingResponsePathEntityKey];
        };
        
        
        self.attributeKeyMappingBlocks = [NSDictionary dictionaryWithObjectsAndKeys:
                                          //====[ Album Count ]====
                                          (NSNumber *)^(NSDictionary *representation){
                                              NSString *stringValue = [representation valueForKeyPath:kMSPlaylistMappingResponsePathSummaryAlbumCount];
                                              return [NSNumber numberWithInt:[stringValue integerValue]];
                                          },kMSPlaylistMappingModelAttributeKeyAlbumCount,
                                          
                                          //====[ Video Count ]====
                                          (NSNumber *)^(NSDictionary *representation){
                                              NSString *stringValue = [representation valueForKeyPath:kMSPlaylistMappingResponsePathSummaryVideoCount];
                                              return [NSNumber numberWithInt:[stringValue integerValue]];
                                          },kMSPlaylistMappingModelAttributeKeyVideoCount,
                                          
                                          //====[ Song Count ]====
                                          (NSNumber *)^(NSDictionary *representation){
                                              NSString *stringValue = [representation valueForKeyPath:kMSPlaylistMappingResponsePathSummarySongCount];
                                              return [NSNumber numberWithInt:[stringValue integerValue]];
                                          },kMSPlaylistMappingModelAttributeKeySongCount,
                                          
                                          //====[ Photo Count ]====
                                          (NSNumber *)^(NSDictionary *representation){
                                              NSString *stringValue = [representation valueForKeyPath:kMSPlaylistMappingResponsePathSummaryPhotoCount];
                                              return [NSNumber numberWithInt:[stringValue integerValue]];
                                          },kMSPlaylistMappingModelAttributeKeyPhotoCount
                                          
                                          
                                          , nil];
        self.relationshipRepresentationsKeyMappingBlocks = [NSDictionary dictionaryWithObjectsAndKeys:
                                                            //====[ Statistics ]====
                                                            (NSDictionary *)^(NSDictionary *representation){
                                                                NSMutableDictionary *statistics = [[representation valueForKeyPath:kMSPlaylistMappingResponsePathSummaryStatistics] mutableCopy];
                                                                
                                                                //insert the entity key
                                                                if(statistics != nil)
                                                                {
                                                                    [statistics setValue:self.idMappingBlock(representation) forKey:kMSPlaylistMappingResponsePathEntityKey];
                                                                }
                                                                
                                                                return statistics;
                                                            },kMSPlaylistMappingModelAttributeKeyStatistics
                                                            
                                                            , nil];
    }
    return self;
}

#pragma mark - Mapping Descriptions

-(NSString *)entityName
{
    return kMSPEntityTypePlaylistSummary;
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
