//
//  QuitLineViewController.m
//  VirtualQ
//
//  Created by GrepRuby on 14/07/14.
//  Copyright (c) 2014 optimalconsulting. All rights reserved.
//

#import "QuitLineViewController.h"
#import "OpeningScreenViewController.h"
#import "JoinQueueViewController.h"
#import "JoinQueueWithCounterViewController.h"
#include "CurrentPositionViewController.h"
#import "PushUpNotificationViewController.h"
#import "SlideRigthCustomSegue.h"
#import "SlideLeftCustomSegue.h"
#import "ThankYouViewController.h"

@interface QuitLineViewController ()

@end

@implementation QuitLineViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

  [self applyDefaultStyles];
  [self initLocalization];
}

-(void)viewDidDisappear:(BOOL)animated{
  
  [[AFNetworkReachabilityManager sharedManager] stopMonitoring];

}
-(void)applyDefaultStyles{
  
  //Yes Button
  [self.yesButton setBackgroundColor:[UIColor vqYesBubbleColor]];
  self.yesButton.titleLabel.font=[UIFont vqYesAndNoButtonFont];
  [self.yesButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
  [self.yesButton setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
  [self.yesButton setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];

  
  //No Button
  [self.noButton setBackgroundColor:[UIColor vqNoBubbleColor]];
   self.noButton.titleLabel.font=[UIFont vqYesAndNoButtonFont];
  [self.noButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
  [self.noButton setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
  [self.noButton setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
  

  
  //Address & Name Label
  [self changeLabels];
  
  //Quit Line Label
  [self.quitLineLabel setText:@"Do you want to quit line?"];
  [self.quitLineLabel setFont:[UIFont vqQuitLineOrQueueFont]];

}

-(NSString*)getAddress:(NSString*)location{
    NSArray* addressArray = [location componentsSeparatedByString:@","];
    NSString *address = @"";
    if([addressArray count] > 0){
        if([addressArray count] > 1){
            address = [NSString stringWithFormat:@"%@, %@",[addressArray objectAtIndex:0],[addressArray objectAtIndex:1]];
        }else{
            address=[NSString stringWithFormat:@"%@",[addressArray objectAtIndex:0]];
        }
    }
    return address;
}


-(void)changeLabels{
  
  if(self.userInfoDictionary!=nil ){
  NSString *restaurantName=[NSString stringWithFormat:@"%@",[self.userInfoDictionary valueForKey:@"line_name"]];
  //NSString *address=[NSString stringWithFormat:@"%@",[self.userInfoDictionary valueForKey:@"location"]];
    [self.nameAndAddressLabel setAttributedText:[self setAttributedText:restaurantName withAddress:[self getAddress:[self.userInfoDictionary valueForKey:@"location"]]]];

  }
  else if(self.lineInfoDictionary!=nil ){
  
    NSString *restaurantName=[NSString stringWithFormat:@"%@",[self.lineInfoDictionary valueForKey:@"name"]];
    //NSString *address=[NSString stringWithFormat:@"%@",[self.lineInfoDictionary valueForKey:@"location"]];
    [self.nameAndAddressLabel setAttributedText:[self setAttributedText:restaurantName withAddress:[self getAddress:[self.userInfoDictionary valueForKey:@"location"]]]];
  }
  
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)yesButtonTapped:(id)sender{
  
  [[AFNetworkReachabilityManager sharedManager] startMonitoring];
  [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
    
    if (status == AFNetworkReachabilityStatusReachableViaWWAN || status ==AFNetworkReachabilityStatusReachableViaWiFi) {
      
      
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        self.yesButton.enabled=NO;
        self.noButton.enabled=NO;
        
        [self.api quitLineForWaiters:@{@"waiters_id":[self.userInfoDictionary objectForKey:@"id"],@"token":[self getToken]} success:^(AFHTTPRequestOperation *task, id responseObject) {
          
          
          [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
          [self performSelector:@selector(goToFBLikePage) withObject:nil afterDelay:0.0];
          
          
        } failure:^(AFHTTPRequestOperation *task, NSError *error) {
          
          UIAlertView * alert =[[UIAlertView alloc ] initWithTitle:@"Cannot Quit this queue"
                                                           message:@"There must be some problem. Click OK to Join another Queue"
                                                          delegate:self
                                                 cancelButtonTitle:@"Ok"
                                                 otherButtonTitles: nil];
          [alert show];
          self.yesButton.enabled=YES;
          self.noButton.enabled=YES;
          [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        }];
    }
    
    else{
      
    NSLog(@"Reachability: %@",AFStringFromNetworkReachabilityStatus(status));
     UIAlertView * alert =[[UIAlertView alloc ] initWithTitle:@"No internet Connection"
                                                       message:@"You cannot quit line"
                                                      delegate:self
                                             cancelButtonTitle:@"Ok"
                                             otherButtonTitles: nil];
      [alert show];
    }
  }];

  
  
}

-(IBAction)noButtonTapped:(id)sender{

  [self goToCurrentPositionScreen:self.userInfoDictionary];
  
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
  NSLog(@"Button Index =%ld",(long)buttonIndex);
  if (buttonIndex == 0)
  {
    NSLog(@"You have clicked Cancel");
  }
  else if(buttonIndex == 1)
  {
    NSLog(@"You have clicked Ok");
  }
}


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
  NSLog(@"-----------------------%@",segue.identifier);
  
  if ([segue.identifier isEqualToString:@"QuitLineToCurrentPositionSegue"]) {
    CurrentPositionViewController *destinationVC = (CurrentPositionViewController*)[segue destinationViewController];
    destinationVC.identifierName=@"QuitLineToCurrentPositionSegue";
    destinationVC.userInfoDictionary=self.userInfoDictionary;
  }
  
  if ([segue.identifier isEqualToString:@"QuitLineToJoinQueueSegue"]) {
    JoinQueueViewController *destinationVC = (JoinQueueViewController*)[segue destinationViewController];
    destinationVC.lineInfoDictionary=self.lineInfoDictionary;
  }
  if ([segue.identifier isEqualToString:@"QuitLineToJoinQueueWithCounterSegue"]) {
    JoinQueueWithCounterViewController *destinationVC = (JoinQueueWithCounterViewController*)[segue destinationViewController];
    destinationVC.lineInfoDictionary=self.lineInfoDictionary;
  }
}


-(void)goToFBLikePage{
 
  ThankYouViewController *thankyouScreen = (ThankYouViewController*)[self.storyboard instantiateViewControllerWithIdentifier:@"ThankYouView"];
    SlideLeftCustomSegue *segue = [[SlideLeftCustomSegue alloc] initWithIdentifier:@"SlideLeftSegue" source:self destination:thankyouScreen];
  [segue presentWithDismissPerformAnimated:NO];
  segue = nil;
  
}


-(void)goToOpenScreen{

   OpeningScreenViewController *openingScreen = (OpeningScreenViewController*)[self.storyboard instantiateViewControllerWithIdentifier:@"OpeningScreen"];
   SlideLeftCustomSegue *segue = [[SlideLeftCustomSegue alloc] initWithIdentifier:@"SlideLeftSegue" source:self destination:openingScreen];
  [segue presentWithDismissPerformAnimated:NO];
   segue = nil;

  // [self presentViewController:openingScreen animated:NO completion:nil];
}


-(void)goToCurrentPositionScreen:(NSDictionary*)userInfoDic{
  
  CurrentPositionViewController *currentPosition = (CurrentPositionViewController*)[self.storyboard instantiateViewControllerWithIdentifier:@"CurrentPosition"];
  currentPosition.lineInfoDictionary=self.lineInfoDictionary;
  currentPosition.userInfoDictionary=userInfoDic;
  SlideLeftCustomSegue *segue = [[SlideLeftCustomSegue alloc] initWithIdentifier:@"SlideLeftSegue" source:self destination:currentPosition];
  [segue presentWithDismissPerformAnimated:YES];
  segue = nil;
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
  [self.noButton setTitle:LOCALIZATION(@"No") forState:UIControlStateNormal];
  [self.yesButton setTitle:LOCALIZATION(@"Yes") forState:UIControlStateNormal];
  [self.quitLineLabel setText:LOCALIZATION(@"quitLineLabel")];
}

-(void)initLocalization{
  self.arrayOfLanguages = [[[Localisator sharedInstance] availableLanguagesArray] copy];
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(receiveLanguageChangedNotification:)
                                               name:kNotificationLanguageChanged
                                             object:nil];
  [self configureViewFromLocalisation];
  
}
/*  NSMutableArray *lineNameArray=[[NSMutableArray alloc] init];
 lineNameArray=[self.vqDefaults objectForKey:@"lineNameArray"];
 
 NSString *line_name = [NSString stringWithFormat:@"%@",[self.userInfoDictionary valueForKey:@"line_name"]];
 if (![lineNameArray containsObject:line_name]) {
 [lineNameArray removeObject:line_name];
 [self.vqDefaults setObject:lineNameArray forKey:@"lineNameArray"];
 [self.vqDefaults synchronize];
 } */

@end
