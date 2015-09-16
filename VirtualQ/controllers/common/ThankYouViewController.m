//
//  ThankYouViewController.m
//  VirtualQ
//
//  Created by GrepRuby on 18/07/14.
//  Copyright (c) 2014 optimalconsulting. All rights reserved.
//

#import "ThankYouViewController.h"
#import "OpeningScreenViewController.h"
#import "SlideLeftCustomSegue.h"

#import <Social/Social.h>
#import <Twitter/Twitter.h>


@interface ThankYouViewController ()


@end

@implementation ThankYouViewController

//static NSString * const kClientId = @"570564466581-do5dd74ebl88kjaoppfand9802dcgcb5.apps.googleusercontent.com";


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
  [ self applyDefaultStyles];
  [self initLocalization];
  [self addNSNotificationObserver];
  
  
  UITapGestureRecognizer *singleFingerTap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                          action:@selector(handleSingleTap:)];
  [self.thankYouView addGestureRecognizer:singleFingerTap];
  
	// Do any additional setup after loading the view.
}

-(void)applyDefaultStyles{
  
  [self.bottomView setBackgroundColor:[UIColor vqThankYouScreenBottomViewColor]];
  [self.topView setBackgroundColor:[UIColor vqThankYouScreenTopViewColor]];
 
 //[self.anyWaitButton setTitle:@"virtualQ Home" forState:UIControlStateNormal];
  [self.anyWaitButton setAttributedTitle:[self setAttributedVirtualQ] forState:UIControlStateNormal];
//  [self.anyWaitButton.titleLabel setAttributedText:[self setAttributedVirtualQ]];
  [self.anyWaitButton setBackgroundColor:[UIColor vqThankYouScreenTopViewColor]];
  
  //Thank you label
  [self.thankYouLabel setTextColor:[UIColor vqTableViewTextColor]];
  [self.thankYouLabel setFont:[UIFont vqThankYouTextFont]];
  
  self.signInButton.hidden=YES;
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)anyWaitTapped:(id)sender{
  
  [self removeNSNotificationObserver];
  OpeningScreenViewController *openingScreen = (OpeningScreenViewController*)[self.storyboard instantiateViewControllerWithIdentifier:@"OpeningScreen"];
  openingScreen.identifierName=@"ThankYouViewController";
  SlideLeftCustomSegue *segue = [[SlideLeftCustomSegue alloc] initWithIdentifier:@"SlideLeftSegue" source:self destination:openingScreen];
  [segue presentWithDismissPerformAnimated:NO];
  segue = nil;

 // [self presentViewController:openingScreen animated:NO completion:nil];
}
/*
#pragma mark FBSessionDelegate

- (void)fbDidLogin {
	self.facebookLikeView.alpha = 1;
  [self.facebookLikeView load];
}

- (void)fbDidLogout {
	self.facebookLikeView.alpha = 1;
  [self.facebookLikeView load];
}

#pragma mark FacebookLikeViewDelegate

- (void)facebookLikeViewRequiresLogin:(FacebookLikeView *)aFacebookLikeView {
}

- (void)facebookLikeViewDidRender:(FacebookLikeView *)aFacebookLikeView {
  [UIView beginAnimations:@"" context:nil];
  [UIView setAnimationDelay:0.5];
  self.facebookLikeView.alpha = 1;
  [UIView commitAnimations];
}

- (void)facebookLikeViewDidLike:(FacebookLikeView *)aFacebookLikeView {
  UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Liked"
                                                  message:@"You liked VirtualQ"
                                                 delegate:self
                                        cancelButtonTitle:@"OK"
                                        otherButtonTitles:nil];
  [alert show];
}

- (void)facebookLikeViewDidUnlike:(FacebookLikeView *)aFacebookLikeView {
  UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Unliked"
                                                  message:@"You unliked VirtualQ"
                                                 delegate:self
                                        cancelButtonTitle:@"OK"
                                        otherButtonTitles:nil];
  [alert show];
}  */

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
  [self.thankYouLabel setText:LOCALIZATION(@"thankYouScreenText")];
}

-(void)initLocalization{
  self.arrayOfLanguages = [[[Localisator sharedInstance] availableLanguagesArray] copy];
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(receiveLanguageChangedNotification:)
                                               name:kNotificationLanguageChanged
                                             object:nil];
  [self configureViewFromLocalisation];
  
}
#pragma mark- Facebook 

/*
-(IBAction)facebookConnect:(id)sender{
  
  NSArray *permissions = [NSArray arrayWithObjects:@"email",@"publish_actions",@"user_likes",@"publish_stream", nil];
  
 
  [FBSession openActiveSessionWithReadPermissions:permissions allowLoginUI:YES completionHandler:^(FBSession *session,FBSessionState state, NSError *error)
   {
     if (error)
     {
       UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:error.localizedDescription delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
       [alertView show];
     }
     else if(session.isOpen)
     {

       
       FBLinkShareParams *params = [[FBLinkShareParams alloc] init];
       params.link = [NSURL URLWithString:@"https://developers.facebook.com/docs/ios/share/"];
       
       // If the Facebook app is installed and we can present the share dialog
       if ([FBDialogs canPresentShareDialogWithParams:params]) {
         // Present the share dialog
         [FBDialogs presentShareDialogWithLink:params.link
                                       handler:^(FBAppCall *call, NSDictionary *results, NSError *error) {
                                         if(error) {
                                           // An error occurred, we need to handle the error
                                           // See: https://developers.facebook.com/docs/ios/errors
                                           NSLog(@"Error publishing story: %@", error.description);
                                         } else {
                                           // Success
                                           NSLog(@"result %@", results);
                                         }
                                       }];
       } else {
         // Present the feed dialog
         NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                        @"Sharing Tutorial", @"name",
                                        @"Build great social apps and get more installs.", @"caption",
                                        @"Allow your users to share stories on Facebook from your app using the iOS SDK.", @"description",
                                        @"https://developers.facebook.com/docs/ios/share/", @"link",
                                        @"http://i.imgur.com/g3Qc1HN.png", @"picture",
                                        nil];
         
         
         // Invoke the dialog
         [FBWebDialogs presentFeedDialogModallyWithSession:nil
                                                parameters:params
                                                   handler:
          ^(FBWebDialogResult result, NSURL *resultURL, NSError *error) {
            if (error) {
              NSLog(@"Error publishing story.");
            } else {
              if (result == FBWebDialogResultDialogNotCompleted) {
                NSLog(@"User canceled story publishing.");
              } else {
                NSLog(@"Story published.");
              }
            }}];
       }
     
     
     }
     NSLog(@"%@",session);
     
   }];
  

} */

//The event handling method

- (void)handleSingleTap:(UITapGestureRecognizer *)recognizer {
  NSLog(@"Thank you view Tapped");
  
    
 // https://www.facebook.com/pages/A-to-Z-shop/1516966118516112
   NSURL *fanPageURL = [NSURL URLWithString:@"fb://profile/755543777805456"];
  
  if ([[UIApplication sharedApplication] canOpenURL: fanPageURL]){
    
    [[UIApplication sharedApplication] openURL: fanPageURL];
   }
  else{
    //fanPageURL failed to open.  Open the website in Safari instead
    NSURL *webURL = [NSURL URLWithString:@"https://www.facebook.com/pages/Virtual-Q/755543777805456"];
    [[UIApplication sharedApplication] openURL: webURL];
  
  }
  
  
/*  NSArray *permissions = [NSArray arrayWithObjects:@"email",@"publish_actions",@"user_likes", nil];

  [FBSession openActiveSessionWithReadPermissions:permissions allowLoginUI:YES completionHandler:^(FBSession *session,FBSessionState state, NSError *error)
   {
     if (error)
     {
       UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:error.localizedDescription delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
       [alertView show];
     }
     else if(session.isOpen)
     {
       NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                               @"http://samples.ogp.me/1516966118516112", @"object",
                               nil
                               ];
       NSString *urlToLikeFor=[NSString stringWithFormat:@"1516966118516112"];
       NSString *theWholeUrl = [NSString stringWithFormat:@"https://graph.facebook.com/me/og.likes?object=%@&access_token=%@", urlToLikeFor, FBSession.activeSession.accessTokenData];
           NSURL *facebookUrl = [NSURL URLWithString:theWholeUrl];
       
      NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:facebookUrl];
       [req setHTTPMethod:@"POST"];
       
       NSURLResponse *response;
       NSError *err;
       NSData *responseData = [NSURLConnection sendSynchronousRequest:req returningResponse:&response error:&err];
       NSString *content = [NSString stringWithUTF8String:[responseData bytes]];
       
       NSLog(@"responseData: %@", content);
       
       [FBRequestConnection startWithGraphPath:@"/1516966118516112/likes"
                                    parameters:nil
                                    HTTPMethod:@"POST"
                             completionHandler:^(
                                                 FBRequestConnection *connection,
                                                 id result,
                                                 NSError *error
                                                 ) {
                               NSLog(@"Error: %@",error);
                             }];
      }
   }];  */

}

-(void)removeNSNotificationObserver{
  
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidEnterBackgroundNotification object:nil];
}

-(void)addNSNotificationObserver{
  
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appDidEnterBackground:) name:UIApplicationDidEnterBackgroundNotification object:nil];
}


- (void)applicationDidEnterBackground:(UIApplication *)application
{
  NSLog(@"app Did Enter Background");
}

-(void)appDidEnterBackground:(NSNotification *)notification{
  
  if([self isKindOfClass:[ThankYouViewController class]]){
    NSLog(@"did enter background notification ThankYouViewController");
    exit(0);
    }else{
    NSLog(@"did enter background notification");
  }

}






#pragma mark- Twitter 
/*
- (IBAction)tweetTapped:(id)sender {
  if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter])
  {
    SLComposeViewController *tweetSheet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
    [tweetSheet setInitialText:@"Tweeting from my own app! :)"];
    [self presentViewController:tweetSheet animated:YES completion:nil];
  }
  else
  {
    UIAlertView *alertView = [[UIAlertView alloc]
                              initWithTitle:@"Sorry"
                              message:@"You can't send a tweet right now, make sure your device has an internet connection and you have at least one Twitter account setup"
                              delegate:self
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil];
    [alertView show];
  }
}

-(IBAction)followOnTwitter:(id)sender{
  ACAccountStore *accountStore = [[ACAccountStore alloc] init];
  
  ACAccountType *accountType = [accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
  
  [accountStore requestAccessToAccountsWithType:accountType withCompletionHandler:^(BOOL granted, NSError *error) {
    if(granted) {
      // Get the list of Twitter accounts.
      NSArray *accountsArray = [accountStore accountsWithAccountType:accountType];
      
      // For the sake of brevity, we'll assume there is only one Twitter account present.
      // You would ideally ask the user which account they want to tweet from, if there is more than one Twitter account present.
      if ([accountsArray count] > 0) {
        // Grab the initial Twitter account to tweet from.
        ACAccount *twitterAccount = [accountsArray objectAtIndex:0];
        
        NSMutableDictionary *tempDict = [[NSMutableDictionary alloc] init];
        [tempDict setValue:@"TechCrunch" forKey:@"screen_name"];
        [tempDict setValue:@"true" forKey:@"follow"];
        
        TWRequest *postRequest = [[TWRequest alloc] initWithURL:[NSURL URLWithString:@"https://api.twitter.com/1/friendships/create.json"]
                                                     parameters:tempDict
                                                  requestMethod:TWRequestMethodPOST];
        
        
        [postRequest setAccount:twitterAccount];
        
        [postRequest performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {
          NSString *output = [NSString stringWithFormat:@"HTTP response status: %i", [urlResponse statusCode]];
          NSLog(@"%@", output);
          
        }];
      }
    }
  }];
  
}  */

#pragma mark- Google Plus


/*
 - (void)finishedWithAuth: (GTMOAuth2Authentication *)auth
 error: (NSError *) error {
 NSLog(@"Received error %@ and auth object %@",error, auth);
 if (error) {
 // Do some error handling here.
 } else {
 [self refreshInterfaceBasedOnSignIn];
 }
 }
 
 - (void)presentSignInViewController:(UIViewController *)viewController {
 // This is an example of how you can implement it if your app is navigation-based.
 [[self navigationController] pushViewController:viewController animated:YES];
 }
 
 - (BOOL)application: (UIApplication *)application
 openURL: (NSURL *)url
 sourceApplication: (NSString *)sourceApplication
 annotation: (id)annotation {
 return [GPPURLHandler handleURL:url
 sourceApplication:sourceApplication
 annotation:annotation];
 }
 
 -(void)refreshInterfaceBasedOnSignIn {
 if ([[GPPSignIn sharedInstance] authentication]) {
 // The user is signed in.
 self.signInButton.hidden = YES;
 // Perform other actions here, such as showing a sign-out button
 } else {
 self.signInButton.hidden = NO;
 // Perform other actions here
 }
 }
 
 - (void)signOut {
 [[GPPSignIn sharedInstance] signOut];
 }
 
 - (void)disconnect {
 [[GPPSignIn sharedInstance] disconnect];
 }
 
 - (void)didDisconnectWithError:(NSError *)error {
 if (error) {
 NSLog(@"Received error %@", error);
 } else {
 // The user is signed out and disconnected.
 // Clean up user data as specified by the Google+ terms.
 }
 } */


@end
