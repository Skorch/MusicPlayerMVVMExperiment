//
//  MSPMediaItemViewCell.h
//  myspacePlayer
//
//  Created by Andrew Beaupre on 10/16/13.
//  Copyright (c) 2013 Andrew Beaupre. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MSPMediaItemViewModel;

@interface MSPMediaItemViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *songTitle;
@property (weak, nonatomic) IBOutlet UILabel *artistName;

- (void)bindWithMediaItemViewModel: (MSPMediaItemViewModel *)aViewModel;


@end
