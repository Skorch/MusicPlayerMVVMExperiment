//
//  MSPQueueTransition.h
//  myspacePlayer
//
//  Created by Andrew Beaupre on 10/11/13.
//  Copyright (c) 2013 Andrew Beaupre. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MSPQueueView.h"
#import "MSPSwipeTransitionHandler.h"


@interface MSPQueueTransition : UIPercentDrivenInteractiveTransition<UIViewControllerTransitioningDelegate, MSPSwipeTransitionHandler>


//-(id)initWithParentViewController:(UIViewController *)viewController;
-(void)userDidPan:(UIScreenEdgePanGestureRecognizer *)recognizer;



@end
