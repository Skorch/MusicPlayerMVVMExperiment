//
//  MSPPlayerController.h
//  myspacePlayer
//
//  Created by Andrew Beaupre on 10/8/13.
//  Copyright (c) 2013 Andrew Beaupre. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@class MSPMediaItem;
@class MSPMediaPlayerViewModel;
@class RACSignal;

typedef void(^PlaybackEventCallback)();

@interface MSPPlayerController : NSObject<AVAudioPlayerDelegate>

@property (nonatomic, readonly) BOOL playbackHasStopped;
@property (nonatomic, readonly) BOOL isPlaying;
@property (nonatomic, strong, readonly) NSString *playerStatus;
@property (nonatomic, strong, readonly) RACSignal *playbackEndedSignal;

- (void) togglePlayback;

- (void) addMediaItemToQueue: (MSPMediaItem *)mediaItem andPlay: (BOOL)shouldPlay;

- (void) moveToNextItemInQueue;

@end
