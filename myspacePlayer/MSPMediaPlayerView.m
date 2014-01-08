//
//  MSPMediaPlayerViewController.m
//  myspacePlayer
//
//  Created by Andrew Beaupre on 10/3/13.
//  Copyright (c) 2013 Andrew Beaupre. All rights reserved.
//

#import "MSPMediaPlayerView.h"
#import "MSPMediaPlayerViewModel.h"
#import "MSPQueueView.h"
#import "MSPQueueTransition.h"
#import <ReactiveCocoa.h>

@interface MSPMediaPlayerView ()<UIPickerViewDataSource, UIPickerViewDelegate>

@property (nonatomic, strong) MSPQueueTransition *queueTransition;
@property (nonatomic, strong) MSPQueueView *queueView;
@property (nonatomic, strong) NSArray *genreNames;
@property (nonatomic, strong) NSArray *genreIds;
@property (nonatomic, strong) MSPMediaPlayerViewModel *viewModel;

@end

@implementation MSPMediaPlayerView

#pragma mark - Lifecycle, init, dealloc


- (void)viewDidLoad
{
    [super viewDidLoad];

    MSPQueueView *qView = [[MSPQueueView alloc] init];
    

    self.queueTransition = [[MSPQueueTransition alloc] initWithParent:self andTarget:qView];

    qView.panTarget = self.queueTransition;

    _viewModel = [[MSPMediaPlayerViewModel alloc] init];
                  
    
    qView.viewModel = self.viewModel;

    self.queueView = qView;
    
    UIScreenEdgePanGestureRecognizer *screenEdgeGestureRecognizer = [[UIScreenEdgePanGestureRecognizer alloc]
                                                                     initWithTarget:self.queueTransition
                                                                     action:@selector(userDidPan:)];
    
    UISwipeGestureRecognizer *swipeRightGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(nextTrack)];
    swipeRightGestureRecognizer.direction = UISwipeGestureRecognizerDirectionRight;

    UISwipeGestureRecognizer *swipeLeftGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(previousTrack)];
    swipeRightGestureRecognizer.direction = UISwipeGestureRecognizerDirectionLeft;

    screenEdgeGestureRecognizer.edges = UIRectEdgeLeft;
    
    [self.view addGestureRecognizer:screenEdgeGestureRecognizer];
    [self.view addGestureRecognizer:swipeRightGestureRecognizer];
    [self.view addGestureRecognizer:swipeLeftGestureRecognizer];
    
    
    //Set up bindings
    
    RAC(self, songTitle.text, @"") = self.viewModel.songTitleSignal;
    
    RAC(self, albumTitle.text, @"") = self.viewModel.albumTitleSignal;
    
    RAC(self, artistName.text, @"") = self.viewModel.artistNameSignal;
 
    RAC(self, songImageView.image, nil) = self.viewModel.thumbnailImageSignal;

    RAC(self, songImageViewBackground.image, nil) = self.viewModel.thumbnailImageSignal;
    
    RAC(self, playerStatus.text, @"init") = self.viewModel.playerStatusSignal;
    
    RAC(self, playButton.selected, NO) = self.viewModel.isPlayingSignal;
    
    self.nextButton.rac_command = self.viewModel.nextTrackCommand;    
    
    self.previousButton.rac_command = self.viewModel.previousTrackCommand;
    
    //@weakify(self);
    
    _genreIds = [NSArray arrayWithObjects:@0, @7, @20, @17, @24, @4, @3, nil];
    _genreNames = [NSArray arrayWithObjects:@"All", @"Electronic", @"Alternative", @"Dance", @"Reggae", @"Childrens", @"Comedy", nil];
    
    self.genrePicker.dataSource = self;
    self.genrePicker.delegate = self;
    
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    // Turn on remote control event delivery
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    
    // Set itself as the first responder
    [self becomeFirstResponder];

}

-(void)viewWillDisappear:(BOOL)animated
{
    
    // Turn off remote control event delivery
    [[UIApplication sharedApplication] endReceivingRemoteControlEvents];
    
    // Resign as first responder
    [self resignFirstResponder];
    
    
    [super viewWillDisappear:animated];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Actions


- (IBAction)playButtonTouchUpInside:(id)sender {
    //play the first track

    [self togglePlayback];
}

- (void)nextTrack
{
    [self.viewModel.nextTrackCommand execute:nil];
    
}

- (void)previousTrack
{
    [self.viewModel.previousTrackCommand execute:nil];
}


- (void)togglePlayback
{
    [self.viewModel.togglePlaybackCommand execute:nil];
}


#pragma mark - RemoteControl Notifications

-(BOOL)canBecomeFirstResponder
{
    return YES;
}
- (void) remoteControlReceivedWithEvent: (UIEvent *) event
{
    switch (event.subtype) {
        case UIEventSubtypeRemoteControlPlay:
            [self togglePlayback];
            break;
        case UIEventSubtypeRemoteControlPause:
            [self togglePlayback];
            break;
        case UIEventSubtypeRemoteControlPreviousTrack:
            [self previousTrack];
            break;
        case UIEventSubtypeRemoteControlNextTrack:
            [self nextTrack];
            break;
        case UIEventSubtypeRemoteControlTogglePlayPause:
            [self togglePlayback];
            break;
        default:
            break;
    }
}



#pragma mark - UIPickerView Data Source
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return self.genreNames.count;
}


#pragma mark - UIPickerView Delegate

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [self.genreNames objectAtIndex:row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row   inComponent:(NSInteger)component
{
    [self.viewModel changeToGenreId:[self.genreIds objectAtIndex:row]];
}

@end
