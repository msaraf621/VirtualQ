//
//  VQWaiters.m
//  VirtualQ
//
//  Created by GrepRuby on 11/08/14.
//  Copyright (c) 2014 optimalconsulting. All rights reserved.
//

#import "VQWaiters.h"


@implementation VQWaiters

@dynamic group_name;
@dynamic waiters_id;
@dynamic party_size;
@dynamic wait_time;
@dynamic position;
@dynamic user_id;
@dynamic line_size;
@dynamic line_name;
@dynamic location;

+(id)findOrCreateByID:(id)anID inContext:(NSManagedObjectContext*)localContext {
  
  VQWaiters *obj=[VQWaiters findFirstByAttribute:@"user_id" withValue:anID inContext:localContext];
  if (!obj) {
    obj = [VQWaiters createInContext:localContext];
  }
  return obj;
}

+(void)entityFromArray:(NSArray *)aArray inContext:(NSManagedObjectContext *)localContext {
  for(NSDictionary *aDictionary in aArray) {
    [VQWaiters entityFromDictionary:aDictionary inContext:localContext];
  }
}

+(id)entityFromDictionary:(NSDictionary *)aDictionary inContext:(NSManagedObjectContext *)localContext {
  VQWaiters *obj = (VQWaiters*)[self findOrCreateByID:[aDictionary objectForKey:@"user_id"] inContext:localContext];
  obj.line_name = [aDictionary objectForKey:@"line_name"];
  obj.location = [aDictionary valueForKey:@"location"];
  obj.line_size=[aDictionary valueForKey:@"line_size"] ;
  obj.waiters_id=[aDictionary objectForKey:@"id"];
  obj.user_id= NULL_TO_NIL([aDictionary valueForKey:@"user_id"]);
  obj.party_size= NULL_TO_NIL([aDictionary valueForKey:@"party_size"]);
  obj.wait_time=NULL_TO_NIL([aDictionary valueForKey:@"wait_time"]);
  obj.position=NULL_TO_NIL([aDictionary valueForKey:@"position"]);
  obj.group_name=[aDictionary valueForKey:@"group_name"];
  return obj;
}


@end
