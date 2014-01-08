//
//  MSPMediaItemViewModel.h
//  myspacePlayer
//
//  Created by Andrew Beaupre on 10/15/13.
//  Copyright (c) 2013 Andrew Beaupre. All rights reserved.
//

#import <Foundation/Foundation.h>

@class RACSignal;
@class MSPMediaItem;

@interface MSPMediaItemViewModel : NSObject


+(MSPMediaItemViewModel *) viewModelWithMediaItem:(MSPMediaItem *)mediaItem;
-(id) initWithMediaItem:(MSPMediaItem *)mediaItem;

@property (nonatomic, strong, readonly) RACSignal *songTitleSignal;
@property (nonatomic, strong, readonly) RACSignal *albumTitleSignal;
@property (nonatomic, strong, readonly) RACSignal *artistNameSignal;
@property (nonatomic, strong, readonly) RACSignal *thumbnailImageSignal;

@end
