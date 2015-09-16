//
//  SlideRigthCustomSegue.h
//  VirtualQ
//
//  Created by GrepRuby on 22/07/14.
//  Copyright (c) 2014 optimalconsulting. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SlideRigthCustomSegue : UIStoryboardSegue

- (void)dismissPerformAnimated: (BOOL)flag;
- (void)presentPerformAnimated: (BOOL)flag;
- (void)presentWithDismissPerformAnimated: (BOOL)flag;


@end
