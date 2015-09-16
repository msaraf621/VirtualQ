//
//  QuitLineViewController.h
//  VirtualQ
//
//  Created by GrepRuby on 14/07/14.
//  Copyright (c) 2014 optimalconsulting. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseController.h"

@interface QuitLineViewController : BaseController

@property (nonatomic,strong) IBOutlet UIButton *yesButton;
@property (nonatomic,strong) IBOutlet UIButton *noButton;
@property (nonatomic,strong) IBOutlet UILabel *nameAndAddressLabel;
@property (nonatomic,strong) NSString *identifierName;
@property (nonatomic,strong) IBOutlet UILabel *quitLineLabel;
@property (nonatomic,strong) NSDictionary *userInfoDictionary;
@property (nonatomic,strong) NSDictionary *lineInfoDictionary;
@property (nonatomic,strong) NSNumber *position;
@end
