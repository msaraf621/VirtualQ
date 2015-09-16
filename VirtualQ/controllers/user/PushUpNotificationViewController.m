//
//  PushUpNotification1ViewController.m
//  VirtualQ
//
//  Created by GrepRuby on 01/08/14.
//  Copyright (c) 2014 optimalconsulting. All rights reserved.
//

#import "PushUpNotificationViewController.h"
#import "ThankYouViewController.h"
#import "SlideLeftCustomSegue.h"
#import "QuitLineViewController.h"
#import "SlideRigthCustomSegue.h"
#import <QuartzCore/QuartzCore.h>

@interface PushUpNotificationViewController (){
  NSTimer *timer,*changeBgColourTimer;
}

@end

@implementation PushUpNotificationViewController

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
  [self applyDefaultStyle];
  [self initLocalization];
  
  timer =[NSTimer scheduledTimerWithTimeInterval:AUTOMATIC_REFRESH_TIME target:self selector:@selector(methodCallToRefreshData) userInfo:nil repeats:YES];

}

-(void)viewDidDisappear:(BOOL)animated
{
  [timer invalidate];
  [changeBgColourTimer invalidate];
  [[AFNetworkReachabilityManager sharedManager] stopMonitoring];

}

-(void)applyDefaultStyle{
  
    //Explanation Label
  [self.explanationLabel setFont:[UIFont vqExplanationLabelFont]];
  self.currentPositionButton.enabled=NO;
 // self.currentPositionButton.titleLabel.textAlignment = NSTextAlignmentCenter;
//  self.currentPositionButton.titleLabel.numberOfLines=2;
  self.currentPositionLabel.numberOfLines=2;
  [self.currentPositionButton setBackgroundColor:[UIColor vqCurrentPositonBubbleColor]];

  NSNumber *position=[self.userInfoDictionary objectForKey:@"position"];

  if ([self.identifierName isEqualToString:@"OpeningScreenToPushNotificationSegue"] || [position isEqualToNumber:@0]) {
    [self apperanceForPosition_0];
  }
  else{
    [self apperanceForOtherPosition];
  }

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

-(void)apperanceForPosition_0{

  [self.mainView setBackgroundColor:[UIColor whiteColor]];
  [self.topView setBackgroundColor:[UIColor whiteColor]];
 
  //Timer for Animation
   changeBgColourTimer = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(changeColour) userInfo:nil repeats:YES];

/*  [UIView animateWithDuration:2 delay:0.5 options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionAllowUserInteraction |UIViewAnimationOptionRepeat animations:^{
    [self.mainView setBackgroundColor:[[UIColor vqPushNotificationBottomViewAnimationColor] colorWithAlphaComponent:1.0]];
    [self.topView setBackgroundColor:[[UIColor vqPushNotificationBottomViewAnimationColor] colorWithAlphaComponent:1.0]];

  } completion:^(BOOL finished) {
    [self.mainView setBackgroundColor:[UIColor whiteColor]];
    [self.topView setBackgroundColor:[UIColor whiteColor]];
 //   [UIView setAnimationRepeatCount: 0];
    
  }]; */
  
  //Name and Address Label
  NSString *restaurantName=[NSString stringWithFormat:@"%@",[self.userInfoDictionary valueForKey:@"line_name"]];
    
  //NSString *address=[NSString stringWithFormat:@"%@",[self.userInfoDictionary valueForKey:@"location"]];
  [self.nameAndAddressLabel setAttributedText:[self setAttributedText:restaurantName withAddress:[self getAddress:[self.userInfoDictionary valueForKey:@"location"]]]];
  
  //Current Position Button
  [self changePositionLabel];
  
  //User waiting Name- UILabel
  NSString *userName=[NSString stringWithFormat:@"%@",[self.userInfoDictionary valueForKey:@"group_name"]];
  //User waiting Name- UILabel
  [self.userWaitingNameLabel setAttributedText:[self setAttributedTextForWaitingName:@"Your Waiting Name is" withText:userName]];
  
  [self.explanationLabel setText:LOCALIZATION(@"waitingOverLabel")];
}

-(void)apperanceForOtherPosition{
  [self.mainView setBackgroundColor:[UIColor vqPushNotificationBottomViewColor]];
  [self.topView setBackgroundColor:[UIColor vqPushNotificationTopViewColor]];
  
  //Address & Name Label
  [self.nameAndAddressLabel setAttributedText:[self setAttributedText:@"Restaurant Name" withAddress:@"Address"]];
  
  //User waiting Name- UILabel
  [self.userWaitingNameLabel setAttributedText:[self setAttributedTextForWaitingName:@"Your Waiting Name is" withText:@"Stuttgart"]];
  
  //Current Position Label
  [self currentPositionLabel];
}


- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

- (void)drawCircle{
 
//  UIBezierPath *mybezierpath = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, UNI_VAL(300, 250),  UNI_VAL(250, 200))];
  UIBezierPath *mybezierpath = [UIBezierPath bezierPathWithArcCenter:self.currentPositionLabel.center radius:UNI_VAL(120, 105) startAngle:0 endAngle:360 clockwise:YES];
                                

  CAShapeLayer *lines = [CAShapeLayer layer];
  lines.path          = mybezierpath.CGPath;
  lines.bounds = CGPathGetBoundingBox(lines.path);
  lines.strokeColor = [UIColor vqTableViewTextColor].CGColor;
  lines.fillColor = [UIColor clearColor].CGColor;
  lines.lineWidth = 0.5;
  lines.position = CGPointMake(self.currentPositionLabel.center.x  , self.currentPositionLabel.center.y);
  lines.anchorPoint = CGPointMake(.5, .5);
  
  [self.mainView.layer addSublayer:lines];
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

-(void)initLocalization{
  self.arrayOfLanguages = [[[Localisator sharedInstance] availableLanguagesArray] copy];
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(receiveLanguageChangedNotification:)
                                               name:kNotificationLanguageChanged
                                             object:nil];
  [self configureViewFromLocalisation];
  
}

# pragma mark - NSAttributed Text for Current Position

-(NSAttributedString*)setAttributedTextForCurrentPosition:(NSString*)currentPosition withText:(NSString*)positionText{
  
  NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
  [style setLineSpacing:24];
  
  NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc] init];
  
  NSAttributedString *currentPositionString=[[NSAttributedString alloc] initWithString:currentPosition attributes:@{NSFontAttributeName : [UIFont vqCurPosPushNotificationFont],NSForegroundColorAttributeName: [UIColor vqTableViewTextColor]}];
  
  [attributedStr appendAttributedString:currentPositionString];
  
  NSMutableString *posText=[NSMutableString stringWithFormat:@"\n%@",LOCALIZATION(@"yourPosition")];
  
  NSAttributedString *posTextStr = [[NSAttributedString alloc] initWithString:posText attributes:@{NSFontAttributeName : [UIFont vqYourPositionFont],NSForegroundColorAttributeName: [UIColor vqTableViewTextColor]}];
  
  [attributedStr appendAttributedString:posTextStr];
  
  return attributedStr;
}

#pragma mark- Automatic Refresh


-(void)methodCallToRefreshData{
  
  dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    
    //Call your function or whatever work that needs to be done
    //Code in this part is run on a background thread
    
    NSLog(@"Refresh Data-Push Notification");
    [self callApi];
    
    dispatch_async(dispatch_get_main_queue(), ^(void) {
      
      //Stop your activity indicator or anything else with the GUI
      //Code here is run on the main thread
      
    });
  });
  
}

-(void)callApi{
  
  [[AFNetworkReachabilityManager sharedManager] startMonitoring];
  [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
    
    if (status == AFNetworkReachabilityStatusReachableViaWWAN || status ==AFNetworkReachabilityStatusReachableViaWiFi) {
      
      NSString *url1=[NSString stringWithFormat:@"http://virtualq-api.herokuapp.com:80/api/v1/waiters/%@.json?token=%@",[self.userInfoDictionary objectForKey:@"id"],[self getToken]];
      
      NSURLRequest *request = [NSURLRequest requestWithURL:
                               [NSURL URLWithString:url1]];
      
      [NSURLConnection sendAsynchronousRequest:request
                                         queue:[NSOperationQueue mainQueue]
                             completionHandler:^(NSURLResponse *response,
                                                 NSData *data,
                                                 NSError *connectionError) {
                               
                                 NSDictionary* userInfoDic = nil;
                                 
                                 if (data){
                                     userInfoDic = [NSJSONSerialization
                                                    JSONObjectWithData:data
                                                    
                                                    options:kNilOptions
                                                    error:&connectionError];
                                 }
                               
                               
                               if([userInfoDic count]==0)
                               {
                                 NSLog(@"Dic is Null--- %@",userInfoDic);
                                 [self performSelector:@selector(goToFBLikePage) withObject:nil afterDelay:0.3];
                               }
                               
                               else{
                                 NSNumber *position=[userInfoDic valueForKey:@"position"];
                                 if([position isEqualToNumber:@0]){
                                   [self changePositionLabel];
                                 }
                               }
                               
                               
                               
                               // handle response
                             }];

      
      
    }
    else{
      NSLog(@"Reachability: %@",AFStringFromNetworkReachabilityStatus(status));
    }
    
  }];
 
  
  
}

-(void)goToFBLikePage{
  ThankYouViewController *thankyouScreen = (ThankYouViewController*)[self.storyboard instantiateViewControllerWithIdentifier:@"ThankYouView"];
  SlideLeftCustomSegue *segue = [[SlideLeftCustomSegue alloc] initWithIdentifier:@"SlideLeftSegue" source:self destination:thankyouScreen];
  [segue presentWithDismissPerformAnimated:NO];
  segue = nil;
  
}

-(void)changePositionLabel{
  [self.currentPositionLabel setAttributedText:[self setAttributedTextYouAreUp]];
}


#pragma mark- Change color animation

- (void) changeColour {
  // Don't just change the colour - give it a little animation.
  dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    
    //Call your function or whatever work that needs to be done
    //Code in this part is run on a background thread
    
    dispatch_async(dispatch_get_main_queue(), ^(void) {
      
      //Stop your activity indicator or anything else with the GUI
      //Code here is run on the main thread
      
      [UIView animateWithDuration:1.5 animations:^{
        // No need to set a flag, just test the current colour.
        if ([self.mainView.backgroundColor isEqual:[UIColor whiteColor]]) {
          [self.mainView setBackgroundColor:[[UIColor vqPushNotificationBottomViewAnimationColor] colorWithAlphaComponent:1.0]];
          [self.topView setBackgroundColor:[[UIColor vqPushNotificationBottomViewAnimationColor] colorWithAlphaComponent:1.0]];
        }
        
        else {
          [self.mainView setBackgroundColor:[UIColor whiteColor]];
          [self.topView setBackgroundColor:[UIColor whiteColor]];
        }
        
      }];

    });
  });

  
  // Now we're done with the timer.
  // [self.changeBgColourTimer invalidate];
  //  self.changeBgColourTimer = nil;
}

#pragma mark Quit Line button Tapped Methods

-(IBAction)quitLineButtonTapped:(id)sender{
    QuitLineViewController *quitLine=(QuitLineViewController*)[self.storyboard instantiateViewControllerWithIdentifier:@"QuitLine"];
    quitLine.userInfoDictionary=self.userInfoDictionary;
    quitLine.identifierName = @"QuitLineToCurrentPositionSegue";
    SlideRigthCustomSegue *segue = [[SlideRigthCustomSegue alloc] initWithIdentifier:@"SlideRigthSegue" source:self destination:quitLine];
    [segue presentWithDismissPerformAnimated:YES];
    
}

@end
