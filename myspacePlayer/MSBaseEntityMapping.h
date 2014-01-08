//
//  MSBaseEntityMapping.h
//  myspacePlayer
//
//  Created by Andrew Beaupre on 11/6/13.
//  Copyright (c) 2013 Andrew Beaupre. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MSModelIntegrationMapping.h"

typedef id(^entityMappingBlock)(NSDictionary *);
typedef NSString *(^stringEntityMappingBlock)(NSDictionary *);
typedef NSNumber *(^numberEntityMappingBlock)(NSDictionary *);
typedef NSDictionary *(^dictionaryEntityMappingBlock)(NSDictionary *);
typedef NSArray *(^arrayEntityMappingBlock)(NSDictionary *);

@interface MSBaseEntityMapping : NSObject<MSModelIntegrationMapping>

@property (nonatomic, strong) NSDictionary *attributeKeyMappingBlocks;

@property (nonatomic, strong) NSDictionary *relationshipRepresentationsKeyMappingBlocks;

@property (nonatomic, strong) entityMappingBlock idMappingBlock;

@end
