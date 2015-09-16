//
//  BaseModels.h
//  VirtualQ
//
//  Created by GrepRuby on 03/07/14.
//  Copyright (c) 2014 optimalconsulting. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BaseModels : NSObject


@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;

+ (void)createObj:(NSDictionary *)params;
- (void)updateObj:(NSDictionary *)params;
- (void)deleteObj;


@end
