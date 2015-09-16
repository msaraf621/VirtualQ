//
//  OpenQueueViewController.m
//  VirtualQ
//
//  Created by GrepRuby on 04/07/14.
//  Copyright (c) 2014 optimalconsulting. All rights reserved.
//

#import "OpenQueueViewController.h"
#import "LookForQueueViewController.h"
#import "OpenQueueWithCurrentLocationViewController.h"
#import "ManageQueueViewController.h"
#import "M13Checkbox.h"
#import "SlideRigthCustomSegue.h"
#import "SlideLeftCustomSegue.h"

@interface OpenQueueViewController (){

}

@property (nonatomic,strong) IBOutlet UIButton *openLineButton;
@property (nonatomic,strong) IBOutlet UIButton *quitManageQueueButton;
@property (nonatomic,strong) IBOutlet UIView *lookForQueueButtonView;

@property (nonatomic,strong) IBOutlet UITextField *lineName;

@property (nonatomic,strong) IBOutlet UILabel *titleLable;
@property (nonatomic,strong) IBOutlet UILabel *currentLocationTitleLabel;
@property (nonatomic,strong) IBOutlet UILabel *lineUpUserTitleLabel;


@property (nonatomic,strong) IBOutlet GCPlaceholderTextView *shortDesc;

@property (nonatomic,strong) M13Checkbox *lineUpCheckBox;
@property (nonatomic,strong) M13Checkbox *currentLocationCheckBox;


@end

@implementation OpenQueueViewController

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
  // Do any additional setup after loading the view.
  
  [self createSession];
  [self applyDefaultStyles];
  [self initLocalization];
  
}

-(void)createSession{
  
  
  NSLog(@"Open Queue --- %@",[self class]);

  if ([self.vqDefaults valueForKey:@"token"]==nil) {

    self.openLineButton.enabled=NO;
    
    [self.api createSession:@{@"deviceID": [self getDeviceUDID]} success:^(AFHTTPRequestOperation *task, id responseObject) {
      NSLog(@"Open Queue");

        self.openLineButton.enabled=YES;
      
    } failure:^(AFHTTPRequestOperation *task, NSError *error) {
      
      [self performSelector:@selector(createSession) withObject:nil afterDelay:0];
    }];
  }
  
}


-(void)applyDefaultStyles{
  
  //Initialization of NSUserDefault
  
  // Line Up CheckBox
  self.lineUpCheckBox = [[M13Checkbox alloc] init];
  self.lineUpCheckBox.tintColor=[UIColor vqBubbleColor];
  self.lineUpCheckBox.radius = 5.0;
  self.lineUpCheckBox.checkColor=[UIColor blackColor];
  self.lineUpCheckBox.uncheckedColor=[UIColor vqBubbleColor];
  self.lineUpCheckBox.strokeColor=[UIColor vqBubbleColor];
  self.lineUpCheckBox.frame = CGRectMake(30, self.shortDesc.frame.origin.y + self.shortDesc.frame.size.height+UNI_VAL(30,15), 40, 40);
  [self.lineUpCheckBox addTarget:self action:@selector(checkChangedValueForLineUp:) forControlEvents:UIControlEventValueChanged];
//  [self.view addSubview: self.lineUpCheckBox];
  
  // Current Location Checkbox
  
  self.currentLocationCheckBox = [[M13Checkbox alloc] init];
  self.currentLocationCheckBox.tintColor=[UIColor vqBubbleColor];
  self.currentLocationCheckBox.radius = 40.0;
  self.currentLocationCheckBox.checkColor=[UIColor blackColor];
  self.currentLocationCheckBox.uncheckedColor=[UIColor vqBubbleColor];
  self.currentLocationCheckBox.strokeColor=[UIColor vqBubbleColor];
  //UNI_VAL(80, 50)
  self.currentLocationCheckBox.frame = CGRectMake(30, self.shortDesc.frame.origin.y + self.shortDesc.frame.size.height+UNI_VAL(30, 15), 40, 40);
  [self.currentLocationCheckBox addTarget:self action:@selector(checkChangedValueForCurrentLocation:) forControlEvents:UIControlEventValueChanged];
  [self.view addSubview:self.currentLocationCheckBox];
  
  //Color for TextField
  [self.lineName setBackgroundColor:[UIColor vqBubbleColor]];
  
  //Placeholder in TextField Color
  self.lineName.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Enter name of your line"  attributes:@{NSForegroundColorAttributeName:[UIColor vqPlaceholderTextColor]}];
  
  // Fonts for Text Field
  [self.lineName setFont:[UIFont vqTextFieldFont]];
  
  //UITextView : Short Description
  
  [self.shortDesc setBackgroundColor:[UIColor vqBubbleColor]];
  [self.shortDesc.layer setBorderWidth:2.0];
  [self.shortDesc.layer setBorderColor:[[UIColor vqBubbleColor] CGColor]];
  self.shortDesc.layer.cornerRadius = 5;
  self.shortDesc.clipsToBounds = YES;
  [self.shortDesc setFont:[UIFont vqTextFieldFont]];
  self.shortDesc.placeholderColor = [UIColor vqPlaceholderTextColor];
  self.shortDesc.placeholder = NSLocalizedString(@"Short Information about the venue",);
  
  //Title Lable at top- UILabel
  [self.titleLable setText:@"Open and Manage a Line"];
  self.titleLable.textColor=[UIColor vqOpenLineBubbleColor];
  self.titleLable.font=[UIFont vqOpenAndManageLineFont];
  
  //Current Location - UILabel
    UITapGestureRecognizer *currentLocationFingerTap = [[UITapGestureRecognizer alloc] initWithTarget:self action: @selector(currentLocationTitleLabelTap)];
  
  [self.currentLocationTitleLabel setText:@"use current location"];
  self.currentLocationTitleLabel.font=[UIFont vqCurrentLocationLabelFont];
  self.currentLocationTitleLabel.userInteractionEnabled = TRUE;
  [self.currentLocationTitleLabel addGestureRecognizer:currentLocationFingerTap];
    
  //Line Up User- UILabel
  [self.lineUpUserTitleLabel setText:@"one user can line up more people"];
  self.lineUpUserTitleLabel.font=[UIFont vqLineUpUserLabelFont];
  self.lineUpUserTitleLabel.hidden=YES;
  
  //Quit Manage Queue Button
  [self.quitManageQueueButton setBackgroundColor:[UIColor vqQuitQueueButtonColor]];

  // Open Line Button
  [self.openLineButton setBackgroundColor:[UIColor vqOpenLineBubbleColor]];
  self.openLineButton.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
  self.openLineButton.titleLabel.textAlignment = NSTextAlignmentCenter;
  self.openLineButton.titleLabel.font=[UIFont vqOpenLineBubbleFont];
  NSString *openLineStr=[NSString stringWithFormat:@"Open\nline"];
  [self.openLineButton setTitle:openLineStr forState: UIControlStateNormal];
  [self.openLineButton setTitleColor:[UIColor vqOpenLineBubbleTextColor]
                            forState:UIControlStateNormal];
  
  if([self.storeDataDictionary count]!=0){
    
    if([self.storeDataDictionary objectForKey:@"lineName"]!=NULL){
      [self.lineName setText:[self.storeDataDictionary objectForKey:@"lineName"]];
    }
    if([self.storeDataDictionary objectForKey:@"shortDescription"]!=NULL){
      [self.shortDesc setText:[self.storeDataDictionary objectForKey:@"shortDescription"]];
    }
    
    if([self.storeDataDictionary objectForKey:@"LineUpcheckBoxState"]){
      self.lineUpCheckBox.checkState=1;
    }
    
  }
  
  UITapGestureRecognizer *singleFingerTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(goToLookForQueueScreen)];
  [self.lookForQueueButtonView addGestureRecognizer:singleFingerTap];
  
}

-(void)currentLocationTitleLabelTap{
    if(self.currentLocationCheckBox.checkState == M13CheckboxStateChecked){
        self.currentLocationCheckBox.checkState = M13CheckboxStateUnchecked;
    }else{
        self.currentLocationCheckBox.checkState = M13CheckboxStateChecked;
    }
}

-(void)viewDidDisappear:(BOOL)animated{

}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - Return Key for KeyBoard

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
  if(textField==self.lineName)
  {
    [self.lineName resignFirstResponder];
    return NO;
  }
  
  return YES;
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
  
  UITouch *touch = [[event allTouches] anyObject];
  if ([self.lineName isFirstResponder] && [touch view] != self.lineName) {
    [self.lineName resignFirstResponder];
  }
  
  if ([self.shortDesc isFirstResponder] && [touch view] != self.shortDesc) {
    [self.shortDesc resignFirstResponder];
  }
  
  [super touchesBegan:touches withEvent:event];
}

#pragma mark - Setting character limit in UITextField

- (BOOL)textField:(UITextField *) textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
  
  NSString *text = textField.text;
  text = [text stringByReplacingCharactersInRange:range withString:string];
  CGSize textSize = [text sizeWithAttributes:@{NSFontAttributeName:textField.font}];
  return (textSize.width< textField.bounds.size.width-15) ? YES : NO;

}

#pragma mark- Limit number of lines

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
  
  // limit the number of lines in textview
  NSString* newText = [textView.text stringByReplacingCharactersInRange:range withString:text];
  
  // pretend there's more vertical space to get that extra line to check on
  CGSize tallerSize = CGSizeMake(textView.frame.size.width-10, textView.frame.size.height*2);
 
  CGRect newSize = [newText boundingRectWithSize:tallerSize
                                           options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading)
                                       attributes:@{NSFontAttributeName:textView.font}
                                           context:nil];
 // CGSize newSize = [newText sizeWithFont:textView.font constrainedToSize:tallerSize lineBreakMode:NSLineBreakByWordWrapping];
  
  if (newSize.size.height > textView.frame.size.height)
  {
 //   NSLog(@"two lines are full");
    return NO;
  }
  
  // dismiss keyboard
  if([text isEqualToString:@"\n"]) {
    [textView resignFirstResponder];
    
    return NO;
  }
  
  return YES;
}

- (void)checkChangedValueForLineUp:(id)sender
{
  if(self.lineUpCheckBox.checkState){
    
  }
//  NSLog(@"Changed Value:%u",self.lineUpCheckBox.checkState);
}

- (void)checkChangedValueForCurrentLocation:(id)sender
{
 // NSLog(@"Changed Value:%u",self.currentLocationCheckBox.checkState);
}

-(void)setNavigation:(UIViewController*)destinatonView withIdentifier:(NSString*)identifier withAnimationType:(NSString*)animationType{
  
  UIViewController *destinationViewController = (UIViewController *)destinatonView;
  if([animationType isEqualToString:@"SlideLeft"]){
    SlideLeftCustomSegue *segue = [[SlideLeftCustomSegue alloc] initWithIdentifier:@"SlideLeftSegue" source:self destination:destinationViewController];
    [segue perform];
    segue = nil;
  }
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
  self.titleLable.text=LOCALIZATION(@"openAndManageLine");
 // NSString *openLineStr=[NSString stringWithFormat:@"%@\n%@",LOCALIZATION(@"Open"),LOCALIZATION(@"line")];
 // [self.openLineButton setTitle:openLineStr forState: UIControlStateNormal];
 // [self.currentLocationTitleLabel setText:LOCALIZATION(@"useCurrentLocation")];
  [self.lineUpUserTitleLabel setText:LOCALIZATION(@"OneUserCanLineUpMorePeople")];
  self.lineName.attributedPlaceholder = [[NSAttributedString alloc] initWithString:LOCALIZATION(@"lineNamePlaceholder")  attributes:@{NSForegroundColorAttributeName:[UIColor vqPlaceholderTextColor]}];
  self.shortDesc.placeholder = NSLocalizedString(LOCALIZATION(@"shortDescPlaceholder"),);

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

-(void)goToLookForQueueScreen {
  
  LookForQueueViewController *lookForQueue = (LookForQueueViewController*)[self.storyboard instantiateViewControllerWithIdentifier:@"LookForQueue"];
   SlideRigthCustomSegue *segue = [[SlideRigthCustomSegue alloc] initWithIdentifier:@"SlideRigthSegue" source:self destination:lookForQueue];
    [segue presentWithDismissPerformAnimated:YES];
}

-(IBAction)openLineTapped:(id)sender{
  
  if([self.lineName.text length]==0){
    UIAlertView * alert =[[UIAlertView alloc ] initWithTitle:@"Please enter line name to open a virtual line."
                                                     message:@""
                                                    delegate:self
                                           cancelButtonTitle:@"Ok"
                                           otherButtonTitles: nil];
    [alert show];
    return;
  }
  
  if([self.shortDesc.text length]==0){
    
    UIAlertView * alert =[[UIAlertView alloc ] initWithTitle:@"Please enter short description to open a virtual line."
                                                     message:@""
                                                    delegate:self
                                           cancelButtonTitle:@"Ok"
                                           otherButtonTitles: nil];
    [alert show];
    return;
  }

  self.openLineButton.enabled=NO;
  self.quitManageQueueButton.enabled=NO;
  self.lookForQueueButtonView.userInteractionEnabled=NO;
  

  [[AFNetworkReachabilityManager sharedManager] startMonitoring];
  [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
    
    if (status == AFNetworkReachabilityStatusReachableViaWWAN || status ==AFNetworkReachabilityStatusReachableViaWiFi) {
      
      [self addingDictionary];
      }
    
    else{
  //  NSLog(@"Reachability: %@",AFStringFromNetworkReachabilityStatus(status));
    UIAlertView * alert =[[UIAlertView alloc ] initWithTitle:@"No internet Connection"
                                                       message:@"You cannot open a line"
                                                      delegate:self
                                             cancelButtonTitle:@"Ok"
                                             otherButtonTitles: nil];
      [alert show];
        self.openLineButton.enabled=NO;
        self.quitManageQueueButton.enabled=NO;
        self.lookForQueueButtonView.userInteractionEnabled=NO;


    }
  }];

  
}


-(void)addingDictionary{
  
 
  if(self.currentLocationCheckBox.checkState==0){
    
    self.storeDataDictionary=[[NSMutableDictionary alloc] init];
    
    if(self.lineName!=nil && self.lineName.text.length!=0){
      [self.storeDataDictionary setObject:self.lineName.text forKey:@"lineName"];
    }
    
    if(self.shortDesc!=nil &&  self.shortDesc.text.length!=0){
      [self.storeDataDictionary setObject:self.shortDesc.text forKey:@"shortDescription"];
    }
    if(self.lineUpCheckBox.checkState){
      [self.storeDataDictionary setObject:@"1" forKey:@"LineUpcheckBoxState"];
    }
    
    NSLog(@"%@",self.storeDataDictionary);
    
    // Go to open Queue
    OpenQueueWithCurrentLocationViewController *lookForQueueWithCurrentLoc = (OpenQueueWithCurrentLocationViewController*)[self.storyboard instantiateViewControllerWithIdentifier:@"OpenQueueWithCurrentLocation"];
    lookForQueueWithCurrentLoc.storeDataDictionary=self.storeDataDictionary;
    SlideLeftCustomSegue *segue = [[SlideLeftCustomSegue alloc]  initWithIdentifier:@"SlideLeftSegue" source:self destination:lookForQueueWithCurrentLoc];
    [segue presentWithDismissPerformAnimated:YES];
    segue = nil;
    
  } else{
    
    NSMutableDictionary *param=[[NSMutableDictionary alloc] init];
    
    if(self.shortDesc!=nil&&self.shortDesc.text.length!=0){
      [param setObject:self.shortDesc.text forKey:@"info"];
    }
    [param setObject:self.lineName.text forKey:@"name"];
    [param setObject:[self getToken] forKey:@"token"];
    [param setObject:[self.vqDefaults objectForKey:@"latitude"] forKey:@"latitude"];
    [param setObject:[self.vqDefaults objectForKey:@"longitude"] forKey:@"longitude"];
    
    //[AppApi openQueue:param];
    [self callApi:param];
    
  }

}

-(void)callApi:(NSDictionary*)param{
  
  [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;

   [self.api openQueue:param success:^(AFHTTPRequestOperation *task, id responseObject) {
      // Navigate to manage Queue
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        [self goToManageQueueScreen:responseObject];
        [self setEnabledYes];
      } failure:^(AFHTTPRequestOperation *task, NSError *error) {
        
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        [self setEnabledYes];
      
      }];
}

-(IBAction)minusButtonTapped:(id)sender{
  [self goToLookForQueueScreen];
}

-(void)goToManageQueueScreen:(NSDictionary*)lineInfoDic{
  ManageQueueViewController *manageQueue = (ManageQueueViewController*)[self.storyboard instantiateViewControllerWithIdentifier:@"ManageQueue"];
  manageQueue.lineInfoDic=lineInfoDic;
  SlideLeftCustomSegue *segue = [[SlideLeftCustomSegue alloc] initWithIdentifier:@"SlideLeftSegue" source:self destination:manageQueue];
  [segue presentPerformAnimated:YES];
  segue = nil;
}

-(void)setEnabledYes{
  self.openLineButton.enabled=YES;
  self.quitManageQueueButton.enabled=YES;
  self.lookForQueueButtonView.userInteractionEnabled=YES;
}

  @end
