//
//  KMDataTableViewController.m
//  dietHelper
//
//  Created by KoujiMiura on 2012/12/12.
//  Copyright (c) 2012年 KoujiMiura. All rights reserved.
//

#import "KMDataTableViewController.h"
#import "KMweightDataManager.h"
#import "WeightData.h"
#import "KMweightDataListCell.h"
#import "KMInsertWeightDataViewController.h"

@interface KMDataTableViewController ()

@end
NSMutableArray *toolbarItems_;
UIBarButtonItem *spacer;
UIBarButtonItem *addItem;

@implementation KMDataTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.view.backgroundColor = [UIColor blackColor];
    addItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addRow)];
    spacer = [[UIBarButtonItem alloc]
            initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
            target:nil action:nil];
    self.title = @"リスト";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:animated];
  [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow]animated:animated];
  for (UITableViewCell* cell in [self.tableView visibleCells]) {
    [self _updateCell:cell atIndexPath:[self.tableView indexPathForCell:cell]];
  }
  toolbarItems_ = [NSMutableArray arrayWithObjects:self.editButtonItem,spacer,spacer, spacer, nil];
  [self setToolbarItems:toolbarItems_ animated:NO];
  
  [self.navigationController setToolbarHidden:NO animated:NO];
  self.navigationController.toolbar.tintColor = [UIColor blackColor];

}
- (void)_updateCell:(UITableViewCell*)cell atIndexPath:(NSIndexPath*)indexPath
{
  KMweightDataListCell* weightDataListCell;
  weightDataListCell = (KMweightDataListCell*)cell;
  
  // 指定された行のチャンネルの取得
  NSArray*    weightDataArray;
  WeightData* weightData = nil;
  weightDataArray = [[KMweightDataManager sharedManager] sortedWeightData];
  if (indexPath.row < [weightDataArray count]) {
    weightData = [weightDataArray objectAtIndex:indexPath.row];
  }
  NSDateFormatter *df;
  
  df = [[NSDateFormatter alloc] init];
  df.dateFormat  = @"yyyy/MM/dd HH:mm:ss";
  
  float weight = weightData.weight100.integerValue*100+weightData.weight010.integerValue*10+weightData.weight001.integerValue;
  weight += weightData.weight000_1.integerValue*0.1;
  
  NSString *tmpString = [df stringFromDate:weightData.date];
  tmpString = [tmpString stringByAppendingFormat:@"    %0.1f kg",weight];
  weightDataListCell.textLabel.text = tmpString;
  
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
  [super setEditing:editing animated:animated];
  [self.tableView setEditing:editing animated:YES];
  if (editing) {
    [self.navigationItem setRightBarButtonItem:addItem animated:YES];
  } else {
    [self.navigationItem setRightBarButtonItem:nil animated:YES];
  }
}
- (void)addRow {
  [self.tableView setEditing:false animated:YES];
  [self setEditing:false];
  [self.navigationItem setRightBarButtonItem:nil animated:YES];
  
  KMInsertWeightDataViewController *InsertWeightDataView = [[KMInsertWeightDataViewController alloc]init];
  InsertWeightDataView.delegate = self;
  UINavigationController *navController;
  navController = [[UINavigationController alloc]initWithRootViewController:InsertWeightDataView];
  navController.modalPresentationStyle=UIModalPresentationFormSheet;
  [self presentViewController: navController animated:YES completion: ^{NSLog(@"完了");}];
}

#pragma mark - Table view data source
/*
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 0;
}
*/
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    NSInteger count = [[KMweightDataManager sharedManager]sortedWeightData].count;
    return count;

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"DataTableView";
    KMweightDataListCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
  if (!cell) {
    cell = [[KMweightDataListCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
  }
  [self _updateCell:cell atIndexPath:indexPath];
  return cell;
}

// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
      [[KMweightDataManager sharedManager] removeWeightDataAtIndex:indexPath.row];
      [[KMweightDataManager sharedManager] save];
        // Delete the row from the data source
//      [tableView beginUpdates];
//      [tableView.7]
      [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
//      [tableView endUpdates];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     ; *detailViewController = [[i alloc] initWithNibName:@"i" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}
#pragma mark - InsertWeightDataViewController delegate
- (void)InsertWeightDataViewControllerDidSave:(KMInsertWeightDataViewController*)controller
{
  [controller dismissViewControllerAnimated:YES completion:^{NSLog(@"完了");}];
}
@end
