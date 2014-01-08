//
//  MSPQueueTransition.m
//  myspacePlayer
//
//  Created by Andrew Beaupre on 10/11/13.
//  Copyright (c) 2013 Andrew Beaupre. All rights reserved.
//

#import "MSPQueueTransition.h"



@interface MSPQueueTransition ()<UIViewControllerAnimatedTransitioning, UIViewControllerInteractiveTransitioning>

@property (nonatomic, weak) UIViewController *parentViewController;
@property (nonatomic, weak) UIViewController *targetViewController;
@property (nonatomic, strong) id<UIViewControllerContextTransitioning> transitionContext;
@property (nonatomic, assign, getter = isPresenting) BOOL presenting;
@property (nonatomic, assign, getter = isInteractive) BOOL interactive;

@end

@implementation MSPQueueTransition
{
}

@synthesize presenting;

#pragma mark - Init

-(id)initWithParent:(UIViewController *)parent andTarget:(UIViewController *)target
{
    self = [super init];
    if (self) {
        
        _parentViewController = parent;
        _targetViewController = target;
    }
    return self;
    
}

#pragma mark - GestureRecognizer Selector

-(void)userDidPan:(UIScreenEdgePanGestureRecognizer *)recognizer
{
    NSLog(@"%@", @"pan gesture");
    
    CGPoint location = [recognizer locationInView:self.parentViewController.view];
    CGPoint velocity = [recognizer velocityInView:self.parentViewController.view];
    
    if(recognizer.state == UIGestureRecognizerStateBegan)
    {

        self.interactive = YES;
        
        //the side of the screen determins if we
        if(location.x < CGRectGetMidX(recognizer.view.bounds))
        {
            if(!self.presenting)
            {
                self.presenting = YES;
                
                //MSPQueueView *viewController = [[MSPQueueView alloc]initWithPanTarget:self];
                self.targetViewController.modalPresentationStyle = UIModalPresentationCustom;
                self.targetViewController.transitioningDelegate = self;
                [self.parentViewController presentViewController:self.targetViewController animated:YES completion:nil];
            }

        }
        else{
            [self.parentViewController dismissViewControllerAnimated:YES completion:nil];
        }
        
        NSLog(@"UIGestureRecognizerStateBegan - presenting=%i", self.presenting);

    }
    else if(recognizer.state == UIGestureRecognizerStateChanged){
        //what is the ratio between left edge and right
        CGFloat ratio = location.x / CGRectGetWidth(recognizer.view.bounds);

        NSLog(@"UIGestureRecognizerStateChanged - %f", ratio);
        
        [self updateInteractiveTransition:ratio];
    }
    else if(recognizer.state == UIGestureRecognizerStateEnded)
    {
        NSLog(@"UIGestureRecognizerStateEnded");
        
        //if presenting, then the velocity should be positive
        if(self.presenting)
        {
            if(velocity.x > 0)
            {
                [self finishInteractiveTransition];
            }
            else{
                [self cancelInteractiveTransition];
            }
            
        }
        else{
            if(velocity.x < 0)
            {
                [self finishInteractiveTransition];
            }
            else{
                [self cancelInteractiveTransition];
            }
            
        }
    }
    else if(recognizer.state == UIGestureRecognizerStateCancelled)
    {
        NSLog(@"UIGestureRecognizerStateCancelled");

        [self cancelInteractiveTransition];

    }
    else{
        NSLog(@"Unknown gesture state %i", recognizer.state);
        
    }
}

#pragma mark - UIViewControllerInteractiveTransitioning Methods
- (void) startInteractiveTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    self.transitionContext = transitionContext;
    
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];

    
    CGRect endFrame = [[transitionContext containerView] bounds];
    
    if(self.presenting)
    {
        //load up the container view with the To/From Views so the animation can be performed
        [transitionContext.containerView addSubview:fromViewController.view];
        [transitionContext.containerView addSubview:toViewController.view];
        
        endFrame.origin.x -= CGRectGetWidth([[transitionContext containerView] bounds]);
    }
    else{
        //load up the container view with the To/From Views so the animation can be performed
        [transitionContext.containerView addSubview:toViewController.view];
        [transitionContext.containerView addSubview:fromViewController.view];
        
    }
    
    toViewController.view.frame = endFrame;
}

#pragma  mark - UIPercentDrivenInteractiveTransition Overridden Methods
-(void) updateInteractiveTransition:(CGFloat)percentComplete
{
    id<UIViewControllerContextTransitioning> transitionContext = self.transitionContext;
    
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];

    //Presenting goes from 0..1 and dismissing goes from 1..0
    CGRect frame = CGRectOffset(
                                [[transitionContext containerView] bounds],
                                -CGRectGetWidth([[transitionContext containerView] bounds]) * (1.0f - percentComplete),
                                0);
    if (self.presenting) {
        toViewController.view.frame = frame;
    }
    else{
        fromViewController.view.frame = frame;
    }
}

-(void)finishInteractiveTransition
{
    id<UIViewControllerContextTransitioning> transitionContext = self.transitionContext;
    
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    if (self.presenting)
    {
        CGRect endFrame = [[transitionContext containerView] bounds];
        
        [UIView animateWithDuration:(float)MSPTransitionSpeedVeryFast/100 animations:^{
            toViewController.view.frame = endFrame;
        } completion:^(BOOL finished) {
            [transitionContext completeTransition:YES];
        }];
    }
    else {
        CGRect endFrame = CGRectOffset([[transitionContext containerView] bounds], -CGRectGetWidth([[self.transitionContext containerView] bounds]), 0);
        
        [UIView animateWithDuration:(float)MSPTransitionSpeedVeryFast/100 animations:^{
            fromViewController.view.frame = endFrame;
        } completion:^(BOOL finished) {
            [transitionContext completeTransition:YES];
        }];
    }
}

- (void)cancelInteractiveTransition {
    id<UIViewControllerContextTransitioning> transitionContext = self.transitionContext;
    
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    if (self.presenting)
    {
        CGRect endFrame = CGRectOffset([[transitionContext containerView] bounds], -CGRectGetWidth([[transitionContext containerView] bounds]), 0);
        
        [UIView animateWithDuration:(float)MSPTransitionSpeedMedium/100 animations:^{
            toViewController.view.frame = endFrame;
        } completion:^(BOOL finished) {
            [transitionContext completeTransition:NO];
        }];
    }
    else {
        CGRect endFrame = [[transitionContext containerView] bounds];
        
        [UIView animateWithDuration:(float)MSPTransitionSpeedMedium/100 animations:^{
            fromViewController.view.frame = endFrame;
        } completion:^(BOOL finished) {
            [transitionContext completeTransition:NO];
        }];
        
        self.interactive = YES;
    }
}

#pragma mark - UIViewControllerTransitioningDelegate Protocal Implemetation
- (id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
    NSLog(@"animationControllerForPresentedController");
    return self;
}

- (id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    NSLog(@"animationControllerForDismissedController");
    return self;
}

- (id <UIViewControllerInteractiveTransitioning>)interactionControllerForPresentation:(id <UIViewControllerAnimatedTransitioning>)animator {
    NSLog(@"interactionControllerForPresentation - interactive: %i", self.interactive);
    // Return nil if we are not interactive
    if (self.interactive) {
        return self;
    }
    
    return nil;
}

- (id <UIViewControllerInteractiveTransitioning>)interactionControllerForDismissal:(id <UIViewControllerAnimatedTransitioning>)animator {

    NSLog(@"interactionControllerForDismissal - interactive: %i", self.interactive);
    // Return nil if we are not interactive
    if (self.interactive) {
        return self;
    }
    
    return nil;
}


#pragma mark - UIViewControllerAnimatedTransitioning Protocal Implementation

-(void) animationEnded:(BOOL)transitionCompleted
{
    self.interactive = YES;
    self.presenting = NO;
    self.transitionContext = nil;
}

- (NSTimeInterval) transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    return (float)MSPTransitionSpeedFast/100;
}

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext {
    if (self.interactive) {
        // nop as per documentation
    }
    else {
        // This code is lifted wholesale from the TLTransitionAnimator class
        UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
        UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
        
        CGRect endFrame = [[transitionContext containerView] bounds];
        //        endFrame.size.width -= 200;
        
        if (self.presenting) {
            // The order of these matters – determines the view hierarchy order.
            [transitionContext.containerView addSubview:fromViewController.view];
            [transitionContext.containerView addSubview:toViewController.view];
            
            CGRect startFrame = endFrame;
            startFrame.origin.x -= CGRectGetWidth([[transitionContext containerView] bounds]);
            
            toViewController.view.frame = startFrame;
            
            [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
                toViewController.view.frame = endFrame;
            } completion:^(BOOL finished) {
                [transitionContext completeTransition:YES];
            }];
        }
        else {
            [transitionContext.containerView addSubview:toViewController.view];
            [transitionContext.containerView addSubview:fromViewController.view];
            
            endFrame.origin.x -= CGRectGetWidth([[transitionContext containerView] bounds]);
            
            [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
                fromViewController.view.frame = endFrame;
            } completion:^(BOOL finished) {
                [transitionContext completeTransition:YES];
            }];
        }
    }
}

@end
