//
//  KMweightDataManager.m
//  dietHelper
//
//  Created by KoujiMiura on 2012/12/10.
//  Copyright (c) 2012年 KoujiMiura. All rights reserved.
//

#import "KMweightDataManager.h"
#import "WeightData.h"

@implementation KMweightDataManager

static KMweightDataManager*  _sharedInstance = nil;

+ (KMweightDataManager*)sharedManager
{
  // インスタンスを作成する
  if (!_sharedInstance) {
    _sharedInstance = [[KMweightDataManager alloc] init];
  }
  
  return _sharedInstance;
}

-(NSManagedObjectContext*) managedObjectContext
{
  NSError*    error;

  if (_managedObjectContext) {
    return _managedObjectContext;
  }
  
  // 管理対象オブジェクトモデルの作成
  NSManagedObjectModel*   managedObjectModel;
  managedObjectModel = [NSManagedObjectModel mergedModelFromBundles:nil];
  
  // 永続ストアコーディネータの作成
  NSPersistentStoreCoordinator*   persistentStoreCoordinator;
  persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc]
                                initWithManagedObjectModel:managedObjectModel];
  
  // 保存ファイルの決定
  NSArray*    paths;
  NSString*   path = nil;
  paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
  if ([paths count] > 0) {
    path = [paths objectAtIndex:0];
    path = [path stringByAppendingPathComponent:@"weight"];
    path = [path stringByAppendingPathComponent:@"weight.db"];
  }
  
  if (!path) {
    return nil;
  }
  
  // ディレクトリの作成
  NSString*       dirPath;
  NSFileManager*  fileMgr;
  dirPath = [path stringByDeletingLastPathComponent];
  fileMgr = [NSFileManager defaultManager];
  if (![fileMgr fileExistsAtPath:dirPath]) {
    if (![fileMgr createDirectoryAtPath:dirPath
            withIntermediateDirectories:YES attributes:nil error:&error])
    {
      NSLog(@"Failed to create directory at path %@, erro %@",
            dirPath, [error localizedDescription]);
    }
  }
  
  // ストアURLの作成
  NSURL*  url = nil;
  url = [NSURL fileURLWithPath:path];
  
  // 永続ストアの追加
  NSPersistentStore*  persistentStore;
  persistentStore = [persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType
                                                             configuration:nil URL:url options:nil error:&error];
  if (!persistentStore && error) {
    NSLog(@"Failed to create add persitent store, %@", [error localizedDescription]);
  }
  
  // 管理対象オブジェクトコンテキストの作成
  _managedObjectContext = [[NSManagedObjectContext alloc] init];
  
  // 永続ストアコーディネータの設定
  [_managedObjectContext setPersistentStoreCoordinator:persistentStoreCoordinator];
  
  return _managedObjectContext;

}

- (NSMutableArray*)sortedWeightData
{
  // 管理対象オブジェクトコンテキストを取得する
  NSManagedObjectContext* context;
  context = self.managedObjectContext;
  
  // 取得要求を作成する
  NSFetchRequest*         request;
  NSEntityDescription*    entity;
  NSSortDescriptor*       sortDescriptor;
  request = [[NSFetchRequest alloc] init];
  entity = [NSEntityDescription entityForName:@"Weight" inManagedObjectContext:context];
  [request setEntity:entity];
  sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"date" ascending:YES];
  [request setSortDescriptors:[NSArray arrayWithObjects:sortDescriptor, nil]];
  
  // 取得要求を実行する
  NSMutableArray*    result;
  NSError*    error = nil;
  result = [[context executeFetchRequest:request error:&error] mutableCopy];
  if (!result) {
    // エラー
    NSLog(@"executeFetchRequest: failed, %@", [error localizedDescription]);
    
    return nil;
  }
  
  return result;
}

- (WeightData*)insertNewWeightData
{
  // 管理対象オブジェクトコンテキストを取得する
  NSManagedObjectContext* context;
  context = self.managedObjectContext;
  
  WeightData* weightData;
  weightData = [NSEntityDescription insertNewObjectForEntityForName:@"Weight"
                
                                          inManagedObjectContext:context];
  // インデックスを設定する
  NSArray*    sortedweightData;
  sortedweightData = self.sortedWeightData;
  if ([sortedweightData count] > 0) {
    // 最後のチャンネルを取得する
    WeightData* lastWeightData;
    lastWeightData = [sortedweightData lastObject];
    
  }
  
  return weightData;
}

- (WeightData*)lastWeightData
{
  WeightData* weightData;
  NSArray*    sortedweightData;
  sortedweightData = self.sortedWeightData;
  int count = [sortedweightData count];
  if (count > 0) {
    weightData = [sortedweightData lastObject];
//    weightData = [sortedweightData objectAtIndex:count-2];
    
  }else {
    weightData = nil;
  }
  
  return weightData;
}

- (WeightData*)compareWeightData
{
  // 管理対象オブジェクトコンテキストを取得する
  NSManagedObjectContext* context;
  context = self.managedObjectContext;
  
  // チャンネルを作成する
  WeightData* weightData;
  NSArray*    sortedweightData;
  sortedweightData = self.sortedWeightData;
  int count = [sortedweightData count];
  if (count > 1) {
    // 最後のチャンネルを取得する
    //    WeightData* lastWeightData;
//    weightData = [sortedweightData lastObject];
    weightData = [sortedweightData objectAtIndex:count-2];
    
  }else {
    return nil;
  }
  
  return weightData;
}

- (void)save
{
  // 保存
  NSError*    error;
  if (![self.managedObjectContext save:&error]) {
    // エラー
    NSLog(@"Error, %@", error);
  }
}

- (void)removeWeightDataAtIndex:(unsigned int)index
{
  // 引数を確認する
  NSMutableArray*    sortedweightData;
  sortedweightData = self.sortedWeightData;

  if (index > [sortedweightData count] - 1) {
    return;
  }
  
//  [sortedweightData removeObjectAtIndex:index];
  NSManagedObject * delData = [sortedweightData objectAtIndex:index];
  [_managedObjectContext deleteObject:delData];
}

/*
- (NSArray *)dailyDataFromDate:(NSDate *)from_date {
  NSCalendar *calendar= [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
  
  //①
  NSDateComponents *initComponents = [calendar components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) fromDate:from_date];
  //②
  NSDateComponents *componentsToAdd = [[NSDateComponents alloc] init];
  NSDateComponents *componentsToSubtract = [[NSDateComponents alloc] init];

  [componentsToSubtract setDay:+1];
  
  NSDate *fromDate = [calendar dateFromComponents:initComponents];
  NSDate *toDate = [calendar dateByAddingComponents: componentsToAdd toDate:fromDate options:0];
  
  NSPredicate *requestPredicate = [NSPredicate predicateWithFormat:@"(timeStamp >= %@ ) and (timeStamp < %@)",fromDate,toDate];
  //③
  NSArray *matchingFetchedObjects = [fetchedResultsController.fetchedObjects filteredArrayUsingPredicate:requestPredicate];

  return matchingFetchedObjects;
}
*/
@end
