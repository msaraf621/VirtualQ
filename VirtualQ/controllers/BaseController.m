//
//  BaseController.m
//  VirtualQ
//
//  Created by GrepRuby on 03/07/14.
//  Copyright (c) 2014 optimalconsulting. All rights reserved.
//

#import "BaseController.h"

@implementation BaseController{
}

@synthesize api;

- (void)viewDidLoad
{
  [super viewDidLoad];
  [self defaultStyle];
  [self commonInit];
  // Do any additional setup after loading the view.
}

-(void)commonInit {
  self.api=[AppApi sharedClient];
  self.vqDefaults=[NSUserDefaults standardUserDefaults];
  
 }

-(void)defaultStyle {

  //Background Color
  [self.view setBackgroundColor:[UIColor vqBackgroundColor]];
}

-(void)refreshData{
  //stub method, do nothing by default
  }

-(void)reloadData{
  
}

-(BOOL)isFetchedDataEmpty{
  return  YES;
}

#pragma  mark - General Parameters

//Get Device Id
-(NSString*)getDeviceUDID{
  
  UIDevice *device = [UIDevice currentDevice];

 // if([[device name] hasSuffix: @"Simulator"]){
  //  return @"83F361D6-9A4B-45E2-B86B-E95580A24A5F"; 
 // }else{

//    NSLog(@"Device Id: %@",[[device identifierForVendor] UUIDString]);
    return [[device identifierForVendor] UUIDString];
  //}
  
}

//Get Token
-(NSString*)getToken{
 //return @"PpmNWnt4apxnR27sHqiq";

  return [self.vqDefaults objectForKey:@"token"];
}

-(NSNumber*)getLineId{
   return [self.vqDefaults objectForKey:@"lineId"];
}

//Get Current Location
-(CLLocation*)getCurrentLocation{
CLLocation *currentLocation=[[CLLocation alloc] initWithLatitude:[[self.vqDefaults objectForKey:@"latitude"] doubleValue] longitude:[[self.vqDefaults objectForKey:@"longitude"] doubleValue]];
// CLLocation *currentLocation=[[CLLocation alloc] initWithLatitude: 22.718698 longitude:75.855666];
  return currentLocation;
}

# pragma mark - NSAttributed Text for Restaurant Name and Address

-(NSAttributedString*)setAttributedText:(NSString*)restaurantName withAddress:(NSString*)address{
  
  NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc] init];
  
  NSAttributedString *restaurantNameStr = [[NSAttributedString alloc]initWithString:restaurantName attributes:@{NSFontAttributeName : [UIFont vqRestarantNameFont],NSForegroundColorAttributeName: [UIColor vqTableViewTextColor]}];
  
  [attributedStr appendAttributedString:restaurantNameStr];
  
  NSMutableString *addr=[NSMutableString stringWithFormat:@"\n%@",address];
  NSAttributedString *addressStr = [[NSAttributedString alloc]initWithString:addr attributes:@{NSFontAttributeName : [UIFont vqAddressFont],NSForegroundColorAttributeName: [UIColor vqTableViewTextColor]}];
  
  [attributedStr appendAttributedString:addressStr];
  
  return attributedStr;
}

#pragma mark- Waiting Name Label

-(NSAttributedString*)setAttributedTextForWaitingName:(NSString*)extraText withText:(NSString*)userName{
  
  NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc] init];
  
  NSAttributedString *str=[[NSAttributedString alloc] initWithString:LOCALIZATION(@"yourWaitingNameIs") attributes:@{NSFontAttributeName : [UIFont vqYourPositionStringFont],NSForegroundColorAttributeName: [UIColor blackColor]}];
  
  [attributedStr appendAttributedString:str];
  
  NSMutableString *userNameStr=[NSMutableString stringWithFormat:@"\n%@",userName];
  
  NSAttributedString *userNameAttributed = [[NSAttributedString alloc] initWithString:userNameStr attributes:@{NSFontAttributeName : [UIFont vqUserNameStringFont],NSForegroundColorAttributeName: [UIColor blackColor]}];
  
  [attributedStr appendAttributedString:userNameAttributed];
  
  return attributedStr;
}

# pragma mark- NSAttributed Text for Current Position

-(NSAttributedString*)setAttributedTextForCurrentPosition:(NSString*)currentPosition withText:(NSString*)positionText{
  
  NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc] init];
  
  NSAttributedString *currentPositionString=[[NSAttributedString alloc] initWithString:currentPosition attributes:@{NSFontAttributeName : [UIFont vqCurrentPositionOfUserFont],NSForegroundColorAttributeName: [UIColor vqTableViewTextColor]}];
  
  [attributedStr appendAttributedString:currentPositionString];
  
  NSMutableString *posText=[NSMutableString stringWithFormat:@"\n%@",LOCALIZATION(@"yourPosition")];
  
  NSAttributedString *posTextStr = [[NSAttributedString alloc] initWithString:posText attributes:@{NSFontAttributeName : [UIFont vqYourPositionFont],NSForegroundColorAttributeName: [UIColor vqTableViewTextColor]}];
  
  [attributedStr appendAttributedString:posTextStr];
  
  return attributedStr;
}


#pragma mark- AnyWait attributed Text

-(NSAttributedString*)setAttributedTextForAnyWait{
  
  NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc] init];
  
  NSAttributedString *anyStr = [[NSAttributedString alloc]initWithString:@"virtual" attributes:@{NSFontAttributeName : [UIFont vqAnyFont],NSForegroundColorAttributeName: [UIColor blackColor]}];
  
  [attributedStr appendAttributedString:anyStr];
  
  NSAttributedString *waitStr = [[NSAttributedString alloc]initWithString:@"Q" attributes:@{NSFontAttributeName : [UIFont vqWaitFont],NSForegroundColorAttributeName: [UIColor blackColor]}];
  
  [attributedStr appendAttributedString:waitStr];
  
  return attributedStr;
}

#pragma mark- You are Up!
-(NSAttributedString*)setAttributedTextYouAreUp{
  
  NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc] init];
  
  NSAttributedString *youAreStr = [[NSAttributedString alloc]initWithString:LOCALIZATION (@"youAre") attributes:@{NSFontAttributeName : [UIFont vqYouAreStringFont],NSForegroundColorAttributeName: [UIColor blackColor]}];
  
  [attributedStr appendAttributedString:youAreStr];
   NSMutableString *upText=[NSMutableString stringWithFormat:@"\n%@",LOCALIZATION(@"up")];
  
  NSAttributedString *upStr = [[NSAttributedString alloc]initWithString:upText attributes:@{NSFontAttributeName : [UIFont vqUpStringFont],NSForegroundColorAttributeName: [UIColor blackColor]}];
  
  [attributedStr appendAttributedString:upStr];
  
  return attributedStr;
}

#pragma mark- VirtualQ Home

-(NSAttributedString*)setAttributedVirtualQ{
  
  NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc] init];
  
  NSAttributedString *virtualStr = [[NSAttributedString alloc]initWithString:@"virtual" attributes:@{NSFontAttributeName : [UIFont vqAnyFont],NSForegroundColorAttributeName: [UIColor blackColor]}];
  
  [attributedStr appendAttributedString:virtualStr];
  
  NSAttributedString *QStr = [[NSAttributedString alloc]initWithString:@"Q" attributes:@{NSFontAttributeName : [UIFont vqWaitFont],NSForegroundColorAttributeName: [UIColor blackColor]}];
  
  [attributedStr appendAttributedString:QStr];
  
  NSAttributedString *homeStr = [[NSAttributedString alloc]initWithString:@" Home" attributes:@{NSFontAttributeName : [UIFont vqAnyFont],NSForegroundColorAttributeName: [UIColor blackColor]}];
  
  [attributedStr appendAttributedString:homeStr];
  
  return attributedStr;

}

#pragma mark - Notification methods

- (void) receiveLanguageChangedNotification:(NSNotification *) notification
{
  if ([notification.name isEqualToString:kNotificationLanguageChanged])
  {
    [self configureViewFromLocalisation];
  }

}

-(void)configureViewFromLocalisation
{
  
}



@end
