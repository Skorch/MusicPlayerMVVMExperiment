//
//  MSIncrementalStoreHTTPClient.m
//  MSModelIntegration
//
//  Created by Andrew Beaupre on 11/4/13.
//  Copyright (c) 2013 Andrew Beaupre. All rights reserved.
//

#import "MSIncrementalStoreHTTPClient.h"
#import "MSModelIntegrationMapping.h"
#import "MSModelIntegrationMappingFactory.h"
#import <AFIncrementalStore.h>
#import "UIDevice+Hardware.h"

@interface MSIncrementalStoreHTTPClient ()

@property (nonatomic, strong) MSModelIntegrationMappingFactory *mappingFactory;

@end

@implementation MSIncrementalStoreHTTPClient

#pragma mark - Init

+(MSIncrementalStoreHTTPClient *)sharedClientWithBaseURL:(NSString *)baseURL
{
    static MSIncrementalStoreHTTPClient *_sharedClient = nil;
    static dispatch_once_t token;
    
    dispatch_once(&token, ^{
        _sharedClient = [[MSIncrementalStoreHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:baseURL]];
    });
    
    return _sharedClient;
}

-(id)initWithBaseURL:(NSURL *)url
{
    self = [super initWithBaseURL:url];
    if (!self) {
        return nil;
    }
    
    _mappingFactory = [MSModelIntegrationMappingFactory sharedInstance];
    
    if(![self registerHTTPOperationClass:[AFJSONRequestOperation class]]) NSLog(@"Could not register AFJSONRequestOperation.");
    [self setDefaultHeader:@"hash"  value:@"ODkwYzM1YTUzM2JlNjllZljDhmbDqMOsFxnDoEbDicOcwrzCjMO4wrAnwoUKw5XDm8KPXS1uNVvDoDURAMOgFTtyQcKCw4bCksOtwoXDmsKTIMKJAcKyZ8KPW8K/w7xeUARww4lTVl7CscOkG8OVF8O5w6TDrCPDtWHCtcKVNcOmwoLCkhw1w6UYw7AxZcKuwpbClsOJYD3DhMKVwofDtMKuw7PCtwLCl8KAw7IGWzZ+wpMOw6/CvsKuwpBRSQ%3D%3D"];

    NSDictionary *info = [[NSBundle mainBundle] infoDictionary];

    NSString *version = [info objectForKey: @"CFBundleShortVersionString"];
    
	[self setDefaultHeader: @"Accept" value: @"application/json"];
    [self setDefaultHeader: @"Content-Type" value: @"application/json"];
    [self setDefaultHeader: @"User-Agent" value: [@"Myspace iPhone " stringByAppendingString: version]];
    [self setDefaultHeader: @"X-Device-Platform" value: [[UIDevice currentDevice] platform]];

    return self;
}

#pragma mark - AFIncrementalStore
#pragma mark Identifier
-(NSString *)resourceIdentifierForRepresentation:(NSDictionary *)representation ofEntity:(NSEntityDescription *)entity fromResponse:(NSHTTPURLResponse *)response
{
    id<MSModelIntegrationMapping> mapping = [self.mappingFactory getMappingForEntity:entity];
    
    return [mapping resourceIdentifierForRepresentation:representation
                                                   ofEntity:entity];
}

#pragma mark Response to Model Mappings

//returns property mappings
- (NSDictionary *)attributesForRepresentation:(NSDictionary *)representation
                                     ofEntity:(NSEntityDescription *)entity
                                 fromResponse:(NSHTTPURLResponse *)response
{
    id<MSModelIntegrationMapping> mapping = [self.mappingFactory getMappingForEntity:entity];

    if(mapping != nil)
    {
        
        NSMutableDictionary *mutableAttributes = [[super attributesForRepresentation:representation
                                                                           ofEntity:entity
                                                                        fromResponse:response] mutableCopy];
        
        
        NSDictionary *custom = [mapping attributesForRepresentation:representation
                                           ofEntity:entity];
        
        [mutableAttributes addEntriesFromDictionary:custom];
        
        return mutableAttributes;
    }
    
    return nil;
}

//returns relationship mappings
- (NSDictionary *)representationsForRelationshipsFromRepresentation:(NSDictionary *)representation
                                                           ofEntity:(NSEntityDescription *)entity
                                                       fromResponse:(NSHTTPURLResponse *)response;
{
    NSMutableDictionary *mutableRelationships = [[super representationsForRelationshipsFromRepresentation: representation
                                                                                                 ofEntity: entity
                                                                                             fromResponse:response] mutableCopy];
    
    id<MSModelIntegrationMapping> mapping = [self.mappingFactory getMappingForEntity:entity];

    if(mapping != nil && [mapping respondsToSelector:@selector(representationsForRelationshipsFromRepresentation:ofEntity:fromResponse:)])
    {
        NSDictionary *custom = [mapping representationsForRelationshipsFromRepresentation:representation
                                                                                 ofEntity:entity
                                                                             fromResponse:response];

        [mutableRelationships addEntriesFromDictionary:custom];
        
        return mutableRelationships;
    }
    
    return mutableRelationships;
}

//returns root item(s) from fetch
-(id)representationOrArrayOfRepresentationsOfEntity:(NSEntityDescription *)entity fromResponseObject:(id)responseObject
{
    NSParameterAssert([responseObject isKindOfClass:[NSArray class]] || [responseObject isKindOfClass:[NSDictionary class]]);
    
    id ro = [super representationOrArrayOfRepresentationsOfEntity:entity fromResponseObject:responseObject];

    id<MSModelIntegrationMapping> mapping = [self.mappingFactory getMappingForEntity:entity];
    
    if(mapping != nil)
    {
        if ([ro isKindOfClass:[NSDictionary class]]) {
            id value = nil;
            value = [ro valueForKeyPath:[mapping rootResponsePath]];
            if (value) {
                return value;
            }
        }
        
        return ro;
    }
    
    return nil;
}


#pragma mark Model to Request Mappings
//serialize attributes into JSON mapping
-(NSDictionary *)representationOfAttributes:(NSDictionary *)attributes ofManagedObject:(NSManagedObject *)managedObject
{
    id<MSModelIntegrationMapping> mapping = [self.mappingFactory getMappingForEntity:managedObject.entity];
    
    if([mapping respondsToSelector:@selector(representationOfAttributes:ofManagedObject:)])
    {
        return [mapping representationOfAttributes:attributes ofManagedObject:managedObject];
    }
    
    return nil;
}


-(NSMutableURLRequest *)requestFromParameter:(MSHTTPRequestParameter *)requestParameter
{
    
    if(requestParameter == nil) return nil;
    
    NSMutableURLRequest *request = [self requestWithMethod:requestParameter.HTTPMethod path:requestParameter.urlPath parameters:nil];
    
    return request;
    if([requestParameter.HTTPMethod isEqualToString:@"POST"])
    {
        NSMutableString * postString = [[NSMutableString alloc] init];
        
        for (NSString *key in requestParameter.PostValues) {
            NSString *postValue = [requestParameter.PostValues valueForKey:key];
            
            [postString appendFormat:@"%@=%@", key, postValue];
        }
        
        [request setHTTPBody:[postString dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
    return request;
    
}

#pragma mark URL generation
//url for list of items
- (NSMutableURLRequest *)requestForFetchRequest:(NSFetchRequest *)fetchRequest
                             withContext:(NSManagedObjectContext *)context
{
    NSMutableURLRequest *request = nil;

    id<MSModelIntegrationMapping> mapping = [self.mappingFactory getMappingForEntity:fetchRequest.entity];
    
    if(mapping && [mapping respondsToSelector:@selector(requestPathForFetchRequest:)])
    {
        
        MSHTTPRequestParameter *requestParameter = [mapping requestPathForFetchRequest:fetchRequest];

        request = [self requestFromParameter:requestParameter];
    }
    
    return request;
}

//eg: URL to GET single item or POST update
-(NSMutableURLRequest *)requestWithMethod:(NSString *)method pathForObjectWithID:(NSManagedObjectID *)objectID withContext:(NSManagedObjectContext *)context
{
    NSMutableURLRequest *request = nil;
    
    id<MSModelIntegrationMapping> mapping = [self.mappingFactory getMappingForEntity:objectID.entity];
    
    if(mapping)
    {
        if([method isEqualToString:@"GET"])
        {
            if([mapping respondsToSelector:@selector(requestPathForObject:)])
            {
                NSManagedObject *entityObject = [context objectWithID:objectID];
                
                MSHTTPRequestParameter *requestParameter = [mapping requestPathForObject:entityObject];
                
                request = [self requestFromParameter:requestParameter];
            }

            //only call into the Super if we want it to "try" and generate the URL
            /*
            else
            {
                request = [super requestWithMethod:method
                               pathForObjectWithID:objectID
                                       withContext:context];
            }
 */
        }
    }
    
    return request;
}

//eg: URL to GET missing relationships
-(NSMutableURLRequest *)requestWithMethod:(NSString *)method
                      pathForRelationship:(NSRelationshipDescription *)relationship
                          forObjectWithID:(NSManagedObjectID *)objectID
                              withContext:(NSManagedObjectContext *)context
{
    NSMutableURLRequest *request = nil;

    id<MSModelIntegrationMapping> mapping = [self.mappingFactory getMappingForEntity:objectID.entity];
    
    if(mapping)
    {
        if([method isEqualToString:@"GET"])
        {
            if([mapping respondsToSelector:@selector(requestPathForRelationship:forObjectWithID:)])
            {
                NSString *requestPath = [mapping requestPathForRelationship:relationship forObjectWithID:objectID];
                
                if(requestPath != nil)
                    request = [self requestWithMethod:@"GET" path:requestPath parameters:nil];
            }
        }
    }
        
    
    return request;
    
}

//url for INSERT/POST
- (NSMutableURLRequest *)requestForInsertedObject:(NSManagedObject *)insertedObject
{
    id<MSModelIntegrationMapping> mapping = [self.mappingFactory getMappingForEntity:insertedObject.entity];
    
    if([mapping respondsToSelector:@selector(requestForInsertedObject:)])
    {
        NSString *requestPath = [mapping requestPathForInsertedObject:insertedObject];

        NSMutableURLRequest *request = nil;
        
        if(requestPath != nil)
            request = [self requestWithMethod:@"GET" path:requestPath parameters:nil];
        
        return request;
}
    
    return nil;
    
}

//url for UPDATE/PUT
-(NSMutableURLRequest *)requestForUpdatedObject:(NSManagedObject *)updatedObject
{
    id<MSModelIntegrationMapping> mapping = [self.mappingFactory getMappingForEntity:updatedObject.entity];
    
    if([mapping respondsToSelector:@selector(requestForUpdatedObject:)])
    {
        NSString *requestPath = [mapping requestPathForUpdatedObject:updatedObject];

        NSMutableURLRequest *request = nil;
        
        if(requestPath != nil)
            request = [self requestWithMethod:@"GET" path:requestPath parameters:nil];
        
        return request;
}
    
    return nil;
   
}

//url for DELETE operation
-(NSMutableURLRequest *)requestForDeletedObject:(NSManagedObject *)deletedObject
{
    id<MSModelIntegrationMapping> mapping = [self.mappingFactory getMappingForEntity:deletedObject.entity];
    
    if([mapping respondsToSelector:@selector(requestForDeletedObject:)])
    {
        NSString *requestPath = [mapping requestPathForDeletedObject:deletedObject];

        NSMutableURLRequest *request = nil;
        
        if(requestPath != nil)
            request = [self requestWithMethod:@"GET" path:requestPath parameters:nil];
        
        return request;
}
    
    return nil;
    
}

#pragma mark pre-fetch options
- (BOOL)shouldFetchRemoteAttributeValuesForObjectWithID:(NSManagedObjectID *)objectID
                                 inManagedObjectContext:(NSManagedObjectContext *)context
{
    return NO;
}

- (BOOL)shouldFetchRemoteValuesForRelationship:(NSRelationshipDescription *)relationship
                               forObjectWithID:(NSManagedObjectID *)objectID
                        inManagedObjectContext:(NSManagedObjectContext *)context
{
    id<MSModelIntegrationMapping> mapping = [self.mappingFactory getMappingForEntity:objectID.entity];
    
    if([mapping respondsToSelector:@selector(shouldFetchRemoteValuesForRelationship:)])
    {
        return [mapping shouldFetchRemoteValuesForRelationship:relationship];
    }
    
    return NO;
}



@end
