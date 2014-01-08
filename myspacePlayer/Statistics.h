//
//  Statistics.h
//  myspacePlayer
//
//  Created by Andrew Beaupre on 11/5/13.
//  Copyright (c) 2013 Andrew Beaupre. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Statistics : NSManagedObject

@property (nonatomic, retain) NSNumber * connectCount;
@property (nonatomic, retain) NSNumber * commentCount;
@property (nonatomic, retain) NSNumber * likeCount;
@property (nonatomic, retain) NSNumber * shareCount;

@end
