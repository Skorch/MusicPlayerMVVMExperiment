//
//  MSPMediaItemMapping.m
//  myspacePlayer
//
//  Created by Andrew Beaupre on 11/4/13.
//  Copyright (c) 2013 Andrew Beaupre. All rights reserved.
//


#import "MSMediaItemMapping.h"

@interface MSMediaItemMapping ()

@property (nonatomic, strong) NSDictionary *keyMappingBlocks;

@end

@implementation MSMediaItemMapping
//Entity Names
static NSString * const kMSPEntityTypeMediaItem = @"MediaItem";

//Base Url
static NSString * const kMSPMediaQueueBaseURLString = @"https://itunes.apple.com/";


//MediaItem attribute paths
static NSString * const kMSPMediaQueueResponseSchemaBase = @"feed.entry";
static NSString * const kMSPMediaQueueResponseSchemaIdAttributesId = @"id.attributes.im:id";
static NSString * const kMSPMediaQueueResponseSchemaNameLabel = @"im:name.label";
static NSString * const kMSPMediaQueueResponseSchemaArtistLabel = @"im:artist.label";
static NSString * const kMSPMediaQueueResponseSchemaCollectionNameLabel = @"im:collection.im:name.label";
static NSString * const kMSPMediaQueueResponseSchemaLink = @"link";
static NSString * const kMSPMediaQueueResponseSchemaLinkAttributeValuePreview = @"Preview";
static NSString * const kMSPMediaQueueResponseSchemaLinkAttributeHref = @"attributes.href";
static NSString * const kMSPMediaQueueResponseSchemaImage = @"im:image";
static NSString * const kMSPMediaQueueResponseSchemaImageLabel = @"label";
static NSString * const kMSPMediaQueueResponseSchemaCategoryAttributesId = @"category.attributes.im:id";
static NSString * const kMSPMediaQueueResponseSchemaChartPosition = @"chartPosition";


- (id)init
{
    self = [super init];
    if (self) {
        
        _keyMappingBlocks = [NSDictionary dictionaryWithObjectsAndKeys:
                             //====[ id ]====
                             ^id(NSDictionary *representation){
                                 
                                 NSNumber *idValue = nil;
                                 
                                 NSString *idString = [representation valueForKeyPath:kMSPMediaQueueResponseSchemaIdAttributesId];
                                 
                                 idValue = [NSNumber numberWithInt:[idString integerValue]];
                                 
                                 return idValue;
                             }, @"id",
                             
                             //====[ genreId ]====
                             ^id(NSDictionary *representation){
                                 
                                 NSNumber *idValue = nil;
                                 
                                 NSString *idString = [representation valueForKeyPath:kMSPMediaQueueResponseSchemaCategoryAttributesId];
                                 
                                 idValue = [NSNumber numberWithInt:[idString integerValue]];
                                 
                                 return idValue;
                                 
                             }, @"genreId",
                             
                             //====[ title ]====
                             ^id(NSDictionary *representation){
                                 return [representation valueForKeyPath:kMSPMediaQueueResponseSchemaNameLabel];
                             }, @"title",
                             
                             //====[ albumTitle ]====
                             ^id(NSDictionary *representation){
                                 return [representation valueForKeyPath:kMSPMediaQueueResponseSchemaCollectionNameLabel];
                             }, @"albumTitle",
                             
                             //====[ artistName ]====
                             ^id(NSDictionary *representation){
                                 return [representation valueForKeyPath:kMSPMediaQueueResponseSchemaArtistLabel];
                             }, @"artistName",
                             
                             //====[ urlToFile ]====
                             ^id(NSDictionary *representation){
                                 NSArray *links = [representation valueForKeyPath:kMSPMediaQueueResponseSchemaLink];
                                 
                                 NSDictionary *attribute = [[links
                                                             filteredArrayUsingPredicate:[NSPredicate
                                                                                          predicateWithFormat:[NSString
                                                                                                               stringWithFormat:@"attributes.title == '%@'",
                                                                                                               kMSPMediaQueueResponseSchemaLinkAttributeValuePreview]]
                                                             ] firstObject];
                                 
                                 NSString *value = [attribute valueForKeyPath:kMSPMediaQueueResponseSchemaLinkAttributeHref];
                                 
                                 return value;
                             }, @"urlToFile",
                             
                             //====[ urlToThumbnail ]====
                             ^id(NSDictionary *representation){
                                 NSArray *links = [representation valueForKey:kMSPMediaQueueResponseSchemaImage];
                                 
                                 NSDictionary *attribute = [links lastObject];
                                 
                                 NSString *value = [attribute valueForKeyPath:kMSPMediaQueueResponseSchemaImageLabel];
                                 
                                 return value;
                             }, @"urlToThumbnail",
                             
                             //====[ chartPosition ]====
                             ^id(NSDictionary *representation){
                                 return [representation valueForKeyPath:kMSPMediaQueueResponseSchemaChartPosition];
                             }, @"chartPosition",
                             
                             
                             
                             nil] ;
        
        
    }
    return self;
}

#pragma mark - MSModelIntegrationMapping

-(NSString *)entityName
{
    return kMSPEntityTypeMediaItem;
}

-(NSString *)rootResponsePath
{
    return kMSPMediaQueueResponseSchemaBase;
}

-(NSString *)resourceIdentifierForRepresentation:(NSDictionary *)representation ofEntity:(NSEntityDescription *)entity
{
    id(^mappingBlock)(NSDictionary *) = [self.keyMappingBlocks valueForKey:@"id"];

    NSNumber *numberValue = mappingBlock(representation);
    
    return [numberValue stringValue];
    
}

- (NSDictionary *)attributesForRepresentation:(NSDictionary *)representation
                                     ofEntity:(NSEntityDescription *)entity
{
    NSMutableDictionary *mutablePropertyValues = [NSMutableDictionary dictionary];
    
    NSLog(@"mapping property values for entity.name: %@", entity.name);
    
    for (NSString *key in self.keyMappingBlocks)
    {
        id(^mappingBlock)(NSDictionary *) = [self.keyMappingBlocks valueForKey:key];
        
        [mutablePropertyValues setValue:mappingBlock(representation) forKey:key];
    }
    
    return mutablePropertyValues;
}

@end
