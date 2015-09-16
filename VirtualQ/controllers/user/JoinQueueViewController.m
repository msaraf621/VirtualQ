//
//  JoinQueueViewController.m
//  VirtualQ
//
//  Created by GrepRuby on 05/07/14.
//  Copyright (c) 2014 optimalconsulting. All rights reserved.
//

#import "JoinQueueViewController.h"
#import "QuitLineViewController.h"
#import "CurrentPositionViewController.h"
#import "SlideRigthCustomSegue.h"

@interface JoinQueueViewController (){
  }

@end

@implementation JoinQueueViewController

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
  
  UITapGestureRecognizer *singleFingerTap = [[UITapGestureRecognizer alloc] initWithTarget:self action: @selector(goToQuitLineScreen)];
  [self.quitLineButtonView addGestureRecognizer:singleFingerTap];

	// Do any additional setup after loading the view.
}

-(void)callApi{

  [self.api getLineById:@{@"lineId":[self getLineId]} success:^(AFHTTPRequestOperation *task, id responseObject) {
    
    self.lineInfoDictionary=responseObject;
    [self changeLabels];
    
  } failure:^(AFHTTPRequestOperation *task, NSError *error) {
    
  }];
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
    NSString *restaurantName=[NSString stringWithFormat:@"%@",[self.lineInfoDictionary valueForKey:@"name"]];
    //NSString *address=[NSString stringWithFormat:@"%@",[self.lineInfoDictionary valueForKey:@"location"]];
    NSString *shortDesc=[NSString stringWithFormat:@"%@",[self.lineInfoDictionary valueForKey:@"info"]];
    if([self.lineInfoDictionary valueForKey:@"info"]==[NSNull null] || [shortDesc isEqualToString:@"(null)"]){
        shortDesc=[NSString stringWithFormat:@"No Information"];
        [self.shortDescriptionLabel setText:shortDesc];
    }else{
        [self.shortDescriptionLabel setText:shortDesc];
        
    }
    [self.nameAndAddressLabel setAttributedText:[self setAttributedText:restaurantName withAddress:[self getAddress:[self.lineInfoDictionary valueForKey:@"location"]]]];
    
}

-(void)applyDefaultStyles{
  
  //Join Button
  self.joinLineButton.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
  self.joinLineButton.titleLabel.textAlignment = NSTextAlignmentCenter;
  self.joinLineButton.titleLabel.font=[UIFont vqOpenLineBubbleFont];
  [self.joinLineButton setBackgroundColor:[UIColor vqBubbleColor]];
  NSString *joinLineStr=[NSString stringWithFormat:@"Join\nline"];
  [self.joinLineButton setTitle:joinLineStr forState: UIControlStateNormal];
  
  //Quit Line Button
  [self.quitLineButton setBackgroundColor:[UIColor vqCounterViewColor]];
  
  //Address & Name Label
  [self changeLabels];
//  [self.nameAndAddressLabel setAttributedText:[self setAttributedText:self.restaurantName withAddress:self.address]];

  [self.shortDescriptionLabel setFont:[UIFont vqShortDescInJoinQueueFont]];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)callJoinQueueApi{
  
  self.joinLineButton.enabled=NO;
  [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
  [self.api joinQueue: @{@"token":[self getToken], @"queue_id":[self getLineId]} success:^(AFHTTPRequestOperation *task, id responseObject) {
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    CurrentPositionViewController *currentPosition = (CurrentPositionViewController*)[self.storyboard instantiateViewControllerWithIdentifier:@"CurrentPosition"];
    currentPosition.lineInfoDictionary=self.lineInfoDictionary;
    currentPosition.userInfoDictionary=responseObject;
    SlideRigthCustomSegue *segue = [[SlideRigthCustomSegue alloc] initWithIdentifier:@"SlideRigthSegue" source:self destination:currentPosition];
    [segue presentPerformAnimated:YES];
    segue = nil;

  } failure:^(AFHTTPRequestOperation *task, NSError *error) {
    self.joinLineButton.enabled=YES;
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
   }];
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

-(void)goToQuitLineScreen{
  [self performSegueWithIdentifier:@"JoinQueueToQuitLineSegue" sender:nil];
}

-(IBAction)quitLineButtonTapped:(id)sender{
  [self performSegueWithIdentifier:@"JoinQueueToQuitLineSegue" sender:sender];
  
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
  
  if([segue.identifier isEqualToString:@"JoinQueueToQuitLineSegue"]){
    QuitLineViewController *destinationVC = (QuitLineViewController*)[segue destinationViewController];
    destinationVC.identifierName = @"QuitLineToJoinQueueSegue";
    destinationVC.lineInfoDictionary=self.lineInfoDictionary;
    
  }
  
}

-(IBAction)joinLineButtonTapped:(id)sender{
  
  [self callJoinQueueApi];
  
}



@end
