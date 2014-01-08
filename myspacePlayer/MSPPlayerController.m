//
//  MSPPlayerController.m
//  myspacePlayer
//
//  Created by Andrew Beaupre on 10/8/13.
//  Copyright (c) 2013 Andrew Beaupre. All rights reserved.
//

#import "MSPPlayerController.h"
#import "MSPMediaItem.h"
#import <MediaPlayer/MediaPlayer.h>
#import "MSPMediaPlayerViewModel.h"
#import "MSPMediaItemViewModel.h"
#import <ReactiveCocoa.h>
#import <ReactiveCocoa/RACEXTScope.h>


@interface MSPPlayerController ()

@property (nonatomic, strong)   AVQueuePlayer           *audioPlayer;
@property (nonatomic, readwrite)           BOOL                    isPlaying;
@property (nonatomic, strong, readwrite)   NSString                *playerStatus;
@property (nonatomic, readwrite) BOOL                   playbackHasStopped;

@end

@implementation MSPPlayerController
{
}

@synthesize isPlaying;

- (id)init
{
    self = [super init];
    if (self) {
        
        self.audioPlayer = [[AVQueuePlayer alloc] init];
                
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(playerItemDidReachEnd:)
                                                     name:AVPlayerItemDidPlayToEndTimeNotification
                                                   object:nil];

        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(playerItemFailedToPlayToEnd:)
                                                     name:AVPlayerItemFailedToPlayToEndTimeNotification
                                                   object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(playerItemPlaybackStalled:)
                                                     name:AVPlayerItemPlaybackStalledNotification
                                                   object:nil];
        
    }

    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


#pragma mark - public Methods

- (RACSignal *)playbackEndedSignal
{

    RACSignal *signal = [RACObserve(self, playbackHasStopped)
                         filter:^BOOL(NSNumber *value) {
                             return [value boolValue];
                         }];
    
    __block BOOL playbackHasStopped = self.playbackHasStopped;
    
    [RACObserve(self, playbackHasStopped) subscribeNext:^(id x) {
        playbackHasStopped = NO;
    }];
    

    return signal;
}

- (void) togglePlayback
{
    if(self.audioPlayer.rate)
    {
        [self.audioPlayer pause];

        self.isPlaying = NO;
        
        self.playerStatus = @"player paused.";
    }
    else
    {
        [self.audioPlayer play];

        self.isPlaying = YES;

        self.playerStatus = @"player resumed.";
    }
    
}

- (void) addMediaItemToQueue: (MSPMediaItem *)mediaItem andPlay: (BOOL)shouldPlay
{
    if(!mediaItem) return;
    
    AVPlayerItem *playerItem = [AVPlayerItem playerItemWithURL:[NSURL URLWithString:mediaItem.urlToFile]];
    
    if([self.audioPlayer canInsertItem:playerItem afterItem:nil])
    {
        NSUInteger currentItemsInQueuePlayer = self.audioPlayer.items.count;
        
        [self.audioPlayer insertItem:playerItem afterItem:nil];
        
        if(currentItemsInQueuePlayer)
        {
            [self moveToNextItemInQueue];
            
        }
        
        [self setNowPlayingComponents: mediaItem];

        //TODO:  what's the deal with background music playing and this sort of keepalive?  Should this be in the AppDelegate and only execute when the app is sent to the background?  It would need to continue to be kept alive by music plays
        if ([[UIDevice currentDevice] isMultitaskingSupported])
        {
            UIApplication *application = [UIApplication sharedApplication];
            
            __block UIBackgroundTaskIdentifier background_task;
            
            background_task = [application beginBackgroundTaskWithName:@"musicPlayerBackgroundTask" expirationHandler: ^ {

                [application endBackgroundTask: background_task];
                
                background_task = UIBackgroundTaskInvalid;
            }];
            
        }
        
        self.playerStatus = [NSString stringWithFormat:@"Audio Player has queued up %@ - %@", mediaItem.artistName, mediaItem.title];

        self.playbackHasStopped = NO;

    }
}

#pragma mark - private, update interface

- (void)setNowPlayingComponents: (MSPMediaItem *)mediaItem
{
    
    NSDictionary *nowPlayingInfo = nil;
    
    if(mediaItem)
    {
        
        nowPlayingInfo = [NSDictionary dictionaryWithObjectsAndKeys:
                          mediaItem.artistName,                     MPMediaItemPropertyArtist,
                          mediaItem.title,                          MPMediaItemPropertyTitle,
                          mediaItem.albumTitle,                     MPMediaItemPropertyAlbumTitle,
                          [NSNumber numberWithDouble:self.audioPlayer.rate],MPNowPlayingInfoPropertyPlaybackRate,
                          @(CMTimeGetSeconds(self.audioPlayer.currentItem.duration)),MPMediaItemPropertyPlaybackDuration,
                          nil];
        
    }
    
    MPNowPlayingInfoCenter *defaultCenter = [MPNowPlayingInfoCenter defaultCenter];
    
    defaultCenter.nowPlayingInfo = nowPlayingInfo;
    
}

- (void) moveToNextItemInQueue
{
    [self.audioPlayer advanceToNextItem];
    
}

#pragma mark AVQueuePlayer Notifications

- (void)playerItemDidReachEnd:(NSNotification *)notification {
    
    self.playerStatus = @"Audio Player has finished playing.";
    
    self.playbackHasStopped = YES;

}

- (void)playerItemFailedToPlayToEnd:(NSNotification *)notification {
    
    self.playerStatus = @"Audio Player failed to complete playing.";
    
    self.playbackHasStopped = YES;
    
}

- (void)playerItemPlaybackStalled:(NSNotification *)notification {
    
    self.playerStatus = @"Audio Player stalled playback.";

    self.playbackHasStopped = YES;
    
}
@end
