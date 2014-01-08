//
//  MSPQueueViewController.h
//  myspacePlayer
//
//  Created by Andrew Beaupre on 10/11/13.
//  Copyright (c) 2013 Andrew Beaupre. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MSPSwipeTransitionHandler.h"

@class MSPMediaPlayerViewModel;

// This protocol is only to silence the compiler since we're using one of two different classes.

@interface MSPQueueView : UIViewController

@property (weak, nonatomic) IBOutlet UIButton *closeButton;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) MSPMediaPlayerViewModel *viewModel;
@property (nonatomic, readwrite) id<MSPSwipeTransitionHandler> panTarget;
@property (weak, nonatomic) IBOutlet UIView *blurView;

- (IBAction)closeButtonTouchUpInside:(id)sender;

-(id)initWithPanTarget:(id<MSPSwipeTransitionHandler>)panTarget;

@end
