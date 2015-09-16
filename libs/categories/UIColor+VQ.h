//
//  UIColor+VQ.h
//  VirtualQ
//
//  Created by GrepRuby on 05/07/14.
//  Copyright (c) 2014 optimalconsulting. All rights reserved.
//


#import <UIKit/UIKit.h>

@interface UIColor (VQ)

+(UIColor *) colorFromHex:(NSString *)hex;
+(UIColor *) colorFromHex:(NSString *)hex withAlpha:(float)alpha;


// Opening Screen - Common
+(UIColor*)vqBackgroundColor;
+(UIColor*)vqPulseBubbleColor;
+(UIColor*)vqAnyWaitButtonColor;
+(UIColor*)vqOpenLineBubbleColor;
+(UIColor*)vqOpenLineBubbleTextColor;

// Open Queue - Host Mode
+(UIColor*)vqPlaceholderTextColor;
+(UIColor*)vqTextField2Color;
+(UIColor*)vqQuitQueueButtonColor;

//Manage Queue - Host Mode
+(UIColor*)vqBubbleColor;
+(UIColor*)vqBubbleTextColor;
+(UIColor*)vqNoUserBubbleColor;
+(UIColor*)vqCounterViewColor;

//LookForQueue
+(UIColor*)vqJoinButtonColor;
+(UIColor*)vqTableViewTextColor;
+(UIColor*)vqTeaserStateColor;
+(UIColor*)vqTableViewCellBubbleColor;

// Join Queue With Counter - User Mode
+(UIColor*)vqCountIncreaseColor;
+(UIColor*)vqCountDecreaseColor;
+(UIColor*)vqCountWaitingUserColor;
+(UIColor*)vqPlusMinusColor;

//Quit Queue and Quit Line Colors 
+(UIColor*)vqYesAndNoButtonTitleColor;
+(UIColor*)vqYesBubbleColor;
+(UIColor*)vqNoBubbleColor;

// Current Position Screen
+(UIColor*)vqCurrentPositonBubbleColor;

// Push Notification Screen
+(UIColor*)vqPushNotificationTopViewColor;
+(UIColor*)vqPushNotificationBottomViewColor;
+(UIColor*)vqPushNotificationBottomViewAnimationColor;

// Thankyou Screen - Common
+(UIColor*)vqThankYouScreenBottomViewColor;
+(UIColor*)vqThankYouScreenTopViewColor;
+(UIColor*)vqfacebookIconColor;


@end