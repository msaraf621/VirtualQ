//
//  UIFont+VQ.h
//  VirtualQ
//
//  Created by GrepRuby on 05/07/14.
//  Copyright (c) 2014 optimalconsulting. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIFont (VQ)

//General Fonts
+(UIFont*)vqHelveticaNeueFont:(CGFloat)pointSize;
+(UIFont*)vqHelveticaNeueMediumFont:(CGFloat)pointSize;

//Opening Screen Fonts
+(UIFont*)vqOpeningScreenTitleFont;
+(UIFont*)vqOpenLineBubbleFont;
+(UIFont*)vqAnyFont;
+(UIFont*)vqWaitFont;

//Open Queue
+(UIFont*)vqTextFieldFont;
+(UIFont*)vqOpenAndManageLineFont;
+(UIFont*)vqCurrentLocationLabelFont;
+(UIFont*)vqLineUpUserLabelFont;

//Manage Queue
+(UIFont*)vqWaitingUserLableFont;
+(UIFont*)vqCounterLabelFont;
+(UIFont*)vqCounterStatusLabelFont;

//LookForQueue
+(UIFont*)vqQueueNameFont;
+(UIFont*)vqLookForQueueAddressFont;
+(UIFont*)vqLookForQueueDistanceFont;
+(UIFont*)vqLookForQueueWaitingUserFont;
+(UIFont*)vqJoinButtonFont;

//Current Position
+(UIFont*)vqCurrentPositionOfUserFont;
+(UIFont*)vqYourPositionFont;
+(UIFont*)vqQuestionLabelFont;
+(UIFont*)vqShortDescriptionLabelFont;
+(UIFont*)vqNumberOfPersonLabelFont;

//Quit Queue and Quit Line Fonts
+(UIFont*)vqYesAndNoButtonFont;
+(UIFont*)vqRestarantNameFont;
+(UIFont*)vqAddressFont;
+(UIFont*)vqQuitLineOrQueueFont;

//Push Notification Screen
+(UIFont*)vqYourPositionStringFont;
+(UIFont*)vqUserNameStringFont;
+(UIFont*)vqExplanationLabelFont;
+(UIFont*)vqCurPosPushNotificationFont;
+(UIFont*)vqYouAreStringFont;
+(UIFont*)vqUpStringFont;

//Thank you Screen
+(UIFont*)vqThankYouTextFont;

//Join Queue
+(UIFont*)vqShortDescInJoinQueueFont;
@end
