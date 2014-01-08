//
//  MSPMediaItemViewCell.m
//  myspacePlayer
//
//  Created by Andrew Beaupre on 10/16/13.
//  Copyright (c) 2013 Andrew Beaupre. All rights reserved.
//

#import "MSPMediaItemViewCell.h"
#import "MSPMediaItemViewModel.h"
#import <ReactiveCocoa.h>
#import <ReactiveCocoa/UICollectionViewCell+RACSignalSupport.h>
#import <ReactiveCocoa/RACEXTScope.h>

@interface MSPMediaItemViewCell ()

@property (nonatomic, strong) MSPMediaItemViewModel *viewModel;
@property (nonatomic, strong) RACCompoundDisposable *disposables;

@end

@implementation MSPMediaItemViewCell

- (id)init
{
    self = [super init];
    if (self) {
        _disposables = [RACCompoundDisposable compoundDisposable];
    }
    return self;
}

- (void)bindWithMediaItemViewModel: (MSPMediaItemViewModel *)aViewModel
{
    _viewModel = aViewModel;
    
    [self.rac_prepareForReuseSignal subscribeCompleted:^{
        NSLog(@"rac_prepareForReuseSignal");
    }];
    
    
    RAC(self.songTitle, text) = [[aViewModel.songTitleSignal map:^id(id value) {
        return value;
    }] takeUntil:self.rac_prepareForReuseSignal];
                                  
    RAC(self.artistName, text) = [[aViewModel.artistNameSignal map:^id(id value) {
        return value;
    }] takeUntil:self.rac_prepareForReuseSignal];
    RAC(self.imageView, image) = [[aViewModel.thumbnailImageSignal map:^id(id value) {
        return value;
    }] takeUntil:self.rac_prepareForReuseSignal];
    
}


@end
