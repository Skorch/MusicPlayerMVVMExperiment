//
//  MSModelIntegrationMapping.h
//  MSModelIntegration
//
//  Created by Andrew Beaupre on 10/31/13.
//  Copyright (c) 2013 Andrew Beaupre. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "MSHTTPRequestParameter.h"

@protocol MSModelIntegrationMapping <NSObject>


/**
 
 Returns a Key-Value Code to the root path of the represenation or list of representations
 
 @discussion For example, @"response.items"
 
 @return An `NSString` identifyin the root path of the response
 
 */
@property (nonatomic, strong, readonly) NSString *rootResponsePath;

/**
 Returns a `NSString` identifying the `NSEntityDescription`.name that this mapping class will be registered as.
 
 @discussion eg: if your model is named `User`, then that should be returned by this method
 
 @returns `NSString` uniquely identifying your entity name.
 */
@property (nonatomic, strong, readonly) NSString *entityName;

///-----------------------
/// @name Required Methods
///-----------------------




#pragma mark - mappings for server responses


/**
 Returns the attribute mappings between the de-serialized represenation and the managed object.  This method is used to map the de-serialized response to the structure of the managed object model
 
 @discussion It is recommended to create a series of mapping KVC paths which represent the JSON path to the attribute.  eg. @"category.attributes.im:id"
 
 @param representation A `NSDictionary` representing the nested, deserialized JSON response.
 @param entity The description of the entity to be mapped.
 
 @return An `NSDictionary` containing the attributes for a managed object.
 */
- (NSDictionary *)attributesForRepresentation:(NSDictionary *)representation
                                     ofEntity:(NSEntityDescription *)entity;

@optional

/**
 Returns an `NSDictionary` containing the representations of associated objects found within the representation of a response object, keyed by their relationship name.
 
 @discussion For example, if `GET /albums/123` returned the representation of an album, including the tracks as sub-entities, keyed under `"tracks"`, this method would return a dictionary with an array of representations for those objects, keyed under the name of the relationship used in the model (which is likely also to be `"tracks"`). Likewise, if an album also contained a representation of its artist, that dictionary would contain a dictionary representation of that artist, keyed under the name of the relationship used in the model (which is likely also to be `"artist"`).
 
 @param representation The resource representation.
 @param entity The entity for the representation.
 @param response The HTTP response for the resource request.
 
 @return An `NSDictionary` containing representations of relationships, keyed by relationship name.
 */
- (NSDictionary *)representationsForRelationshipsFromRepresentation:(NSDictionary *)representation
                                                           ofEntity:(NSEntityDescription *)entity
                                                       fromResponse:(NSHTTPURLResponse *)response;

/**
 Returns the resource identifier for the resource whose representation of an entity came from the specified HTTP response. A resource identifier is a string that uniquely identifies a particular resource among all resource types. If new attributes come back for an existing resource identifier, the managed object associated with that resource identifier will be updated, rather than a new object being created.
 
 @discussion For example, if `GET /posts` returns a collection of posts, the resource identifier for any particular one might be its URL-safe "slug" or parameter string, or perhaps its numeric id.  For example: `/posts/123` might be a resource identifier for a particular post.
 
 @param representation The resource representation.
 @param entity The entity for the representation.
 
 @return An `NSString` resource identifier for the resource.
 */
- (NSString *)resourceIdentifierForRepresentation:(NSDictionary *)representation
                                         ofEntity:(NSEntityDescription *)entity;

/**
 Returns a `BOOL` indicating whether the framework should pre-fetch relationship objects
 
 @discussion If the response doesn't include foreign key relationships and,  for performance reasons, a particular foreign key relationship should be fetched. The decision should be made on the `NSRelationshipDescription` provided.
 
 @param relationship A `NSRelationshipDescription` describing the entity type.
 
 @return YES if further HTTP calls should be made to fetch the item(s) for the relationship.
 */
- (BOOL)shouldFetchRemoteValuesForRelationship:(NSRelationshipDescription *)relationship;

#pragma mark - url building for fetching data
/**
 Returns a URL request object for the specified fetch request within a particular managed object context.
 
 @discussion For example, if the fetch request specified the `User` entity, this method might return an `NSURLRequest` with `GET /users`
 
 @param fetchRequest The fetch request to translate into a URL request.
 
 @return An `NSURLRequest` object corresponding to the specified fetch request.
 */
- (MSHTTPRequestParameter *)requestPathForFetchRequest:(NSFetchRequest *)fetchRequest;

/**
 Returns a URL request object for the specified object ID.
 
 @discussion For example, if the fetch request specified `User_123` entity, this method might return an `NSURLRequest` with `GET /user/123`
 
 @param managedObject The `NSManagedObject` to fetch.
 
 @return An `NSString`  corresponding to the path for the request.
 */

- (MSHTTPRequestParameter *)requestPathForObject:(NSManagedObject *)managedObject;


#pragma mark - url building for writing to server

/**
 
 */
- (NSString *)requestPathForInsertedObject:(NSManagedObject *)insertedObject;

/**
 
 */
- (NSString *)requestPathForUpdatedObject:(NSManagedObject *)updatedObject;

/**
 Returns the `NSMutableURLRequest` to fetch the list of specified relationships for the specified object
 
 @param relationship type the relationship to fetch
 @param the ObjectID of the entity to get the relationships for
 
 @return `NSMutableURLRequest` of the HTTP path to fetch
 
 */
-(NSString *)requestPathForRelationship:(NSRelationshipDescription *)relationship forObjectWithID:(NSManagedObjectID *)objectID;

/**
 
 */
- (NSString *)requestPathForDeletedObject:(NSManagedObject *)deletedObject;


#pragma mark - mappings for sending to server

/**
 Returns the attributes representation of an entity from the specified managed object. This method is used to get the attributes of the representation from its managed object.
 
 @discussion For example, if the representation sent to `POST /products` or `PUT /products/123` had a `description` field that corresponded with the `productDescription` attribute in its Core Data model, this method would set the value of the `productDescription` field to the value of the `description` key in representation/dictionary.
 
 @param attributes The resource representation.
 @param managedObject The `NSManagedObject` for the representation.
 
 @return An `NSDictionary` containing the attributes for a representation, based on the given managed object.
 */
- (NSDictionary *)representationOfAttributes:(NSDictionary *)attributes
                             ofManagedObject:(NSManagedObject *)managedObject;

/**
 Returns an `NSDictionary` or an `NSArray` of `NSDictionaries` containing the representations of the resources found in a response object.
 
 @discussion For example, if `GET /users` returned an `NSDictionary` with an array of users keyed on `"users"`, this method would return the keyed array. Conversely, if `GET /users/123` returned a dictionary with all of the atributes of the requested user, this method would simply return that dictionary.
 
 @param entity The entity represented
 @param responseObject The response object returned from the server.
 
 @return An `NSDictionary` with the representation or an `NSArray` of `NSDictionaries` containing the resource representations.
 */
- (id)representationOrArrayOfRepresentationsOfEntity:(NSEntityDescription *)entity
                                  fromResponseObject:(id)responseObject;




@optional


@end
