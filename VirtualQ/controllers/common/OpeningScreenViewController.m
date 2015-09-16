//
//  OpeningScreenViewController.m
//  VirtualQ
//
//  Created by GrepRuby on 04/07/14.
//  Copyright (c) 2014 optimalconsulting. All rights reserved.
//

#import "OpeningScreenViewController.h"
#import "LookForQueueViewController.h"
#import "CurrentPositionViewController.h"
#import "ManageQueueViewController.h"
#import "PushUpNotificationViewController.h"
#import "PulsingHaloLayer.h"
#import "SlideRigthCustomSegue.h"
#import "SlideLeftCustomSegue.h"
#import "OpenQueueViewController.h"

@interface OpeningScreenViewController (){
  CLLocation *currentLocation;
  NSTimer *timer;
}

@property (nonatomic,strong) IBOutlet UIButton *openLineButton;
@property (nonatomic,strong) IBOutlet UIButton *anyWaitButton;
@property (nonatomic,strong) IBOutlet UILabel *searchingLabel;
@end

@implementation OpeningScreenViewController


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad{
  
  [super viewDidLoad];
   //timer =[NSTimer scheduledTimerWithTimeInterval:15 target:self selector:@selector(checkReachabilty) userInfo:nil repeats:YES];
  self.isCurrentPage=TRUE;
  [self animationSetup];
  [self initLocalization];
  [self beginUpdationgLocation];
  //[self checkReachabilty];
  [self performSelectorOnMainThread:@selector(checkReachabilty) withObject:nil waitUntilDone:YES];
  [self applyDefaultStyles];
  
}

-(void)viewDidDisappear:(BOOL)animated{
  
  [[AFNetworkReachabilityManager sharedManager] stopMonitoring];
  //[timer invalidate];
}

-(void)checkReachabilty{
  
  
 // NSLog(@"Open Screen [self class] --- %@",[self class]);
//  NSLog(@"Open Screen Presented--- %@",self.presentedViewController);

  [[AFNetworkReachabilityManager sharedManager] startMonitoring];
  [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
    
    NSLog(@"Reachability: %@",AFStringFromNetworkReachabilityStatus(status));

    if (status == AFNetworkReachabilityStatusReachableViaWWAN || status ==AFNetworkReachabilityStatusReachableViaWiFi) {
      
      if ([self.vqDefaults valueForKey:@"token"]==nil  && self.isCurrentPage ) {
    
        [self.api createSession:@{@"deviceID": [self getDeviceUDID]} success:^(AFHTTPRequestOperation *task, id responseObject) {
          
            // Here because you want to know which user is using the app before try to save the device token in the DB !
            // This will call : didRegisterForRemoteNotificationsWithDeviceToken
            if(IS_IOS8){
                [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge) categories:nil]];
                //                [[UIApplication sharedApplication] registerForRemoteNotifications];
            }
            else{
                [[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)];
            }
            
          NSLog(@"Opening Screen----------- Create Session");
          [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
          [self performSelector:@selector(callApi) withObject:nil afterDelay:1];
          
        } failure:^(AFHTTPRequestOperation *task, NSError *error) {
          
          [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
          [self performSelector:@selector(checkReachabilty) withObject:nil afterDelay:10];
        }];

      }else{
          if(IS_IOS8){
              [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge) categories:nil]];
              //                [[UIApplication sharedApplication] registerForRemoteNotifications];
          }
          else{
              [[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)];
          }
        [self performSelector:@selector(callApi) withObject:nil afterDelay:0];
      }
      
    }else{
      //If network unavialable.
      [self performSelector:@selector(checkReachabilty) withObject:nil afterDelay:5];
    }
  }];

}


-(void)callApi{
  
  if (self.isCurrentPage && [self getToken]) {
    
    [self.api getUserByToken:@{@"token": [self getToken]} success:^(AFHTTPRequestOperation *task, id responseObject) {
      NSString *userMode=[NSString stringWithFormat:@"%@",[responseObject objectForKey:@"mode"]];
            
      if([userMode isEqualToString:@"normal"]){
        [self callApiCheckLocation];
      }
      
      if([userMode isEqualToString:@"user"]){
        [self callGetListofWaitersInJoinedQueue];
      }
      
      if([userMode isEqualToString:@"host"]){
        [self callGetListOfHostedQueue];
      }
      
    } failure:^(AFHTTPRequestOperation *task, NSError *error) {
      [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
      [self performSelector:@selector(callApi) withObject:nil afterDelay:5];
    }];

  }
}

-(void)callApiToGetAllLines{
  
  [self.api getAllLine:nil success:^(AFHTTPRequestOperation *task, id responseObject) {
    
    [self performSelector:@selector(gotToLookForQueueScreen) withObject:nil afterDelay:0.0];

  } failure:^(AFHTTPRequestOperation *task, NSError *error) {
    
  if ([VQLine countOfEntities]>0) {
      [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
      [self performSelector:@selector(gotToLookForQueueScreen) withObject:nil afterDelay:0.0];
    }
    else{
      [self performSelector:@selector(callApiToGetAllLines) withObject:nil afterDelay:5.0];

    }
  }];
}

-(void)callGetLineWithCurrentLocation{

  [self.api getLine:@{@"userLocation": [self getCurrentLocation]} success:^(AFHTTPRequestOperation *task, id responseObject) {
    [self performSelector:@selector(gotToLookForQueueScreen) withObject:nil afterDelay:0.0];
  }
     failure:^(AFHTTPRequestOperation *task, NSError *error) {
       
  [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
  if ([VQLine countOfEntities]>0) {
    [self performSelector:@selector(gotToLookForQueueScreen) withObject:nil afterDelay:0.0];
  }else{
    [self performSelector:@selector(callGetLineWithCurrentLocation) withObject:nil afterDelay:5.0];
  }
}];

}
-(void)callApiCheckLocation{
  
// switch to a background thread and perform your expensive operation
    if([CLLocationManager locationServicesEnabled] && [CLLocationManager authorizationStatus] != kCLAuthorizationStatusDenied) {
      //Calling api
      NSNumber *latitude = (NSNumber*)[self.vqDefaults  objectForKey:@"latitude"];
      NSNumber *longitude = (NSNumber*)[self.vqDefaults  objectForKey:@"longitude"];
      if ([latitude isEqualToNumber:@0] && [longitude isEqualToNumber:@0]){
        
        [self callApiToGetAllLines];
      }
      else{
        [self callGetLineWithCurrentLocation];
      }
    }
    else
    {
      [self callApiToGetAllLines];
    }
}


-(void)callGetListofWaitersInJoinedQueue{

  [self.api getListofWaitersInJoinedQueue:@{@"token": [self getToken]} success:^(AFHTTPRequestOperation *task, id responseObject) {
    
    self.vqDefaults=[NSUserDefaults standardUserDefaults];
    /*     NSMutableArray *lineNameArray=[self.vqDefaults objectForKey:@"lineNameArray"];
     
     if (!lineNameArray) lineNameArray = [[NSMutableArray alloc] init];
     else lineNameArray=[self.vqDefaults objectForKey:@"lineNameArray"];  */
    
    for (NSDictionary *dic in responseObject) {
      
      if([dic objectForKey:@"position"]==[NSNull null]){
        [self gotToLookForQueueScreen];
      }
      
      if(!([dic objectForKey:@"position"]==[NSNull null])){
        
        NSNumber *position=[dic objectForKey:@"position"];
        
        if ([position isEqualToNumber:@0]) {
          
          [self goToPushNotification:dic];
          
          /*  if([lineNameArray containsObject:[dic valueForKey:@"line_name"]]){
           [self gotToLookForQueueScreen];  }
           else{
           //Go to current position screen
           [self gotToCurrentPositionScreen:dic];  }
           */
        }
        else{
          //Go to current position screen
          [self gotToCurrentPositionScreen:dic];
        }
      }
    }
    
  } failure:^(AFHTTPRequestOperation *task, NSError *error) {
    
    [self performSelector:@selector(callGetListofWaitersInJoinedQueue) withObject:nil afterDelay:5];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
    
  }];

}

-(void)callGetListOfHostedQueue{

  [self.api getListOfHostedQueue:@{@"token":[self getToken]} success:^(AFHTTPRequestOperation *task, id responseObject) {
    
    for (NSDictionary *dic in responseObject) {
      
      if([[dic objectForKey:@"open"] isEqualToString:@"true"]){
        
        [self.vqDefaults setObject:[dic objectForKey:@"id"] forKey:@"lineId"];
        [self.vqDefaults synchronize];
        double delayInSeconds = 0.1;
        
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
          //code to be executed on the main queue after delay
          [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
          
          ManageQueueViewController *manageQueue = (ManageQueueViewController*)[self.storyboard instantiateViewControllerWithIdentifier:@"ManageQueue"];
          manageQueue.lineInfoDic=dic;
          SlideRigthCustomSegue *segue = [[SlideRigthCustomSegue alloc] initWithIdentifier:@"SlideRigthSegue" source:self destination:manageQueue];
          if ([self.identifierName isEqualToString:@"ThankYouViewController"]) {
            [segue presentWithDismissPerformAnimated:YES];
          }else{
            [segue presentPerformAnimated:YES];
          }
        });
      }
    }
  } failure:^(AFHTTPRequestOperation *task, NSError *error) {
    
    [self performSelector:@selector(callGetListOfHostedQueue) withObject:nil afterDelay:5];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
  }];

}

-(void)gotToLookForQueueScreen{
  [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;

  LookForQueueViewController *lookForQueue = (LookForQueueViewController*)[self.storyboard instantiateViewControllerWithIdentifier:@"LookForQueue"];
  
  SlideRigthCustomSegue *segue = [[SlideRigthCustomSegue alloc] initWithIdentifier:@"SlideRigthSegue" source:self destination:lookForQueue];
  if ([self.identifierName isEqualToString:@"ThankYouViewController"]) {
    [segue presentWithDismissPerformAnimated:YES];
  }else{
  [segue presentPerformAnimated:YES];
  }
  
}


-(void)gotToCurrentPositionScreen:(NSDictionary*)userInfoDictionary{
  
  [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
  CurrentPositionViewController *currentPosition = (CurrentPositionViewController*)[self.storyboard instantiateViewControllerWithIdentifier:@"CurrentPosition"];
  currentPosition.userInfoDictionary=userInfoDictionary;
  SlideRigthCustomSegue *segue = [[SlideRigthCustomSegue alloc] initWithIdentifier:@"SlideRigthSegue" source:self destination:currentPosition];
  if ([self.identifierName isEqualToString:@"ThankYouViewController"]) {
    [segue presentWithDismissPerformAnimated:YES];
  }else{
    [segue presentPerformAnimated:YES];
  }
   segue = nil;
}

-(void)goToPushNotification:(NSDictionary*)userInfoDictionary{
  
  [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
  PushUpNotificationViewController *pushNotification = (PushUpNotificationViewController*)[self.storyboard instantiateViewControllerWithIdentifier:@"PushUpNotification"];
  pushNotification.userInfoDictionary=userInfoDictionary;
  SlideLeftCustomSegue *segue = [[SlideLeftCustomSegue alloc] initWithIdentifier:@"SlideLeftSegue" source:self destination:pushNotification];
  if ([self.identifierName isEqualToString:@"ThankYouViewController"]) {
    [segue presentWithDismissPerformAnimated:YES];
  }else{
    [segue presentPerformAnimated:YES];
  }

}


-(void)applyDefaultStyles{
  
  //Initialization of NSUserDefault
  
  //Bringing Button and Label to front
  [self.view bringSubviewToFront:self.openLineButton];
  [self.view bringSubviewToFront:self.searchingLabel];
  
  //Properties of Open Line Button
  [self.openLineButton setBackgroundColor:[UIColor vqOpenLineBubbleColor]];
  self.openLineButton.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
  
  // you probably want to center it
  self.openLineButton.titleLabel.textAlignment = NSTextAlignmentCenter;
  [self.openLineButton.titleLabel setFont:[UIFont vqOpenLineBubbleFont]];
//  NSString *openLineStr=[NSString stringWithFormat:@"Open\nline"];
//  [self.openLineButton setTitle:openLineStr forState: UIControlStateNormal];
  self.openLineButton.titleLabel.textColor=[UIColor vqOpenLineBubbleTextColor];

  
  //AnyWait Button
  self.anyWaitButton.enabled=NO;
 [self.anyWaitButton setBackgroundColor:[UIColor vqAnyWaitButtonColor] ];
 [self.anyWaitButton setAttributedTitle:[self setAttributedTextForAnyWait] forState:UIControlStateNormal];
  
  //Searching Label
  [self.searchingLabel setFont:[UIFont vqOpeningScreenTitleFont]];
  
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)openLineTapped:(id)sender{
  
  self.isCurrentPage = FALSE;
//  [timer invalidate];
//  [[NSOperationQueue mainQueue] setSuspended:YES];
//  [[self.api operationQueue] cancelAllOperations];
 OpenQueueViewController *openQueue = (OpenQueueViewController*)[self.storyboard instantiateViewControllerWithIdentifier:@"OpenQueue"];
  openQueue.identifierName=@"OpeningScreen";
  SlideLeftCustomSegue *segue = [[SlideLeftCustomSegue alloc] initWithIdentifier:@"SlideLeftSegue" source:self destination:openQueue];
  if ([self.identifierName isEqualToString:@"ThankYouViewController"]) {
    [segue presentWithDismissPerformAnimated:YES];
  }else{
    [segue presentPerformAnimated:YES];
  }
}


# pragma mark - Pulsing Animation

-(void)animationSetup{
  CGFloat animationDuration=9;
  CGFloat increment=1.6;
  for (int i=0; i< (int)(animationDuration/increment); i++) {
    CGFloat animationStepDuration= increment +(increment * i);
    [self pulsingAnimationSetup:animationStepDuration layer:[PulsingHaloLayer layer]];
  }
}

-(void)pulsingAnimationSetup:(double)delayInSeconds layer:(PulsingHaloLayer*)pulsingLayer{
  dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
  dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
    [self pulsingLayerSetup:pulsingLayer];
  });
}

-(void)pulsingLayerSetup:(PulsingHaloLayer*)pulsingLayer{
  pulsingLayer.position = self.anyWaitButton.center;
  pulsingLayer.toValueForRadius=1;
  pulsingLayer.radius = UNI_VAL(500, 280);
  pulsingLayer.backgroundColor=[[UIColor vqAnyWaitButtonColor] CGColor];
  [self.view.layer insertSublayer:pulsingLayer below:self.anyWaitButton.layer];
}


#pragma mark - Notification methods for Localization

-(void)initLocalization{
  self.arrayOfLanguages = [[[Localisator sharedInstance] availableLanguagesArray] copy];
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(receiveLanguageChangedNotification:)
                                               name:kNotificationLanguageChanged
                                             object:nil];
  [self configureViewFromLocalisation];
}

-(void)configureViewFromLocalisation
{
  [self.searchingLabel  setText:LOCALIZATION(@"searchingLabel")];
  NSString *openLineStr=[[NSString alloc] init];
   openLineStr =[NSString stringWithFormat:@"%@\n%@",LOCALIZATION(@"Open"),LOCALIZATION(@"line")];
  [self.openLineButton setTitle:openLineStr forState: UIControlStateNormal];
}


- (void) receiveLanguageChangedNotification:(NSNotification *) notification
{
  if ([notification.name isEqualToString:kNotificationLanguageChanged])
  {
    [self configureViewFromLocalisation];
  }
}

# pragma  mark - Update Location 


-(void)beginUpdationgLocation{
  
  if(self.locationManager==nil){
  self.locationManager = [[CLLocationManager alloc] init];
  }
  self.locationManager.delegate = self;
  self.locationManager.distanceFilter = 500;
  self.locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
  currentLocation = [self.locationManager location];

//  NSLog(@"%f %f", currentLocation.coordinate.latitude, currentLocation.coordinate.longitude);
  
  NSNumber *latitude = [NSNumber numberWithDouble:currentLocation.coordinate.latitude];
  NSNumber *longitude = [NSNumber numberWithDouble:currentLocation.coordinate.longitude];


  [self.vqDefaults setObject:latitude forKey:@"latitude"];
  [self.vqDefaults setObject:longitude forKey:@"longitude"];
  [self.vqDefaults synchronize];


}

@end
