//
//  MSPlaylistListCell.h
//  myspacePlayer
//
//  Created by Andrew Beaupre on 11/6/13.
//  Copyright (c) 2013 Andrew Beaupre. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MSPlaylistListViewModel;

@interface MSPlaylistListCellView : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *coverImageView;
@property (weak, nonatomic) IBOutlet UILabel *playlistTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *ownerNameLabel;

-(void) initializeWithViewModel:(MSPlaylistListViewModel *)viewModel;

@end
