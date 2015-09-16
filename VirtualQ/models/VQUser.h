//
//  VQUser.h
//  VirtualQ
//
//  Created by GrepRuby on 07/08/14.
//  Copyright (c) 2014 optimalconsulting. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface VQUser : NSManagedObject

@property (nonatomic, retain) NSString * token;
@property (nonatomic, retain) NSNumber * isCurrentUser;

@end
