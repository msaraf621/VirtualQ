//
//  UIFont+VQ.m
//  VirtualQ
//
//  Created by GrepRuby on 05/07/14.
//  Copyright (c) 2014 optimalconsulting. All rights reserved.
//

#import "UIFont+VQ.h"

@implementation UIFont (VQ)

// General fonts

+(UIFont*)vqHelveticaNeueFont:(CGFloat)pointSize{
  return [UIFont fontWithName:@"HelveticaNeue" size:pointSize];
}

+(UIFont*)vqHelveticaNeueMediumFont:(CGFloat)pointSize{
  return  [UIFont fontWithName:@"HelveticaNeue-Medium" size:pointSize];
}

//Opening Screen Fonts

+(UIFont*)vqOpeningScreenTitleFont{
  return  [UIFont fontWithName:@"HelveticaNeue-Light" size:UNI_VAL(28.0,18.0)];
}

+(UIFont*)vqOpenLineBubbleFont{
  return  [UIFont fontWithName:@"HelveticaNeue-Medium" size:UNI_VAL(25.0, 19.0)];
}

+(UIFont*)vqAnyFont{
  return  [UIFont fontWithName:@"HelveticaNeue-Light" size:UNI_VAL(26.0, 15.0)];
}

+(UIFont*)vqWaitFont{
  return  [UIFont fontWithName:@"HelveticaNeue-Medium" size:UNI_VAL(26.0, 15.0)];
}

//Open Queue

+(UIFont*)vqTextFieldFont{
  return  [UIFont fontWithName:@"HelveticaNeue-Medium" size:15.0];
}

+(UIFont*)vqOpenAndManageLineFont{
  return  [UIFont fontWithName:@"HelveticaNeueLTStd-Roman" size:UNI_VAL(28.0, 18.0)];
}

+(UIFont*)vqCurrentLocationLabelFont{
  return  [UIFont fontWithName:@"HelveticaNeue-Light" size:UNI_VAL(20.0, 15.0)];
}

+(UIFont*)vqLineUpUserLabelFont{
  return  [UIFont fontWithName:@"HelveticaNeue-Light" size:UNI_VAL(20.0, 15.0)];
}

//Manage Queue

+(UIFont*)vqWaitingUserLableFont{
  return  [UIFont fontWithName:@"HelveticaNeue-Light" size:UNI_VAL(22, 17)];
}

+(UIFont*)vqCounterLabelFont{
  return  [UIFont fontWithName:@"HelveticaNeue" size:UNI_VAL(20, 17)];
}

+(UIFont*)vqCounterStatusLabelFont{
  return  [UIFont fontWithName:@"HelveticaNeue" size:UNI_VAL(25, 21)];
}


//LookForQueue

+(UIFont*)vqQueueNameFont{
  return  [UIFont fontWithName:@"HelveticaNeue-Light" size:UNI_VAL(20, 16.0)];
}

+(UIFont*)vqLookForQueueAddressFont{
  return  [UIFont fontWithName:@"HelveticaNeue-Light" size:UNI_VAL(18, 14.0)];
}

+(UIFont*)vqLookForQueueDistanceFont{
  return  [UIFont fontWithName:@"HelveticaNeueLTStd-Roman" size:UNI_VAL(18, 14.0)];
}

+(UIFont*)vqLookForQueueWaitingUserFont{
  return  [UIFont fontWithName:@"HelveticaNeueLTStd-Roman" size:UNI_VAL(28, 22.0)];
}

+(UIFont*)vqJoinButtonFont{
  return  [UIFont fontWithName:@"HelveticaNeueLTStd-Roman" size:UNI_VAL(20, 18)];
}


//Current Position
+(UIFont*)vqCurrentPositionOfUserFont{
  return  [UIFont fontWithName:@"HelveticaNeueLTStd-Roman" size:UNI_VAL(65, 55)];
}

+(UIFont*)vqYourPositionFont{
  return  [UIFont fontWithName:@"HelveticaNeue-Light" size:UNI_VAL(13, 11)];
}

+(UIFont*)vqQuestionLabelFont{
  return  [UIFont fontWithName:@"HelveticaNeue" size:UNI_VAL(20, 14)];
}

+(UIFont*)vqShortDescriptionLabelFont{
  return  [UIFont fontWithName:@"HelveticaNeue" size:UNI_VAL(20, 16)];
}

+(UIFont*)vqNumberOfPersonLabelFont{
  return  [UIFont fontWithName:@"HelveticaNeue" size:UNI_VAL(22, 17)];
}

//Quit Queue and Quit Line Fonts

+(UIFont*)vqYesAndNoButtonFont{
  return  [UIFont fontWithName:@"HelveticaNeue-Medium" size:UNI_VAL(22, 18)];
}

+(UIFont*)vqRestarantNameFont{
  return  [UIFont fontWithName:@"HelveticaNeue-Light" size:UNI_VAL(22, 18)];
}

+(UIFont*)vqAddressFont{
  return  [UIFont fontWithName:@"HelveticaNeue-Light" size:UNI_VAL(18, 14)];
}

+(UIFont*)vqQuitLineOrQueueFont{
  return  [UIFont fontWithName:@"HelveticaNeue" size:UNI_VAL(20, 14)];
}

//Push Notification Screen

+(UIFont*)vqYourPositionStringFont{
  return  [UIFont fontWithName:@"HelveticaNeue-Light" size:UNI_VAL(20, 12)];
}

+(UIFont*)vqUserNameStringFont{
  return  [UIFont fontWithName:@"HelveticaNeue-Light" size:UNI_VAL(36, 30)];
}

+(UIFont*)vqExplanationLabelFont{
  return  [UIFont fontWithName:@"HelveticaNeue-Light" size:UNI_VAL(22, 14)];
}

+(UIFont*)vqCurPosPushNotificationFont{
  return  [UIFont fontWithName:@"HelveticaNeueLTStd-Roman" size:UNI_VAL(70, 90)];
}

+(UIFont*)vqYouAreStringFont{
  return  [UIFont fontWithName:@"HelveticaNeueLTStd-Roman" size:UNI_VAL(30, 20)];
}

+(UIFont*)vqUpStringFont{
  return  [UIFont fontWithName:@"HelveticaNeueLTStd-Roman" size:UNI_VAL(70, 60)];
}

//Thank you Screen
+(UIFont*)vqThankYouTextFont{
  return  [UIFont fontWithName:@"HelveticaNeueLTStd-Roman" size:UNI_VAL(18, 14)];
}

//Join Queue
+(UIFont*)vqShortDescInJoinQueueFont{
  return  [UIFont fontWithName:@"HelveticaNeueLTStd-Roman" size:UNI_VAL(18, 14)];
}


@end
