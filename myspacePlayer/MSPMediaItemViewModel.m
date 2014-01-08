//
//  MSPMediaItemViewModel.m
//  myspacePlayer
//
//  Created by Andrew Beaupre on 10/15/13.
//  Copyright (c) 2013 Andrew Beaupre. All rights reserved.
//

#import <ReactiveCocoa.h>
#import "MSPMediaItemViewModel.h"
#import "MSPMediaQueue.h"
#import "MSPMediaItem.h"
#import "MSPViewModelCommonSignals.h"

@interface MSPMediaItemViewModel ()

@property (nonatomic, strong, readwrite) MSPMediaItem *mediaItem;
@property (nonatomic, strong) UIImage *thumbnailImage;

@property (nonatomic, strong, readwrite) RACSignal *songTitleSignal;

@property (nonatomic, strong) MSPViewModelCommonSignals* commonSignals;

@end

@implementation MSPMediaItemViewModel


#pragma mark - init

+(MSPMediaItemViewModel *) viewModelWithMediaItem:(MSPMediaItem *)mediaItem
{
    return [[MSPMediaItemViewModel alloc] initWithMediaItem:mediaItem];
    
}

-(id) initWithMediaItem:(MSPMediaItem *)mediaItem;
{
    self = [super init];
    if (self) {
        
        _commonSignals = [[MSPViewModelCommonSignals alloc]init];

        self.mediaItem = mediaItem;

        
        //self.thumbnailImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:mediaItem.urlToThumbnail]]];
    }
    return self;
}

#pragma mark - Mapping Signals

- (RACSignal *)songTitleSignal
{
    return [RACObserve(self, mediaItem) map:^id(MSPMediaItem *value) {
        return value.title;
    }];
}

- (RACSignal *)albumTitleSignal
{
    return [RACObserve(self, mediaItem) map:^id(MSPMediaItem *value) {
        return value.albumTitle;
    }];
}

- (RACSignal *)artistNameSignal
{
    return [RACObserve(self, mediaItem) map:^id(MSPMediaItem *value) {
        return value.artistName;
    }];
}

- (RACSignal *)thumbnailImageSignal
{
    return [RACObserve(self, mediaItem) flattenMap:^RACStream *(MSPMediaItem *mediaItem) {
        return [self.commonSignals imageDownloadedSignal: [NSURL URLWithString:mediaItem.urlToThumbnail]];
    }];
    
}

@end
