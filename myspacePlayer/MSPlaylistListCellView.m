//
//  MSPlaylistListCell.m
//  myspacePlayer
//
//  Created by Andrew Beaupre on 11/6/13.
//  Copyright (c) 2013 Andrew Beaupre. All rights reserved.
//

#import "MSPlaylistListCellView.h"
#import "MSPlaylistListViewModel.h"

@interface MSPlaylistListCellView ()

@property (nonatomic, weak) MSPlaylistListViewModel *playlistListViewModel;

@end

@implementation MSPlaylistListCellView

-(void)initializeWithViewModel:(MSPlaylistListViewModel *)viewModel
{
    RAC(self.playlistTitleLabel, text) = viewModel.playlistTitleSignal;
    
    RAC(self.ownerNameLabel, text) = viewModel.ownerNameSignal;
    
    RAC(self.coverImageView, image) = viewModel.thumbnailImageSignal;
}

@end
