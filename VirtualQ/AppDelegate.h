//
//  AppDelegate.h
//  VirtualQ
//
//  Created by GrepRuby on 03/07/14.
//  Copyright (c) 2014 optimalconsulting. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
- (void)deleteFilesInLibraryDirectory;
@property (nonatomic,strong) AppApi *api;
@end
