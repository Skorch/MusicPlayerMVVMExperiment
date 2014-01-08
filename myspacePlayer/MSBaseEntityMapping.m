//
//  MSBaseEntityMapping.m
//  myspacePlayer
//
//  Created by Andrew Beaupre on 11/6/13.
//  Copyright (c) 2013 Andrew Beaupre. All rights reserved.
//

#import "MSBaseEntityMapping.h"

@implementation MSBaseEntityMapping


NSString * const MSIncrementalStoreBaseMappingUnimplementedMethodException = @"com.myspace.incremental-store.mapping.exceptions.unimplemented-method";


- (id)init
{
    self = [super init];
    if (self) {
        self.idMappingBlock = ^id(NSDictionary * representation){
            @throw([NSException exceptionWithName:MSIncrementalStoreBaseMappingUnimplementedMethodException reason:NSLocalizedString(@"Unimplemented method: +baseURL. Must be overridden in a subclass", nil) userInfo:nil]);
        };
        
        
    }
    return self;
}

#pragma mark - Mapping Descriptions

-(NSString *)entityName
{
    @throw([NSException exceptionWithName:MSIncrementalStoreBaseMappingUnimplementedMethodException reason:NSLocalizedString(@"Unimplemented method: +baseURL. Must be overridden in a subclass", nil) userInfo:nil]);
}

-(NSString *)rootResponsePath
{
    @throw([NSException exceptionWithName:MSIncrementalStoreBaseMappingUnimplementedMethodException reason:NSLocalizedString(@"Unimplemented method: +baseURL. Must be overridden in a subclass", nil) userInfo:nil]);
}

-(NSString *)defaultGetMethod
{
    return @"POST";
}

#pragma mark - Response Mapping

-(NSString *)resourceIdentifierForRepresentation:(NSDictionary *)representation ofEntity:(NSEntityDescription *)entity
{
    @throw([NSException exceptionWithName:MSIncrementalStoreBaseMappingUnimplementedMethodException reason:NSLocalizedString(@"Unimplemented method: +baseURL. Must be overridden in a subclass", nil) userInfo:nil]);
}

-(NSDictionary *)attributesForRepresentation:(NSDictionary *)representation ofEntity:(NSEntityDescription *)entity
{
    NSMutableDictionary *mutablePropertyValues = [NSMutableDictionary dictionary];
    
    NSLog(@"mapping property values for entity.name: %@", entity.name);
    
    if(self.attributeKeyMappingBlocks != nil)
    {
        for (NSString *key in self.attributeKeyMappingBlocks)
        {
            id(^mappingBlock)(NSDictionary *) = [self.attributeKeyMappingBlocks valueForKey:key];
            
            [mutablePropertyValues setValue:mappingBlock(representation) forKey:key];
        }
    }
    
    return mutablePropertyValues;
    
}

-(NSDictionary *)representationsForRelationshipsFromRepresentation:(NSDictionary *)representation ofEntity:(NSEntityDescription *)entity fromResponse:(NSHTTPURLResponse *)response
{
    NSMutableDictionary *mutableRelationshipRepresentations = [NSMutableDictionary dictionary];
    
    NSLog(@"mapping relationship representations for entity.name: %@", entity.name);
    
    if(self.relationshipRepresentationsKeyMappingBlocks != nil)
    {
        for (NSString *key in self.relationshipRepresentationsKeyMappingBlocks)
        {
            id(^mappingBlock)(NSDictionary *) = [self.relationshipRepresentationsKeyMappingBlocks valueForKey:key];
            
            [mutableRelationshipRepresentations setValue:mappingBlock(representation) forKey:key];
        }        
    }
    
    return mutableRelationshipRepresentations;
}
@end
