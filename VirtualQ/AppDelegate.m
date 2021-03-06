//
//  AppDelegate.m
//  VirtualQ
//
//  Created by GrepRuby on 03/07/14.
//  Copyright (c) 2014 optimalconsulting. All rights reserved.
//

#import "AppDelegate.h"
#import "BaseController.h"
#import "AppApi.h"

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
  
//  [FBLoginView class];

#ifdef INTEGRATION_TESTING
#else
  // Set up core data (MagicalRecord)
 
  [MagicalRecord setupCoreDataStackWithStoreNamed:@"VirtualQ"];
  #endif
  
#if DEBUG
#endif
    
    NSLog(@"%s", __PRETTY_FUNCTION__);
  
  //  For push Notification- Registration
  //  [[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert)];
    
  
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
  
  NSLog(@"applicationWillResignActive");
  // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
  // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
   NSLog(@"applicationDidEnterBackground");
  // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
  // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
   NSLog(@"applicationWillEnterForeground");
  // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
   NSLog(@"applicationDidBecomeActive");
  // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
  // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
  [MagicalRecord cleanUp];
  [self deleteFilesInLibraryDirectory];
  [MagicalRecord setupCoreDataStackWithStoreNamed:@"VirtualQ"];
}

#pragma mark-Push Notification

#ifdef __IPHONE_8_0
- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings
{
    //register to receive notifications
    [application registerForRemoteNotifications];
}

- (void)application:(UIApplication *)application handleActionWithIdentifier:(NSString *)identifier forRemoteNotification:(NSDictionary *)userInfo completionHandler:(void(^)())completionHandler
{
    //handle the actions
    if ([identifier isEqualToString:@"declineAction"]){
    }
    else if ([identifier isEqualToString:@"answerAction"]){
    }
}
#endif

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken{
  
  NSLog(@"device token is: %@",deviceToken);
    
  self.api=[AppApi sharedClient];

  [self.api sendDeviceTokenToServer:@{@"token":[[NSUserDefaults standardUserDefaults] objectForKey:@"token"], @"apn_token": deviceToken} success:^(AFHTTPRequestOperation *task, id responseObject) {
    
  } failure:^(AFHTTPRequestOperation *task, NSError *error) {
    
  }];
 // [server sendToken:deviceToken];
}

-(void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo{
  NSLog(@"received notification");
  //handle the notification here
}

-(void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error{
    
    NSLog(@"%s /n error : %@", __PRETTY_FUNCTION__, error);
}

- (void)deleteFilesInLibraryDirectory
{
  NSString* folderPath = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) objectAtIndex:0];
  NSError *error = nil;
  for (NSString *file in [[NSFileManager defaultManager] contentsOfDirectoryAtPath:folderPath error:&error])
  {
    [[NSFileManager defaultManager] removeItemAtPath:[folderPath stringByAppendingPathComponent:file] error:&error];
    if(error)
    {
      NSLog(@"Delete error: %@", error.description);
    }
  }
}



@end
