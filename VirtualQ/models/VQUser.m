//
//  VQUser.m
//  VirtualQ
//
//  Created by GrepRuby on 07/08/14.
//  Copyright (c) 2014 optimalconsulting. All rights reserved.
//

#import "VQUser.h"


@implementation VQUser

@dynamic token;
@dynamic isCurrentUser;

+(VQUser*)currentUser {
  VQUser *user= [VQUser findFirstByAttribute:@"isCurrentUser" withValue:[NSNumber numberWithBool:YES]];
  return user;
}

+(void)setCurrentUser:(VQUser*)newUser {
  
  //get the current user (if there is one), so we can unset isCurrentUser
  VQUser *currentUser = [self currentUser];
  if(currentUser) {
    currentUser.isCurrentUser = [NSNumber numberWithBool:NO];
    //   [[NSNotificationCenter defaultCenter] postNotificationName:kDidChangeCurrentUserNotification object:nil];
  }
  
  //assign the new current user (unless nil was passed)
  if (newUser) {
    newUser.isCurrentUser = [NSNumber numberWithBool:YES];
  }
}

// Temp Changes End ------------------------------------------------
+(BOOL)isUserPresent {
  return ([self countOfEntities] > 0);
}

@end
