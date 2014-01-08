//
//  MSPlaylistListViewModel.h
//  myspacePlayer
//
//  Created by Andrew Beaupre on 11/6/13.
//  Copyright (c) 2013 Andrew Beaupre. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ReactiveCocoa/ReactiveCocoa.h>

@interface MSPlaylistListViewModel : NSObject

@property (nonatomic, strong, readonly) RACSignal *playlistTitleSignal;
@property (nonatomic, strong, readonly) RACSignal *ownerNameSignal;
@property (nonatomic, strong, readonly) RACSignal *thumbnailImageSignal;

@end
