//
//  MSIncrementalStoreHTTPClient.h
//  MSModelIntegration
//
//  Created by Andrew Beaupre on 11/4/13.
//  Copyright (c) 2013 Andrew Beaupre. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "AFRESTClient.h"
#import "AFIncrementalStore.h"



@interface MSIncrementalStoreHTTPClient : AFRESTClient<AFIncrementalStoreHTTPClient>

+(MSIncrementalStoreHTTPClient *)sharedClientWithBaseURL:(NSString *)baseURL;

@end
