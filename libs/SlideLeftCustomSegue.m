//
//  SlideLeftCustomSegue.m
//  VirtualQ
//
//  Created by GrepRuby on 15/07/14.
//  Copyright (c) 2014 optimalconsulting. All rights reserved.
//

#import "SlideLeftCustomSegue.h"

@implementation SlideLeftCustomSegue


- (void)perform{
  UIViewController *srcViewController = (UIViewController *) self.sourceViewController;
  CATransition *transition = [CATransition animation];
  transition.duration = 0.4;
  transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
  transition.type = kCATransitionPush;
  transition.subtype = kCATransitionFromRight;
  [srcViewController.view.window.layer addAnimation:transition forKey:nil];
}

- (void)dismissPerformAnimated: (BOOL)flag{
  if(flag){
    [self perform];
  }
  UIViewController *srcViewController = (UIViewController *) self.sourceViewController;
  [srcViewController dismissViewControllerAnimated:NO completion:nil];
}

- (void)presentPerformAnimated: (BOOL)flag{
  if(flag){
    [self perform];
  }
  UIViewController *srcViewController = (UIViewController *) self.sourceViewController;
  UIViewController *destViewController = (UIViewController *) self.destinationViewController;
  [srcViewController presentViewController:destViewController animated:NO completion:nil];
}

- (void)presentWithDismissPerformAnimated: (BOOL)flag{
  if(flag){
    [self perform];
  }
  UIViewController *srcViewController = (UIViewController *) self.sourceViewController;
  UIViewController *destViewController = (UIViewController *) self.destinationViewController;
  UIViewController *presentingViewController =(UIViewController *) srcViewController.presentingViewController;
  [srcViewController dismissViewControllerAnimated:NO completion:^{
    [presentingViewController presentViewController:destViewController animated:NO completion:nil];
  }];
  
}

@end
