//
//  VQLine.m
//  VirtualQ
//
//  Created by GrepRuby on 07/08/14.
//  Copyright (c) 2014 optimalconsulting. All rights reserved.
//

#import "VQLine.h"


@implementation VQLine

@dynamic line_id;
@dynamic user_id;
@dynamic info;
@dynamic latitude;
@dynamic longitude;
@dynamic line_size;
@dynamic location;
@dynamic distance;
@dynamic name;
@dynamic open;
@dynamic flag;

+(id)findOrCreateByID:(id)anID inContext:(NSManagedObjectContext*)localContext {
 
  VQLine *obj=[VQLine findFirstByAttribute:@"line_id" withValue:anID inContext:localContext];
  
  if (!obj && obj.flag==0) {
    obj = [VQLine createInContext:localContext];
    obj.flag=true;
  }
  
  
  return obj;
}

+(void)entityFromArray:(NSArray *)aArray inContext:(NSManagedObjectContext *)localContext {
  NSMutableArray *lineIds = [[NSMutableArray alloc] init];
  for(NSDictionary *aDictionary in aArray) {
    [VQLine entityFromDictionary:aDictionary inContext:localContext];
    [lineIds addObject:[aDictionary valueForKey:@"id"]];
  }
 //NSArray *allLines= [VQLine findAll];
  NSArray *deactiveLines = [VQLine findAllWithPredicate:[NSPredicate predicateWithFormat:@"NOT (line_id IN %@)",lineIds]];
  for (VQLine *line in deactiveLines) {
    [line deleteEntity];
  }
  
  
}

+(id)entityFromDictionary:(NSDictionary *)aDictionary inContext:(NSManagedObjectContext *)localContext {
  VQLine *obj = (VQLine*)[self findOrCreateByID:[aDictionary objectForKey:@"id"] inContext:localContext];
  obj.name = [aDictionary objectForKey:@"name"];
  obj.location = [aDictionary valueForKey:@"location"];
  obj.line_size=[aDictionary valueForKey:@"line_size"] ;
  obj.distance=[NSNumber numberWithDouble:[[aDictionary objectForKey:@"distance"]  doubleValue]];
  obj.line_id=[aDictionary valueForKey:@"id"];
 // NSLog(@"%@==== %@",obj.line_id,aDictionary);
  //NSLog(@"%@",[aDictionary objectForKey:@"latitude"]);
    
  obj.latitude=[NSNumber numberWithDouble:[NULL_TO_NIL([aDictionary objectForKey:@"latitude"])  doubleValue]];
  obj.longitude=[NSNumber numberWithDouble:[NULL_TO_NIL([aDictionary objectForKey:@"longitude"])  doubleValue]];

  obj.user_id=[aDictionary valueForKey:@"user_id"];
  obj.open =[NSNumber numberWithInteger:[[aDictionary objectForKey:@"open"] integerValue]];
  
  obj.info= NULL_TO_NIL([aDictionary valueForKey:@"info"]);
  return obj;
}

- (CLLocation *)computedLocation {
    return [[CLLocation alloc]initWithLatitude:self.latitude.floatValue longitude:self.longitude.floatValue];
}

@end
