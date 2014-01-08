//
//  MSPMediaQueueFetchRequest.h
//  myspacePlayer
//
//  Created by Andrew Beaupre on 10/25/13.
//  Copyright (c) 2013 Andrew Beaupre. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface MSPMediaQueueFetchRequest : NSFetchRequest

@property (nonatomic, strong) NSNumber *genreId;

+(MSPMediaQueueFetchRequest *)fetchRequestWithEntityName:(NSString *)entityName;

@end
