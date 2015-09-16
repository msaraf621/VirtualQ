//
//  PushUpNotification1ViewController.h
//  VirtualQ
//
//  Created by GrepRuby on 01/08/14.
//  Copyright (c) 2014 optimalconsulting. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseController.h"

@interface PushUpNotificationViewController : BaseController

@property (nonatomic,strong) IBOutlet UIView *mainView;
@property (nonatomic,strong) IBOutlet UIView *topView;

@property (nonatomic,strong) IBOutlet UIButton *currentPositionButton;
@property (nonatomic,strong) IBOutlet UILabel *explanationLabel;
@property (nonatomic,strong) IBOutlet UILabel *nameAndAddressLabel;
@property (nonatomic,strong) IBOutlet UILabel *userWaitingNameLabel;
@property (nonatomic,strong) IBOutlet UILabel *currentPositionLabel;
@property (nonatomic,strong) NSDictionary *userInfoDictionary;
@property (nonatomic,strong) NSString *identifierName;

@property (nonatomic,strong) IBOutlet UIView *quitLineButtonView;
@property (nonatomic,strong) IBOutlet UIButton *quitLineButton;

@end
