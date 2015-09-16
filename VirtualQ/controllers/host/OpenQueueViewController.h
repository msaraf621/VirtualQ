//
//  OpenQueueViewController.h
//  VirtualQ
//
//  Created by GrepRuby on 04/07/14.
//  Copyright (c) 2014 optimalconsulting. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GCPlaceholderTextView.h"
#import "M13Checkbox.h"
#import "BaseController.h"

@interface OpenQueueViewController : BaseController  <UIScrollViewDelegate, UITextFieldDelegate , UITextViewDelegate>

@property (nonatomic,strong) NSString *identifierName;
@property (nonatomic,strong) NSMutableDictionary *storeDataDictionary;

@end
