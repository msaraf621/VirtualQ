//
//  CurrentPositionViewController.m
//  VirtualQ
//
//  Created by GrepRuby on 05/07/14.
//  Copyright (c) 2014 optimalconsulting. All rights reserved.
//

#import "CurrentPositionViewController.h"
#import "PushUpNotificationViewController.h"
#import "QuitLineViewController.h"
#import "ThankYouViewController.h"
#import "SlideLeftCustomSegue.h"
#import "SlideRigthCustomSegue.h"

@interface CurrentPositionViewController (){
  NSTimer *timer;
}
@property (nonatomic,strong) IBOutlet UIButton *currentPositionButton;
@property (nonatomic,strong) IBOutlet UIButton *secondButton;
@property (nonatomic,strong) IBOutlet UIButton *thirdButton;
@property (nonatomic,strong) IBOutlet UIButton *fourthButton;
@property (nonatomic,strong) IBOutlet UIButton *quitLineButton;

@property (nonatomic,strong) IBOutlet UILabel *nameAndAddressLabel;
@property (nonatomic,strong) IBOutlet UILabel *userWaitingNameLabel;
@property (nonatomic,strong) IBOutlet UIView *quitLineButtonView;

@property (nonatomic,strong) NSNumber *position;
@property (nonatomic,strong) NSTimer *changeBgColourTimer;
@end

@implementation CurrentPositionViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewDidDisappear:(BOOL)animated
{
  [timer invalidate];
  [[AFNetworkReachabilityManager sharedManager] stopMonitoring];
}



- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initLocalization];
  
    [self setCommonProperties];
    [self changeLabels];
    [self changeBackgroundOfButton];
  
    if([self.identifierName isEqualToString:@"QuitLineToCurrentPositionSegue"]){
      self.currentPositionButton.alpha=1;
      [self callApi];
        }else{
      [self applyDefaultStyles];
   }
  
  UITapGestureRecognizer *singleFingerTap = [[UITapGestureRecognizer alloc] initWithTarget:self action: @selector(goToQuitLineScreen)];
  [self.quitLineButtonView addGestureRecognizer:singleFingerTap];
  
  timer =[NSTimer scheduledTimerWithTimeInterval:AUTOMATIC_REFRESH_TIME target:self selector:@selector(methodCallToRefreshData) userInfo:nil repeats:YES];

	// Do any additional setup after loading the view.
}


-(void)applyDefaultStyles{
  
  self.position=[self.userInfoDictionary valueForKey:@"position"];
  self.scrollView.scrollEnabled = FALSE;
  if ([self.position isEqualToNumber:@0]) {
    [self apperanceForPosition_0];
    }
  else{
    [self apperanceForOtherPosition];
  
  }
  
}

-(void)apperanceForPosition_0{
  //User waiting Name- UILabel
  self.changeBgColourTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(changeColour) userInfo:nil repeats:YES];

  self.quitLineButton.hidden=YES;
  
  [UIView animateWithDuration:1.0 animations:^{
    self.secondButton.alpha=0;
    self.thirdButton.alpha=0;
    self.fourthButton.alpha=0;
    self.currentPositionButton.alpha=0;
  } completion:^(BOOL finished) {
    
  }];
  

    /*  NSMutableArray *lineNameArray=[[NSMutableArray alloc] init];
  lineNameArray=[self.vqDefaults objectForKey:@"lineNameArray"];
 
  NSString *line_name = [NSString stringWithFormat:@"%@",[self.userInfoDictionary valueForKey:@"line_name"]];
  if (![lineNameArray containsObject:line_name]) {
    [lineNameArray addObject:line_name];
    [self.vqDefaults setObject:lineNameArray forKey:@"lineNameArray"];
    [self.vqDefaults synchronize];
  } */

}

-(void)apperanceForOtherPosition{
  
  [self.quitLineButton setBackgroundColor:[UIColor vqOpenLineBubbleColor]];
  [self changePositionLabel];

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
  
  NSString *restaurantName=[NSString stringWithFormat:@"%@",[self.userInfoDictionary valueForKey:@"line_name"]];
  //NSString *address=[NSString stringWithFormat:@"%@",[self.userInfoDictionary valueForKey:@"location"]];
    [self.nameAndAddressLabel setAttributedText:[self setAttributedText:restaurantName withAddress:[self getAddress:[self.userInfoDictionary valueForKey:@"location"]]]];
  
  NSString *userName=[NSString stringWithFormat:@"%@",[self.userInfoDictionary valueForKey:@"group_name"]];
  
  //User waiting Name- UILabel
  [self.userWaitingNameLabel setAttributedText:[self setAttributedTextForWaitingName:@"Your Waiting Name is" withText:userName]];
  
  [self changePositionLabel];
}

-(void)changeBackgroundOfButton{
  
  [self.secondButton setBackgroundColor:[[UIColor vqCurrentPositonBubbleColor] colorWithAlphaComponent:0.9f]];
  [self.thirdButton setBackgroundColor:[[UIColor vqCurrentPositonBubbleColor] colorWithAlphaComponent:0.75f]];
  [self.fourthButton setBackgroundColor:[[UIColor vqCurrentPositonBubbleColor] colorWithAlphaComponent:0.5f]];
  [self.currentPositionButton setBackgroundColor:[UIColor vqCurrentPositonBubbleColor]];


}

-(void)setCommonProperties{
  
  //Common Properties
  //self.explanationLabel.hidden=YES;
  
  self.currentPositionButton.userInteractionEnabled=NO;
  self.currentPositionButton.titleLabel.textAlignment = NSTextAlignmentCenter;
  self.currentPositionButton.titleLabel.numberOfLines=2;
  [self.currentPositionButton setBackgroundColor:[UIColor vqCurrentPositonBubbleColor]];
  /*
  self.youAreUpButton.alpha=0;
  self.youAreUpButton.enabled=NO;
  self.youAreUpButton.titleLabel.textAlignment = NSTextAlignmentCenter;
  self.youAreUpButton.titleLabel.numberOfLines=2;
  [self.youAreUpButton setBackgroundColor:[UIColor vqCurrentPositonBubbleColor]];
   */
  
}


- (void) changeColour {
  // Don't just change the colour - give it a little animation.
  
  [UIView animateWithDuration:0.25 animations:^{
    // No need to set a flag, just test the current colour.
    if ([self.view.backgroundColor isEqual:[UIColor whiteColor]]) {
      self.view.backgroundColor = [UIColor vqPushNotificationBottomViewAnimationColor];
    } else {
      self.view.backgroundColor = [UIColor whiteColor];
    }
  }];
  
  // Now we're done with the timer.
  // [self.changeBgColourTimer invalidate];
  //  self.changeBgColourTimer = nil;
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
                               
                               
                               if (connectionError==nil) {

                                 NSDictionary* userInfoDic = [NSJSONSerialization
                                                              JSONObjectWithData:data
                                                              options:kNilOptions
                                                              error:&connectionError];
                                 
                                 NSLog(@"Current Position Api --- %@",userInfoDic);

                                 self.position=[userInfoDic valueForKey:@"position"];
                             
                                 if (userInfoDic==NULL) {
                                   [self goToFBLikePage];
                                 }

                                 
                                if(userInfoDic!=NULL && [self.position isEqualToNumber:@0])
                            {
                                   NSLog(@"Push Notification --- %@",userInfoDic);
                                   [self goToPushNotification:userInfoDic];
                                 }
                                 
                                 
                                 else{
                                   self.userInfoDictionary=userInfoDic;
                                   [self changePositionLabel];
                                   NSLog(@"Here--- %@",userInfoDic);
                                   
                                 }
                                 
                               }else{
                                 NSLog(@"Error in Refresh Data- : %@",connectionError);
                                 
                               }
                               
                             }];
      }
    NSLog(@"Reachability: %@",AFStringFromNetworkReachabilityStatus(status));
  }];

  
 
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)changePositionLabel{
 self.position=[self.userInfoDictionary valueForKey:@"position"];
  NSString *position=[NSString stringWithFormat:@"%@",self.position];
  [self.currentPositionButton setAttributedTitle:[self setAttributedTextForCurrentPosition:position withText:@"Your Position"] forState:UIControlStateNormal];
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

#pragma mark- Navigation

-(void)goToFBLikePage{
  ThankYouViewController *thankyouScreen = (ThankYouViewController*)[self.storyboard instantiateViewControllerWithIdentifier:@"ThankYouView"];
  [self presentViewController:thankyouScreen animated:NO completion:nil];
}

-(void)goToPushNotification:(NSDictionary*)userInfoDictionary{
  
  PushUpNotificationViewController *pushNotification = (PushUpNotificationViewController*)[self.storyboard instantiateViewControllerWithIdentifier:@"PushUpNotification"];
  pushNotification.userInfoDictionary=userInfoDictionary;
  [self presentViewController:pushNotification animated:NO completion:nil];
}


-(void)goToQuitLineScreen{
  QuitLineViewController *quitLine=(QuitLineViewController*)[self.storyboard instantiateViewControllerWithIdentifier:@"QuitLine"];
  quitLine.userInfoDictionary=self.userInfoDictionary;
  quitLine.identifierName = @"QuitLineToCurrentPositionSegue";
  SlideRigthCustomSegue *segue = [[SlideRigthCustomSegue alloc] initWithIdentifier:@"SlideRigthSegue" source:self destination:quitLine];
  [segue presentWithDismissPerformAnimated:YES];
  
  //[self performSegueWithIdentifier:@"CurrentPostionToQuitLineSegue" sender:Nil];
}

-(IBAction)quitLineButtonTapped:(id)sender{
  [self goToQuitLineScreen];
//  [self performSegueWithIdentifier:@"CurrentPostionToQuitLineSegue" sender:sender];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
  if ([segue.identifier isEqualToString:@"CurrentPostionToQuitLineSegue"]) {
    QuitLineViewController *destinationVC = (QuitLineViewController*)[segue destinationViewController];
    destinationVC.userInfoDictionary=self.userInfoDictionary;
    destinationVC.identifierName = @"QuitLineToCurrentPositionSegue";
  }
}

#pragma mark- Automatic Refresh

-(void)methodCallToRefreshData{
  
  
  
  dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    
    //Call your function or whatever work that needs to be done
    //Code in this part is run on a background thread
    
   // NSLog(@"Refresh Data- Current Position");
    [self callApi];
    
    dispatch_async(dispatch_get_main_queue(), ^(void) {
      
      //Stop your activity indicator or anything else with the GUI
      //Code here is run on the main thread
      
    });
  });
  
}



@end
