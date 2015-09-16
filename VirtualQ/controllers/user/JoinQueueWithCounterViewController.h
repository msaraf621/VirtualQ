//
//  CountUserViewController.h
//  VirtualQ
//
//  Created by GrepRuby on 05/07/14.
//  Copyright (c) 2014 optimalconsulting. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseController.h"

@interface JoinQueueWithCounterViewController : BaseController

@property (nonatomic, strong) IBOutlet UIView *counterView;
@property (nonatomic, strong) IBOutlet APRoundedButton *increseaseCountButton;
@property (nonatomic, strong) IBOutlet APRoundedButton *decreseaseCountButton;
@property (nonatomic, strong) IBOutlet UIButton *joinLineButton;
@property (nonatomic, strong) IBOutlet UIButton *quitLineButton;

@property (nonatomic,strong) IBOutlet UILabel *nameAndAddressLabel;
@property (nonatomic,strong) IBOutlet UILabel *questionLabel;
@property (nonatomic,strong) IBOutlet UILabel *shortDescriptionLabel;
@property (nonatomic,strong) IBOutlet UILabel *numberOfPersonLabel;
@property (nonatomic,strong) NSDictionary *lineInfoDictionary;
@property (nonatomic,strong) NSString *restaurantName;
@property (nonatomic,strong) NSString *address;
@property (nonatomic,assign) NSInteger count;
@property (nonatomic,strong) IBOutlet UIView *quitLineButtonView;


@end
