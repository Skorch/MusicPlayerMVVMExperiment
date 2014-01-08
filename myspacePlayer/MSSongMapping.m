//
//  MSSongMapping.m
//  myspacePlayer
//
//  Created by Andrew Beaupre on 11/6/13.
//  Copyright (c) 2013 Andrew Beaupre. All rights reserved.
//

#import "MSSongMapping.h"


@implementation MSSongMapping

static NSString * const kMSPEntityType = @"Song";

static NSString * const kMSPlaylistMappingResponseSchemaBase = @"";

static NSString * const kMSPlaylistMappingModelAttributeKeyEntityKey = @"entityKey";
static NSString * const kMSPlaylistMappingModelAttributeKeyReleaseEntityKey = @"releaseEntityKey";
static NSString * const kMSPlaylistMappingModelAttributeKeySongTitle = @"songTitle";
static NSString * const kMSPlaylistMappingModelAttributeKeySongSubTitle = @"songSubTitle";
static NSString * const kMSPlaylistMappingModelAttributeKeyURLToStream = @"urlToStream";
static NSString * const kMSPlaylistMappingModelAttributeKeyURLToThumbnail = @"urlToThumbnail";

static NSString * const kMSPlaylistMappingResponsePathEntityKey = @"entityKey";
static NSString * const kMSPlaylistMappingResponsePathReleaseEntityKey = @"songReleaseEntityKey";
static NSString * const kMSPlaylistMappingResponsePathSongTitle = @"title";
static NSString * const kMSPlaylistMappingResponsePathSongSubTitle = @"titleVersion";
static NSString * const kMSPlaylistMappingResponsePathURLToStream = @"streamUrl";
static NSString * const kMSPlaylistMappingResponsePathURLToThumbnail = @"imageUrl";

static NSString * const kMSPlaylistMappingResponsePathArtistId = @"artistId";
static NSString * const kMSPlaylistMappingResponsePathArtistName = @"artistName";
static NSString * const kMSPlaylistMappingResponsePathAlbumId = @"albumId";
static NSString * const kMSPlaylistMappingResponsePathAlbumName = @"albumTitle";


- (id)init
{
    self = [super init];
    if (self) {
        
        self.idMappingBlock = ^NSString *(NSDictionary * representation){
            return [representation valueForKeyPath:kMSPlaylistMappingResponsePathEntityKey];
        };
        
        self.attributeKeyMappingBlocks = [NSDictionary dictionaryWithObjectsAndKeys:
                                          //====[ EntityKey ]====
                                          self.idMappingBlock,kMSPlaylistMappingModelAttributeKeyEntityKey,
                                          
                                          //====[ ReleaseEntityKey ]====
                                          (NSString *)^(NSDictionary *representation){
                                              return [representation valueForKeyPath:kMSPlaylistMappingResponsePathReleaseEntityKey];
                                          },kMSPlaylistMappingModelAttributeKeyReleaseEntityKey,
                                          
                                          //====[ SongTitle ]====
                                          (NSString *)^(NSDictionary *representation){
                                              return [representation valueForKeyPath:kMSPlaylistMappingResponsePathSongTitle];
                                          },kMSPlaylistMappingModelAttributeKeySongTitle,
                                          
                                          //====[ SongSubTitle ]====
                                          (NSString *)^(NSDictionary *representation){
                                              return [representation valueForKeyPath:kMSPlaylistMappingResponsePathSongSubTitle];
                                          },kMSPlaylistMappingModelAttributeKeySongSubTitle,
                                          
                                          //====[ URLToStream ]====
                                          (NSString *)^(NSDictionary *representation){
                                              return [representation valueForKeyPath:kMSPlaylistMappingResponsePathURLToStream];
                                          },kMSPlaylistMappingModelAttributeKeyURLToStream,
                                          
                                          //====[ URLToThumbnail ]====
                                          (NSString *)^(NSDictionary *representation){
                                              return [representation valueForKeyPath:kMSPlaylistMappingResponsePathURLToThumbnail];
                                          },kMSPlaylistMappingModelAttributeKeyURLToThumbnail,

                                          nil];
    }
    
    
    return self;
}


-(NSString *)entityName
{
    return kMSPEntityType;
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
