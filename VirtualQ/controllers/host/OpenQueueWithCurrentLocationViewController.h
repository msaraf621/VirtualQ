//
//  OpenQueueWithCurrentLocationViewController.h
//  VirtualQ
//
//  Created by GrepRuby on 29/07/14.
//  Copyright (c) 2014 optimalconsulting. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseController.h"


@interface OpenQueueWithCurrentLocationViewController : BaseController

@property (nonatomic,strong) IBOutlet UIButton *openLineButton;
@property (nonatomic,strong) IBOutlet UIButton *quitManageQueueButton;
@property (nonatomic,strong) IBOutlet UIView *OpenQueueButtonView;

@property (nonatomic,strong) IBOutlet UITextField *streetName;
@property (nonatomic,strong) IBOutlet UITextField *streetNumber;
@property (nonatomic,strong) IBOutlet UITextField *cityName;
@property (nonatomic,strong) IBOutlet UITextField *zipCode;
@property (nonatomic,strong) IBOutlet UITextField *countryName;
@property (nonatomic,strong) IBOutlet UILabel *titleLable;
@property (nonatomic,strong) NSMutableDictionary *storeDataDictionary;
@property (nonatomic,strong) NSArray *cityNameArray;

@end
