//
//  MSPViewModelCommonSignals.h
//  myspacePlayer
//
//  Created by Andrew Beaupre on 10/30/13.
//  Copyright (c) 2013 Andrew Beaupre. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ReactiveCocoa.h>

@interface MSPViewModelCommonSignals : NSObject

-(RACSignal *)imageDownloadedSignal: (NSURL *)urlToThumbnail;

@end
