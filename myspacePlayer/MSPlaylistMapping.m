//
//  MSPlaylistMapping.m
//  myspacePlayer
//
//  Created by Andrew Beaupre on 11/5/13.
//  Copyright (c) 2013 Andrew Beaupre. All rights reserved.
//

#import "MSPlaylistMapping.h"
#import "MSPlaylistFetchRequest.h"
#import "Playlist.h"

@interface MSPlaylistMapping ()


@end
@implementation MSPlaylistMapping


static NSString * const kMSPEntityTypePlaylist = @"Playlist";


static NSString * const kMSPlaylistMappingModelAttributeKeyEntityKey = @"entityKey";
static NSString * const kMSPlaylistMappingModelAttributeKeyTitle = @"title";
static NSString * const kMSPlaylistMappingModelAttributeKeyExtendedDescription = @"extendedDescription";
static NSString * const kMSPlaylistMappingModelAttributeKeyOwnerEntityKey = @"ownerEntityKey";
static NSString * const kMSPlaylistMappingModelAttributeKeyURLToCoverImage = @"urlToCoverImage";
static NSString * const kMSPlaylistMappingModelAttributeKeyPlaylistSummary = @"playlistSummary";
static NSString * const kMSPlaylistMappingModelAttributeKeySongs = @"songs";

static NSString * const kMSPlaylistMappingResponseSchemaBase = @"items";

static NSString * const kMSPlaylistMappingResponsePathEntityKey = @"entityKey";
static NSString * const kMSPlaylistMappingResponsePathProfileId = @"profileId";
static NSString * const kMSPlaylistMappingResponsePathTitle = @"title";
static NSString * const kMSPlaylistMappingResponsePathCreatedDate = @"createdDate";
static NSString * const kMSPlaylistMappingResponsePathModifiedDate = @"modifiedDate";
static NSString * const kMSPlaylistMappingResponsePathObjectVersion = @"objectVersion";
static NSString * const kMSPlaylistMappingResponsePathDescription = @"description";
static NSString * const kMSPlaylistMappingResponsePathImages = @"images";
static NSString * const kMSPlaylistMappingResponsePathImagesURL = @"url";
static NSString * const kMSPlaylistMappingResponsePathSongs = @"songs";
static NSString * const kMSPlaylistMappingResponsePathSummary = @"summary";

static NSString * const kMSPlaylistMapperResponsePredicateImage = @"name == '300x300'";

- (id)init
{
    self = [super init];
    if (self) {
        
        self.idMappingBlock = ^NSString *(NSDictionary * representation){
            return [representation valueForKeyPath:kMSPlaylistMappingResponsePathEntityKey];
        };

        self.attributeKeyMappingBlocks = [NSDictionary dictionaryWithObjectsAndKeys:
                                      //====[ EntityKey ]====
                                      self.idMappingBlock, kMSPlaylistMappingModelAttributeKeyEntityKey,

                                      //====[ Owner Entity Key ]====
                                      ^id(NSDictionary *representation){
                                          NSNumber *profileId = [representation valueForKeyPath:kMSPlaylistMappingResponsePathProfileId];
                                          return [NSString stringWithFormat:@"profile_%@", profileId];
                                      }, kMSPlaylistMappingModelAttributeKeyOwnerEntityKey,
                                      
                                      //====[ Title ]====
                                      ^id(NSDictionary *representation){
                                          return [representation valueForKeyPath:kMSPlaylistMappingResponsePathTitle];
                                      }, kMSPlaylistMappingModelAttributeKeyTitle,
                                      
                                      //====[ Description ]====
                                      ^id(NSDictionary *representation){
                                          return [representation valueForKeyPath:kMSPlaylistMappingResponsePathDescription];
                                      }, kMSPlaylistMappingModelAttributeKeyExtendedDescription,
                                      
                                      //====[ Cover Image ]====
                                      ^id(NSDictionary *representation){
                                          
                                          NSArray *images = [representation valueForKeyPath:kMSPlaylistMappingResponsePathImages];
                                          NSString *coverImage = nil;
                                          if(images)
                                          {
                                              NSPredicate *filterPredicate = [NSPredicate predicateWithFormat:kMSPlaylistMapperResponsePredicateImage];
                                              
                                              NSDictionary *defaultImageResponse = [[images filteredArrayUsingPredicate:filterPredicate] firstObject];
                                              
                                              if(defaultImageResponse == nil)
                                                  defaultImageResponse = [images lastObject];
                                              
                                              if(defaultImageResponse != nil)
                                              {
                                                  coverImage = [defaultImageResponse valueForKeyPath:kMSPlaylistMappingResponsePathImagesURL];
                                              }
                                          }
                                          
                                          return coverImage;
                                      }, kMSPlaylistMappingModelAttributeKeyOwnerEntityKey,

                                      
                                      
                                      nil];
        
        
        self.relationshipRepresentationsKeyMappingBlocks = [NSDictionary dictionaryWithObjectsAndKeys:
                                                        

                                                        //====[ summary ]====
                                                        ^id(NSDictionary *representation){
                                                            
                                                            NSMutableDictionary *summary = [[representation valueForKeyPath:kMSPlaylistMappingResponsePathSummary] mutableCopy];
                                                            
                                                            //insert the entity key
                                                            if(summary != nil)
                                                            {
                                                                [summary setValue:self.idMappingBlock(representation) forKey:kMSPlaylistMappingResponsePathEntityKey];
                                                            }
                                                            
                                                            return summary;                                                            
                                                        }, kMSPlaylistMappingModelAttributeKeyPlaylistSummary,

                                                        //====[ songs ]====
                                                        ^id(NSDictionary *representation){
                                                            return [representation valueForKeyPath:kMSPlaylistMappingResponsePathSongs];
                                                        }, kMSPlaylistMappingModelAttributeKeySongs,

                                                        nil];
        
    }
    return self;
}

#pragma mark - Mapping Descriptions

-(NSString *)entityName
{
    return kMSPEntityTypePlaylist;
}

-(NSString *)rootResponsePath
{
    return kMSPlaylistMappingResponseSchemaBase;
}

#pragma mark - URL Mapping

-(MSHTTPRequestParameter *)requestPathForFetchRequest:(MSPlaylistFetchRequest *)fetchRequest
{
    
    MSHTTPRequestParameter *requestParameter = [[MSHTTPRequestParameter alloc]init];
    
    requestParameter.HTTPMethod = @"POST";
    requestParameter.PostValues = @{
                                    @"filters[pageSize]:":[NSString stringWithFormat:@"%u", fetchRequest.fetchLimit],
                                    @"filters[start]:":[NSString stringWithFormat:@"%u", fetchRequest.fetchOffset],
                                    @"filters[filter]": @"All"
                                    };
    
    requestParameter.urlPath = [NSString stringWithFormat:@"mixes/%@", fetchRequest.profileName];
    
    return requestParameter;
}

-(MSHTTPRequestParameter *)requestPathForObject:(NSManagedObject *)managedObject
{
    //TODO:  have a centralized helper for parsing entity keys
    NSString *mixEntityKey = [managedObject valueForKey:kMSPlaylistMappingModelAttributeKeyEntityKey];
    NSString *profileEntityKey = [managedObject valueForKey:kMSPlaylistMappingModelAttributeKeyOwnerEntityKey];
    NSString *mixId = [[mixEntityKey componentsSeparatedByString:@"_"] lastObject];
    NSString *profileId = [[profileEntityKey componentsSeparatedByString:@"_"] lastObject];
    
    MSHTTPRequestParameter *requestParameter = [[MSHTTPRequestParameter alloc]init];
    
    requestParameter.HTTPMethod = @"POST";

    requestParameter.urlPath = [NSString stringWithFormat:@"mixes/%@/%@", profileId, mixId];

    return requestParameter;
}

#pragma mark - Response Mapping

-(NSString *)resourceIdentifierForRepresentation:(NSDictionary *)representation ofEntity:(NSEntityDescription *)entity
{    
    return self.idMappingBlock(representation);
}

@end
