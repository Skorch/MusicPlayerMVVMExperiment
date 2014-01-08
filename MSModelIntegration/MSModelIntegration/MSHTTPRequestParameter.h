//
//  MSHTTPRequestParameter.h
//  myspacePlayer
//
//  Created by Andrew Beaupre on 11/6/13.
//  Copyright (c) 2013 Andrew Beaupre. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MSHTTPRequestParameter : NSObject

@property (nonatomic, strong) NSString *HTTPMethod;

@property (nonatomic, strong) NSDictionary *PostValues;

@property (nonatomic, strong) NSString *urlPath;

@end
