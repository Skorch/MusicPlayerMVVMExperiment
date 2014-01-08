//
//  MSBaseMapping.h
//  myspacePlayer
//
//  Created by Andrew Beaupre on 11/5/13.
//  Copyright (c) 2013 Andrew Beaupre. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MSModelIntegrationMapping.h"

@interface MSBaseMapping : NSObject<MSModelIntegrationMapping>


@property (nonatomic, strong) NSString *rootResponsePath;

@property (nonatomic, strong) NSString *entityName;

@end
