//
//  MSPSwipeTransitionTarget.h
//  myspacePlayer
//
//  Created by Andrew Beaupre on 10/15/13.
//  Copyright (c) 2013 Andrew Beaupre. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol MSPSwipeTransitionHandler <NSObject>
@required

-(void)userDidPan:(UIScreenEdgePanGestureRecognizer *)gestureRecognizer;

-(id)initWithParent:(UIViewController *)parent andTarget:(UIViewController *)target;

typedef NS_ENUM(NSInteger, MSPTransitionSpeed){
    MSPTransitionSpeedVeryFast = 20,
    MSPTransitionSpeedFast = 30,
    MSPTransitionSpeedMedium = 50,
    MSPTransitionSpeedSlow = 75,
    MSPTransitionSpeedVerySLow = 100
};

@end
