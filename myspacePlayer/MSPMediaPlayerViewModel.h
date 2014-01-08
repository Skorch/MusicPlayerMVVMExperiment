//
//  MSPMediaPlayerViewModel.h
//  myspacePlayer
//
//  Created by Andrew Beaupre on 10/8/13.
//  Copyright (c) 2013 Andrew Beaupre. All rights reserved.
//

#import <Foundation/Foundation.h>

@class RACSignal;
@class RACCommand;
@class MSPMediaItemViewModel;
@class MSPPlayerController;
@class MSPMediaQueue;

@interface MSPMediaPlayerViewModel : NSObject

@property (nonatomic, strong, readonly) RACSignal *songTitleSignal;
@property (nonatomic, strong, readonly) RACSignal *albumTitleSignal;
@property (nonatomic, strong, readonly) RACSignal *artistNameSignal;
@property (nonatomic, strong, readonly) RACSignal *thumbnailImageSignal;
@property (nonatomic, strong, readonly) RACSignal *previousButtonEnabledSignal;
@property (nonatomic, strong, readonly) RACSignal *nextButtonEnabledSignal;
@property (nonatomic, strong, readonly) RACSignal *currentItemSignal;
@property (nonatomic, strong, readonly) RACSignal *currentGenreSignal;
@property (nonatomic, strong, readonly) RACSignal *genreListSignal;

@property (nonatomic, strong, readonly) RACSignal *isPlayingSignal;
@property (nonatomic, strong, readonly) RACSignal *playerStatusSignal;

@property (nonatomic, strong, readonly) RACSignal *playButtonEnabledSignal;

@property (nonatomic, strong, readonly) RACCommand * nextTrackCommand;
@property (nonatomic, strong, readonly) RACCommand * previousTrackCommand;
@property (nonatomic, strong, readonly) RACCommand * togglePlaybackCommand;

- (void)setCurrentTrack:(NSInteger)queueIndex;

-(MSPMediaItemViewModel *)mediaItemAtIndexPath:(NSIndexPath *)indexPath;

- (void)changeToGenreId: (NSNumber *)genreId;

-(NSInteger)numberOfItems;


@end
