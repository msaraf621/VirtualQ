//
//  BaseController.h
//  VirtualQ
//
//  Created by GrepRuby on 03/07/14.
//  Copyright (c) 2014 optimalconsulting. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BaseController : UIViewController <CLLocationManagerDelegate>

@property NSArray * arrayOfLanguages;

@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic,strong) NSString *token;
@property (nonatomic, strong) AppApi *api;
@property (nonatomic, strong) AppApi *apiWithAuthentication;
@property (nonatomic,strong) CLLocationManager* locationManager;
@property (nonatomic,strong) NSUserDefaults *vqDefaults;



-(NSString*)getDeviceUDID;
-(NSNumber*)getLineId;
-(NSString*)getToken;
-(CLLocation*)getCurrentLocation;

-(NSAttributedString*)setAttributedText:(NSString*)restaurantName withAddress:(NSString*)address;
-(NSAttributedString*)setAttributedTextForWaitingName:(NSString*)extraText withText:(NSString*)userName;
-(NSAttributedString*)setAttributedTextForCurrentPosition:(NSString*)currentPosition withText:(NSString*)positionText;
-(NSAttributedString*)setAttributedTextForAnyWait;
-(NSAttributedString*)setAttributedTextYouAreUp;
-(NSAttributedString*)setAttributedVirtualQ;

- (void) receiveLanguageChangedNotification:(NSNotification *) notification;
-(void)configureViewFromLocalisation;

-(void)commonInit;
-(void)defaultStyle;
-(void)refreshData;
-(void)reloadData;
-(BOOL)isFetchedDataEmpty;

@end
