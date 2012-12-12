//
//  KMweightDataManager.h
//  dietHelper
//
//  Created by KoujiMiura on 2012/12/10.
//  Copyright (c) 2012年 KoujiMiura. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "WeightData.h"

@interface KMweightDataManager : NSObject
{
  NSManagedObjectContext* _managedObjectContext;
}

@property (nonatomic, readonly)NSManagedObjectContext* managedObjectContext;
+ (KMweightDataManager*)sharedManager;
- (WeightData*)insertNewWeightData;
- (WeightData*)lastWeightData;
- (WeightData*)compareWeightData;
- (NSArray*)sortedWeightData;
- (void)save;

@end
