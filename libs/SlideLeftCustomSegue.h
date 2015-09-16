 //
//  SlideLeftCustomSegue.h
//  VirtualQ
//
//  Created by GrepRuby on 15/07/14.
//  Copyright (c) 2014 optimalconsulting. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SlideLeftCustomSegue : UIStoryboardSegue
- (void)dismissPerformAnimated: (BOOL)flag;
- (void)presentPerformAnimated: (BOOL)flag;
- (void)presentWithDismissPerformAnimated: (BOOL)flag;
@end
