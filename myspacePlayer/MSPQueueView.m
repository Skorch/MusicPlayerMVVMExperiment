//
//  MSPQueueViewController.m
//  myspacePlayer
//
//  Created by Andrew Beaupre on 10/11/13.
//  Copyright (c) 2013 Andrew Beaupre. All rights reserved.
//

#import "MSPQueueView.h"
#import "MSPQueueTransition.h"
#import "MSPMediaPlayerViewModel.h"
#import "MSPMediaItemViewModel.h"
#import "MSPMediaItemViewCell.h"
#import <ReactiveCocoa.h>
#import <ReactiveCocoa/RACEXTScope.h>

@interface MSPQueueView ()

@end

@implementation MSPQueueView

-(id)initWithPanTarget:(id<MSPSwipeTransitionHandler>)panTarget;
{
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        _panTarget = panTarget;
    }
    return self;

}

-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"MSPMediaItemViewCell" bundle:nil] forCellWithReuseIdentifier:@"MSPMediaItemViewCell"];
    
    
    UIScreenEdgePanGestureRecognizer *screenEdgeGestureRecognizer = [[UIScreenEdgePanGestureRecognizer alloc]
                                                                     initWithTarget:_panTarget
                                                                     action:@selector(userDidPan:)];
    screenEdgeGestureRecognizer.edges = UIRectEdgeRight;
    
    [self.view addGestureRecognizer:screenEdgeGestureRecognizer];
    
    //on current queue change, reset the collection view
    @weakify(self);
    [self.viewModel.currentGenreSignal subscribeNext:^(id x) {
        @strongify(self);
        [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
        [self.collectionView reloadData];
    }];
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)closeButtonTouchUpInside:(id)sender {
    [self dismissView];
}

- (void)dismissView{

    id<UIViewControllerTransitioningDelegate> queueTransition = [[MSPQueueTransition alloc]init];
    
    self.transitioningDelegate = queueTransition;
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.viewModel.numberOfItems;
}

- (MSPMediaItemViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    MSPMediaItemViewCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:@"MSPMediaItemViewCell" forIndexPath:indexPath];
    
    MSPMediaItemViewModel *itemViewModel = [self.viewModel mediaItemAtIndexPath:indexPath];

    [cell bindWithMediaItemViewModel:itemViewModel];
    
    return cell;
    
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"Cell item %i was selected.", indexPath.item);

    [self.viewModel setCurrentTrack:indexPath.item];
    
    [self dismissView];
    
}
@end
