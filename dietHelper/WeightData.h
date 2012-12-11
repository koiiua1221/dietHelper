//
//  WeightData.h
//  dietHelper
//
//  Created by KoujiMiura on 2012/12/10.
//  Copyright (c) 2012年 KoujiMiura. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface WeightData : NSManagedObject

@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) NSString * weight100;
@property (nonatomic, retain) NSString * weight010;
@property (nonatomic, retain) NSString * weight001;
@property (nonatomic, retain) NSString * weight000_1;

@end
