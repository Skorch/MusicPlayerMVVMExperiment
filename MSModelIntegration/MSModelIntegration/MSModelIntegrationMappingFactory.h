//
//  MSModelIntegrationMappingFactory.h
//  MSModelIntegration
//
//  Created by Andrew Beaupre on 11/4/13.
//  Copyright (c) 2013 Andrew Beaupre. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@protocol MSModelIntegrationMapping;


@interface MSModelIntegrationMappingFactory : NSObject

+ (MSModelIntegrationMappingFactory *)sharedInstance;

- (void)addMapping:(id<MSModelIntegrationMapping>)mapping;

- (id<MSModelIntegrationMapping>)getMappingForEntity:(NSEntityDescription *)entity;



@end
