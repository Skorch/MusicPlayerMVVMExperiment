//
//  MSModelIntegrationMappingFactory.m
//  MSModelIntegration
//
//  Created by Andrew Beaupre on 11/4/13.
//  Copyright (c) 2013 Andrew Beaupre. All rights reserved.
//

#import "MSModelIntegrationMappingFactory.h"
#import "MSModelIntegrationMapping.h"

@interface MSModelIntegrationMappingFactory ()

@property (nonatomic, strong) NSMutableDictionary *mappings;

@end

@implementation MSModelIntegrationMappingFactory

#pragma mark Initializers

+ (MSModelIntegrationMappingFactory *)sharedInstance
{
    static MSModelIntegrationMappingFactory *_sharedClient = nil;
    static dispatch_once_t token;
    
    dispatch_once(&token, ^{
        _sharedClient = [[MSModelIntegrationMappingFactory alloc] init];
    });
    
    return _sharedClient;
    
}

- (id)init
{
    self = [super init];
    if (self)
    {
        _mappings = [NSMutableDictionary dictionary];
    }
    return self;
}

#pragma mark - Public Methods

- (void)addMapping:(id<MSModelIntegrationMapping>)mapping
{
    [self.mappings setValue:mapping forKey:[mapping entityName]];
}

- (id<MSModelIntegrationMapping>)getMappingForEntity:(NSEntityDescription *)entity
{
    id mapping = [self.mappings valueForKey:entity.name];
    
    //try derriving the object
    if(mapping == nil)
    {
        mapping = [[NSClassFromString([NSString stringWithFormat:@"MS%@Mapping", entity.name]) alloc] init];
        
        if(mapping != nil) [self.mappings setValue:mapping forKey:entity.name];
    }
    
    if(mapping == nil) NSLog(@"Could not load mapping object for %@", entity.name);
    
    return mapping;
}


@end
