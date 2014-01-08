//
//  MSPMediaPlayerViewModel.m
//  myspacePlayer
//
//  Created by Andrew Beaupre on 10/8/13.
//  Copyright (c) 2013 Andrew Beaupre. All rights reserved.
//

#import "MSPMediaPlayerViewModel.h"

#import <ReactiveCocoa.h>
#import <ReactiveCocoa/RACEXTScope.h>
#import "MSPMediaItemViewModel.h"
#import "MSPMediaQueue.h"
#import "MSPGenreList.h"
#import "MSPGenreQueue.h"
#import "MSPViewModelCommonSignals.h"
#import "MSPPlayerController.h"

@interface MSPMediaPlayerViewModel()

@property (nonatomic, strong) MSPMediaQueue *mediaQueue;
@property (nonatomic, strong) MSPGenreList *genreList;
@property (nonatomic, strong) UIImage *thumbnailImage;
@property (nonatomic, strong) MSPViewModelCommonSignals *commonSignals;
@property (nonatomic, strong) MSPPlayerController *playerController;
@property (nonatomic, strong) NSNumber *currentGenre;

@end

@implementation MSPMediaPlayerViewModel

@synthesize mediaQueue = _mediaQueue;

- (id)init
{
    self = [super init];
    if (self) {
        
        _playerController = [[MSPPlayerController alloc] init];
        
        _mediaQueue = [[MSPMediaQueue alloc] init];
        
        _commonSignals = [[MSPViewModelCommonSignals alloc]init];
        
        _currentItemSignal = RACObserve(self.mediaQueue, currentItem);

        _currentGenre = @0;
        
        @weakify(self);

        //queue up the first song when the queue changes
        [RACObserve(self.mediaQueue, queueSize) subscribeNext:^(id x) {
            @strongify(self);
            [self.playerController addMediaItemToQueue:[self.mediaQueue getCurrentItem] andPlay:NO];
        }];
        
        //queue up the next item when playback stops or is faulted
        [self.playerController.playbackEndedSignal subscribeNext:^(id x) {
            @strongify(self);
            [self.playerController addMediaItemToQueue:[self.mediaQueue getNextItem] andPlay:YES];
        }];
        
    }
    return self;
    
}

#pragma mark - Mapping Signals

- (RACSignal *)currentGenreSignal
{
    return RACObserve(self, currentGenre);
}

- (RACSignal *)isPlayingSignal
{
    return RACObserve(self.playerController, isPlaying);
}

- (RACSignal *)playerStatusSignal
{
    return RACObserve(self.playerController, playerStatus);
}



- (RACSignal *)songTitleSignal
{
    return [self.currentItemSignal map:^id(MSPMediaItem *value) {
        return value.title;
    }];
}

- (RACSignal *)albumTitleSignal
{
    return [self.currentItemSignal map:^id(MSPMediaItem *value) {
        return value.albumTitle;
    }];
}

- (RACSignal *)artistNameSignal
{
    return [self.currentItemSignal map:^id(MSPMediaItem *value) {
        return value.artistName;
    }];
}


- (RACSignal *)thumbnailImageSignal
{
    return [self.currentItemSignal flattenMap:^RACStream *(MSPMediaItem *mediaItem) {
        return [self.commonSignals imageDownloadedSignal: [NSURL URLWithString:mediaItem.urlToThumbnail]];
    }];
        
}

- (RACSignal *) nextButtonEnabledSignal
{
    return [RACSignal combineLatest:@[RACObserve(self.mediaQueue, queueSize), RACObserve(self.mediaQueue, queuePosition)]
                             reduce:^id(NSNumber *queueSize, NSNumber *queuePosition){
        return [NSNumber numberWithBool:[queuePosition integerValue] < ([queueSize integerValue] - 1)];
    }];
}

- (RACSignal *) previousButtonEnabledSignal
{
    return RACObserve(self.mediaQueue, queuePosition);
}

- (RACSignal *) genreListSignal
{
    return RACObserve(self.genreList, genres);
}

#pragma mark - Action Hooks

- (RACCommand *) nextTrackCommand
{
    return [[RACCommand alloc]
            initWithEnabled: self.nextButtonEnabledSignal
            signalBlock:^RACSignal *(id input)
            {
                [self.playerController addMediaItemToQueue:[self.mediaQueue getNextItem] andPlay:YES];
                
                return [RACSignal empty];
            }];
}

- (RACCommand *) previousTrackCommand
{
    RACCommand *cmd = [[RACCommand alloc]
           initWithEnabled: self.previousButtonEnabledSignal
           signalBlock:^RACSignal *(id input)
            {
                [self.playerController addMediaItemToQueue:[self.mediaQueue getPreviousItem] andPlay:YES];
                
                return [RACSignal empty];
            }];
    
    
    return cmd;
}

-(RACSignal *)playButtonEnabledSignal
{
    return RACObserve(self.mediaQueue, queueSize);        
}

- (RACCommand *)togglePlaybackCommand
{
    return [[RACCommand alloc]
            initWithEnabled:self.playButtonEnabledSignal
            signalBlock:^RACSignal *(id input) {
                
                [self.playerController togglePlayback];
                
                return [RACSignal empty];
            }];
}

-(void)changeToGenreId:(NSNumber *)genreId
{
    [self.mediaQueue changeToGenreId:genreId];
    
    [self.playerController addMediaItemToQueue:[self.mediaQueue getCurrentItem] andPlay:YES];
    
    self.currentGenre = genreId;
}

#pragma mark - public methods
-(MSPMediaItemViewModel *)mediaItemAtIndexPath:(NSIndexPath *)indexPath
{
    return [MSPMediaItemViewModel viewModelWithMediaItem:[self.mediaQueue.mediaItems mediaItemAtChartPosition:[NSNumber numberWithUnsignedInteger:indexPath.item]]];
}

-(NSInteger)numberOfItems
{
    return self.mediaQueue.queueSize;
}

- (void)setCurrentTrack:(NSInteger)queueIndex
{
    [self.mediaQueue setItemAtPosition:queueIndex];
    
    [self.playerController addMediaItemToQueue:[self.mediaQueue getCurrentItem] andPlay:YES];
}

@end
