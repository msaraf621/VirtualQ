//
//  CountUserViewController.m
//  VirtualQ
//
//  Created by GrepRuby on 05/07/14.
//  Copyright (c) 2014 optimalconsulting. All rights reserved.
//

#import "JoinQueueWithCounterViewController.h"
#import "QuitLineViewController.h"
#import "CurrentPositionViewController.h"
#import "LookForQueueViewController.h"
#import "SlideLeftCustomSegue.h"
#import "SlideRigthCustomSegue.h"

@interface JoinQueueWithCounterViewController (){
}

@end

@implementation JoinQueueWithCounterViewController


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
  [self createSession];
  [self applyDefaultStyles];
  [self initLocalization];
  
  UITapGestureRecognizer *singleFingerTap = [[UITapGestureRecognizer alloc] initWithTarget:self action: @selector(goToLookForQueueScreen)];
  [self.quitLineButtonView addGestureRecognizer:singleFingerTap];
  
	// Do any additional setup after loading the view.
}


-(void)createSession{
  
  NSLog(@" --- %@",[self class]);

  if ([self.vqDefaults valueForKey:@"token"]==nil) {

    self.joinLineButton.enabled=NO;
    [self.api createSession:@{@"deviceID": [self getDeviceUDID]} success:^(AFHTTPRequestOperation *task, id responseObject) {
      
      self.joinLineButton.enabled=YES;

    } failure:^(AFHTTPRequestOperation *task, NSError *error) {
      
      [self performSelector:@selector(createSession) withObject:nil afterDelay:0];
    }];
  }
}

-(void)applyDefaultStyles{
  self.count=1;
  
  
  [self.counterView.layer setCornerRadius:30.0f];
  [self.counterView.layer setMasksToBounds:YES];
  [self.counterView setBackgroundColor:[UIColor vqCountWaitingUserColor]];
  
  [self.increseaseCountButton setBackgroundColor:[UIColor vqCountIncreaseColor]];
  [self.decreseaseCountButton setBackgroundColor:[UIColor vqCountDecreaseColor]];
  [self.joinLineButton setBackgroundColor:[UIColor vqBubbleColor]];
  [self.quitLineButton setBackgroundColor:[UIColor vqCountDecreaseColor]];
  
  [self.increseaseCountButton setShapeFillColor:[UIColor vqPlusMinusColor]];
  [self.increseaseCountButton setShapeStrokColor:[UIColor vqPlusMinusColor]];
  [self.decreseaseCountButton setShapeFillColor:[UIColor vqPlusMinusColor]];
  [self.decreseaseCountButton setShapeStrokColor:[UIColor vqPlusMinusColor]];
  
  //Join Line Button
  self.joinLineButton.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
  self.joinLineButton.titleLabel.textAlignment = NSTextAlignmentCenter;
  self.joinLineButton.titleLabel.font=[UIFont vqOpenLineBubbleFont];
  NSString *joinLineStr=[NSString stringWithFormat:@"Join\nline"];
 [self.joinLineButton setTitle:joinLineStr forState: UIControlStateNormal];

  //Question Label
  [self.questionLabel setFont:[UIFont vqQuestionLabelFont]];
  [self.questionLabel setText:@"How many people do you want to line up?"];
  
  //Short Description Label
  [self.shortDescriptionLabel setFont:[UIFont vqShortDescriptionLabelFont]];

  //Number of Person Label
  [self.numberOfPersonLabel setFont:[UIFont vqNumberOfPersonLabelFont]];
  NSString *numberOfStringStr=[NSString stringWithFormat:@"1 Pers"];
  [self.numberOfPersonLabel setText:numberOfStringStr];
  

  [self changeLabels];

  }

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewDidDisappear:(BOOL)animated
{
  [[AFNetworkReachabilityManager sharedManager] stopMonitoring];
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
  NSString *joinLineStr=[NSString stringWithFormat:@"%@\n%@",LOCALIZATION(@"Join"),LOCALIZATION(@"line1")];
  [self.joinLineButton setTitle:joinLineStr forState: UIControlStateNormal];
  [self.questionLabel setText:LOCALIZATION(@"joinQueueWithCounterQuestion")];
  NSString *numberOfStringStr=[NSString stringWithFormat:@"1 %@",LOCALIZATION(@"person")];
  [self.numberOfPersonLabel setText:numberOfStringStr];
  
  
}

-(void)initLocalization{
  
  self.arrayOfLanguages = [[[Localisator sharedInstance] availableLanguagesArray] copy];
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(receiveLanguageChangedNotification:)
                                               name:kNotificationLanguageChanged
                                             object:nil];
  [self configureViewFromLocalisation];
  
}

#pragma mark- Other function

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
  
  NSString *restaurantName=[NSString stringWithFormat:@"%@",[self.lineInfoDictionary valueForKey:@"name"]];
  //NSString *address=[NSString stringWithFormat:@"%@",[self.lineInfoDictionary valueForKey:@"location"]];
    [self.nameAndAddressLabel setAttributedText:[self setAttributedText:restaurantName withAddress:[self getAddress:[self.lineInfoDictionary valueForKey:@"location"]]]];
  NSString *shortDesc=[NSString stringWithFormat:@"%@",[self.lineInfoDictionary valueForKey:@"info"]];

  if([self.lineInfoDictionary valueForKey:@"info"]==[NSNull null] || [shortDesc isEqualToString:@"(null)"]){
    shortDesc=[NSString stringWithFormat:@"No Information"];
    [self.shortDescriptionLabel setText:shortDesc];
  }else{
    [self.shortDescriptionLabel setText:shortDesc];
    
  }
 
}

-(IBAction)increaseCountTapped:(id)sender{
  
  if(self.count>=1 && self.count<9){
    self.count+=1;
    NSString *numberOfStringStr=[NSString stringWithFormat:@"%ld %@",(long)self.count, LOCALIZATION(@"person")];
    [self.numberOfPersonLabel setText:numberOfStringStr];
   }

}

-(IBAction)decreaseCountTapped:(id)sender{

  if(self.count>1 && self.count<=9){
    self.count-=1;
    NSString *numberOfStringStr=[NSString stringWithFormat:@"%ld %@",(long)self.count, LOCALIZATION(@"person")];
    [self.numberOfPersonLabel setText:numberOfStringStr];
  }

}

#pragma mark- Call api

-(IBAction)joinLineButtonTapped:(id)sender{
  
  [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
  self.joinLineButton.enabled=NO;
  self.quitLineButton.enabled=NO;
  self.quitLineButtonView.userInteractionEnabled=NO;
  // self.joinLineButton.userInteractionEnabled=NO;
  //  self.quitLineButton.userInteractionEnabled=NO;
  [self callJoinQueueApi];
}

-(void)goToCurrentPositionScreen:(NSDictionary*)userInfoDic{
  
  [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
  CurrentPositionViewController *currentPosition = (CurrentPositionViewController*)[self.storyboard instantiateViewControllerWithIdentifier:@"CurrentPosition"];
  currentPosition.lineInfoDictionary=self.lineInfoDictionary;
  currentPosition.userInfoDictionary=userInfoDic;
  SlideRigthCustomSegue *segue = [[SlideRigthCustomSegue alloc] initWithIdentifier:@"SlideRigthSegue" source:self destination:currentPosition];
  [segue presentWithDismissPerformAnimated:YES];
  segue = nil;
  
  self.quitLineButton.enabled=YES;
  self.quitLineButtonView.userInteractionEnabled=YES;
  
}

-(void)callJoinQueueApi{
  
  [[AFNetworkReachabilityManager sharedManager] startMonitoring];
  [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
    
    if (status == AFNetworkReachabilityStatusReachableViaWWAN || status ==AFNetworkReachabilityStatusReachableViaWiFi) {
      
      [self.api joinQueue: @{@"token":[self getToken], @"queue_id":[self getLineId],@"party_size":[NSNumber numberWithInteger:self.count]} success:^(AFHTTPRequestOperation *task, id responseObject) {
        
        [self goToCurrentPositionScreen:responseObject];
        

        
      } failure:^(AFHTTPRequestOperation *task, NSError *error) {
        
      
        UIAlertView * alert =[[UIAlertView alloc ] initWithTitle:@"Cannot Join this queue"
                                                         message:@"You must have already join the queue. Click OK to go back"
                                                        delegate:self
                                               cancelButtonTitle:@"Cancel"
                                               otherButtonTitles: nil];
        [alert addButtonWithTitle:@"Ok"];
        [alert show];
        
        [UIApplication sharedApplication].networkActivityIndicatorVisible =NO;
        self.joinLineButton.enabled=YES;
        self.quitLineButton.enabled=YES;
        self.quitLineButtonView.userInteractionEnabled=YES;

        
        }];
    }else{
 //     NSLog(@"Reachability: %@",AFStringFromNetworkReachabilityStatus(status));
      self.joinLineButton.enabled=YES;
      UIAlertView * alert =[[UIAlertView alloc ] initWithTitle:@"No internet Connection"
                                                       message:@""
                                                      delegate:self
                                             cancelButtonTitle:@"Ok"
                                             otherButtonTitles: nil];
      [alert show];

    }
  }];

 }
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
//  NSLog(@"Button Index =%ld",(long)buttonIndex);
  if (buttonIndex == 0)
  {
   
//    NSLog(@"You have clicked Cancel");
  }
  else if(buttonIndex == 1)
  {
 //   NSLog(@"You have clicked Ok");
    [self goToLookForQueueScreen];
  }
}

#pragma mark- Navigation

-(void)goToQuitLineScreen{
  [self performSegueWithIdentifier:@"JoinQueueWithCounterToQuitLineSegue" sender:nil];
}

-(void)goToLookForQueueScreen{
  
  LookForQueueViewController *lookForQueue = (LookForQueueViewController*)[self.storyboard instantiateViewControllerWithIdentifier:@"LookForQueue"];
  SlideLeftCustomSegue *segue = [[SlideLeftCustomSegue alloc] initWithIdentifier:@"SlideLeftSegue" source:self destination:lookForQueue];
  [segue presentWithDismissPerformAnimated:YES];
}

-(IBAction)quitLineButtonTapped:(id)sender{
  [self goToLookForQueueScreen];
  //[self performSegueWithIdentifier:@"JoinQueueWithCounterToQuitLineSegue" sender:sender];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
  if ([segue.identifier isEqualToString:@"JoinQueueWithCounterToQuitLineSegue"]) {
    QuitLineViewController *destinationVC = (QuitLineViewController*)[segue destinationViewController];
    destinationVC.lineInfoDictionary=self.lineInfoDictionary;
    destinationVC.identifierName = @"QuitLineToJoinQueueWithCounterSegue";
  }
}

/* // Removing the line name from array..
 NSMutableArray *lineNameArray=[[NSMutableArray alloc] init];
 lineNameArray=[self.vqDefaults objectForKey:@"lineNameArray"];
 
 NSString *line_name = [NSString stringWithFormat:@"%@",[self.lineInfoDictionary valueForKey:@"name"]];
 if (![lineNameArray containsObject:line_name]) {
 [lineNameArray removeObject:line_name];
 [self.vqDefaults setObject:lineNameArray forKey:@"lineNameArray"];
 [self.vqDefaults synchronize];
 } */

@end
