//
//  QuitQueueViewController.m
//  VirtualQ
//
//  Created by GrepRuby on 05/07/14.
//  Copyright (c) 2014 optimalconsulting. All rights reserved.
//

#import "QuitQueueViewController.h"
#import "OpeningScreenViewController.h"
#import "ThankYouViewController.h"
#import "ManageQueueViewController.h"
#import "SlideLeftCustomSegue.h"

@interface QuitQueueViewController (){
  
}
@property (nonatomic,strong) IBOutlet UIButton *yesButton;
@property (nonatomic,strong) IBOutlet UIButton *noButton;
@property (nonatomic,strong) IBOutlet UILabel *nameAndAddressLabel;
@property (nonatomic,strong) IBOutlet UILabel *quitQueueLabel;

@end

@implementation QuitQueueViewController

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
	// Do any additional setup after loading the view.
}


-(void)applyDefaultStyles{
  
  @autoreleasepool {
    
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
    if ([self.lineInfoDic valueForKey:@"location"]==nil) {
      [self.nameAndAddressLabel setAttributedText:[self setAttributedText:[self.lineInfoDic valueForKey:@"name"] withAddress:@"  "]];
    }
      else{[self.nameAndAddressLabel setAttributedText:[self setAttributedText:[self.lineInfoDic valueForKey:@"name"] withAddress:[self.lineInfoDic valueForKey:@"location"]]];
  
       }
  
  //Quit Queue Label
  [self.quitQueueLabel setText:@"Do you want to quit your managed queue?"];
  [self.quitQueueLabel setFont:[UIFont vqQuitLineOrQueueFont]];
  }

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidDisappear:(BOOL)animated{
  
  [[NSNotificationCenter defaultCenter] removeObserver:self name:kNotificationLanguageChanged object:nil];
  [[AFNetworkReachabilityManager sharedManager] stopMonitoring];

}

#pragma  mark - Navigation Method 

-(IBAction)yesButtonTapped:(id)sender{
  
  [[AFNetworkReachabilityManager sharedManager] startMonitoring];
  [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
    
    if (status == AFNetworkReachabilityStatusReachableViaWWAN || status ==AFNetworkReachabilityStatusReachableViaWiFi) {
      
      [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
      self.yesButton.enabled=NO;
      self.noButton.enabled=NO;
      
      [self.api closeQueue:@{@"lineId":[self getLineId],@"token":[self getToken]} success:^(AFHTTPRequestOperation *task, id responseObject) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        [self goToFBLikePage];
      } failure:^(AFHTTPRequestOperation *task, NSError *error) {
        self.yesButton.enabled=YES;
        self.noButton.enabled=YES;
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        UIAlertView * alert =[[UIAlertView alloc ] initWithTitle:@"Error"
                                                         message:@"Cannot close this line."
                                                        delegate:self
                                               cancelButtonTitle:@"Ok"
                                               otherButtonTitles: nil];
        [alert show];

      }];

    }else{
    NSLog(@"Reachability: %@",AFStringFromNetworkReachabilityStatus(status));
      UIAlertView * alert =[[UIAlertView alloc ] initWithTitle:@"No internet Connection"
                                                       message:@""
                                                      delegate:self
                                             cancelButtonTitle:@"Ok"
                                             otherButtonTitles: nil];
      [alert show];

    }
  }];

}

-(IBAction)noButonTapped:(id)sender{
  [self goToManageQueueScreen];
}

-(void)goToManageQueueScreen{
  ManageQueueViewController *manageQueue = (ManageQueueViewController*)[self.storyboard instantiateViewControllerWithIdentifier:@"ManageQueue"];
  manageQueue.lineInfoDic=self.lineInfoDic;
  manageQueue.identifierName=@"QuitQueue";
  SlideLeftCustomSegue *segue = [[SlideLeftCustomSegue alloc] initWithIdentifier:@"SlideLeftSegue" source:self destination:manageQueue];
  [segue presentWithDismissPerformAnimated:YES];
  segue = nil;
}

-(void)goToFBLikePage{
  
  ThankYouViewController *thankyouScreen = (ThankYouViewController*)[self.storyboard instantiateViewControllerWithIdentifier:@"ThankYouView"];
  SlideLeftCustomSegue *segue = [[SlideLeftCustomSegue alloc] initWithIdentifier:@"SlideLeftSegue" source:self destination:thankyouScreen];
  [segue presentWithDismissPerformAnimated:NO];

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
  @autoreleasepool {
  [self.noButton setTitle:LOCALIZATION(@"No") forState:UIControlStateNormal];
  [self.yesButton setTitle:LOCALIZATION(@"Yes") forState:UIControlStateNormal];
  [self.quitQueueLabel setText:LOCALIZATION(@"quitQueueLabel")];
  }
}

-(void)initLocalization{
  self.arrayOfLanguages = [[[Localisator sharedInstance] availableLanguagesArray] copy];
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(receiveLanguageChangedNotification:)
                                               name:kNotificationLanguageChanged
                                             object:nil];
  [self configureViewFromLocalisation];
  
}


@end
