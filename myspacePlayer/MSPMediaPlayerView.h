//
//  MSPMediaPlayerViewController.h
//  myspacePlayer
//
//  Created by Andrew Beaupre on 10/3/13.
//  Copyright (c) 2013 Andrew Beaupre. All rights reserved.
//

#import <UIKit/UIKit.h>


@class MSPMediaPlayerViewModel;

@interface MSPMediaPlayerView : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *songTitle;
@property (weak, nonatomic) IBOutlet UILabel *albumTitle;
@property (weak, nonatomic) IBOutlet UILabel *artistName;
@property (weak, nonatomic) IBOutlet UILabel *playerStatus;
@property (weak, nonatomic) IBOutlet UIImageView *songImageView;
@property (weak, nonatomic) IBOutlet UIImageView *songImageViewBackground;
@property (weak, nonatomic) IBOutlet UIButton *playButton;
@property (weak, nonatomic) IBOutlet UIButton *previousButton;
@property (weak, nonatomic) IBOutlet UIButton *nextButton;
@property (weak, nonatomic) IBOutlet UIPickerView *genrePicker;


- (IBAction)playButtonTouchUpInside:(id)sender;


@end
