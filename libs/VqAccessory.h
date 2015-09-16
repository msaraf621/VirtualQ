//
//  VqAccessory.h
//  VirtualQ
//
//  Created by GrepRuby on 30/07/14.
//  Copyright (c) 2014 optimalconsulting. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, AccessoryType){
  AccessoryTypeTypeArrowLeft,
  AccessoryTypeTypeArrowUp,
  AccessoryTypeTypeArrowRight,
  AccessoryTypeTypeArrowDown,
};


@interface VqAccessory : UIControl
{
	UIColor *_accessoryColor;
	UIColor *_highlightedColor;
  AccessoryType _accessoryType;
}

@property (nonatomic, strong) UIColor *accessoryColor;
@property (nonatomic, strong) UIColor *highlightedColor;
@property (nonatomic) AccessoryType accessoryType;

+ (VqAccessory *)accessoryWithColor:(UIColor *)color;
- (void)updateAccessoryType:(AccessoryType)type;
@end
