//
//  KMViewController.m
//  dietHelper
//
//  Created by KoujiMiura on 2012/11/14.
//  Copyright (c) 2012年 KoujiMiura. All rights reserved.
//

#import "KMViewController.h"
#import "KMweightView.h"
#import "WeightData.h"
#import "KMweightDataManager.h"
#import "KMDataTableViewController.h"

@interface KMViewController ()
@end
UIPickerView *piv;
KMweightView *weightView;
KMweightView *compareWeightView;
UIButton *footerButton;
BOOL IsPickerViewHidden;
NSMutableArray *toolbarItems_;
UIBarButtonItem *savelItem_;
UIBarButtonItem *rightArrowlItem_;
UIBarButtonItem *spacer;
NSDateFormatter *df;
BOOL isSaved;
KMDataTableViewController *DataTableViewController;
UILabel *diffLabel;

@implementation KMViewController

@synthesize WeightData = _WeightData;

- (void)viewDidLoad
{
  [super viewDidLoad];

  CAGradientLayer *gradient = [CAGradientLayer layer];
  gradient.frame = self.view.bounds;
  gradient.colors = [NSArray arrayWithObjects:(id)[[UIColor colorWithRed:0.3 green:0.3 blue:0.3 alpha:1.0] CGColor], (id)[[UIColor colorWithRed:0 green:0 blue:0 alpha:1.0] CGColor], nil];
  [self.view.layer insertSublayer:gradient atIndex:0];

  df = [[NSDateFormatter alloc] init];
  df.dateFormat  = @"HH:mm:ss";
  weightView = [[KMweightView alloc]initWithFrame:CGRectMake(10, 233, WEIGHT_VIEW_WIDTH, WEIGHT_VIEW_HEIGHT) borderColor:[UIColor whiteColor].CGColor textColor:[UIColor whiteColor]];

  [self.view addSubview:weightView];
  
  compareWeightView = [[KMweightView alloc]initWithFrame:CGRectMake(10, 70, WEIGHT_VIEW_WIDTH, WEIGHT_VIEW_HEIGHT) borderColor:[UIColor whiteColor].CGColor textColor:[UIColor whiteColor]];
  [self.view addSubview:compareWeightView];

  diffLabel = [[UILabel alloc]initWithFrame:CGRectMake(160, 70+WEIGHT_VIEW_HEIGHT+40, 160-10, 40)];
  diffLabel.font = [UIFont fontWithName:@"AppleGothic" size:20];
  diffLabel.backgroundColor = [UIColor clearColor];
  diffLabel.textAlignment = UITextAlignmentRight;
  [self.view addSubview:diffLabel];

  piv = [[UIPickerView alloc] init];
  piv.delegate = self;
  piv.dataSource = self;
  piv.backgroundColor = [UIColor blackColor];
  piv.alpha = 1.0;
  piv.showsSelectionIndicator = YES;
  [piv selectRow:0 inComponent:0 animated:NO];
  [piv selectRow:1 inComponent:1 animated:NO];
  [piv selectRow:2 inComponent:2 animated:NO];
  [piv selectRow:4 inComponent:4 animated:NO];
  [self.view addSubview:piv];
  [self hidePicker];

  savelItem_ = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(saveButtonTap)];
  
  rightArrowlItem_ = [[UIBarButtonItem alloc]initWithTitle:@"一覧" style:UIBarButtonItemStyleBordered target:self action:@selector(arrowButtonTap)] ;

}

- (void)_saveWeight
{
  WeightData* weightData;
  weightData = _WeightData;
  
  if (!weightData) {
    weightData = [[KMweightDataManager sharedManager] insertNewWeightData];
  }
  weightData.weight000_1 = weightView.weight01Label.text;
  weightData.weight001 = weightView.weight1Label.text;
  weightData.weight010 = weightView.weight10Label.text;
  weightData.weight100 = weightView.weight100Label.text;
  weightData.date = [NSDate date];

  [[KMweightDataManager sharedManager] save];
  
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:animated];

  self.navigationController.navigationBar.tintColor  = [UIColor blackColor];

  spacer = [[UIBarButtonItem alloc]
                             initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                             target:nil action:nil];

  toolbarItems_ = [NSMutableArray arrayWithObjects:self.editButtonItem,spacer,spacer, spacer, nil];
  [self setToolbarItems:toolbarItems_ animated:NO];
  
  [self.navigationController setToolbarHidden:NO animated:NO];
  self.navigationController.toolbar.tintColor = [UIColor blackColor];
  
  [self.navigationItem setRightBarButtonItem:rightArrowlItem_];
  
  WeightData* weightData;
  weightData = [[KMweightDataManager sharedManager] lastWeightData];
  if (weightData) {
    weightView.weight100Label.text = weightData.weight100;
    weightView.weight10Label.text = weightData.weight010;
    weightView.weight1Label.text = weightData.weight001;
    weightView.weight01Label.text = weightData.weight000_1;
    
    NSString *Datestr = [self getDateStr:weightData.date];
    weightView.dayLabel.text = [Datestr stringByAppendingString:[df stringFromDate:weightData.date]];
    
    [piv selectRow:weightData.weight100.intValue inComponent:0 animated:NO];
    [piv selectRow:weightData.weight010.intValue inComponent:1 animated:NO];
    [piv selectRow:weightData.weight001.intValue inComponent:2 animated:NO];
    [piv selectRow:weightData.weight000_1.intValue inComponent:4 animated:NO];
  }

  WeightData* compareWeightData;
  compareWeightData = [[KMweightDataManager sharedManager]compareWeightData];
  if (compareWeightData) {
    compareWeightView.weight100Label.text = compareWeightData.weight100;
    compareWeightView.weight10Label.text = compareWeightData.weight010;
    compareWeightView.weight1Label.text = compareWeightData.weight001;
    compareWeightView.weight01Label.text = compareWeightData.weight000_1;
    
    NSString *Datestr = [self getDateStr:compareWeightData.date];
    compareWeightView.dayLabel.text = [Datestr stringByAppendingString:[df stringFromDate:compareWeightData.date]];
  }
  [self setNowWeightLabelColor];
  [self setDiffWeight];

}
- (void)setDiffWeight {
  float newWeight = [self NewWeight];
  float oldWeight = [self OldWeight];
  if (newWeight > oldWeight) {
    diffLabel.textColor = [UIColor redColor];
  }else if (newWeight < oldWeight){
    diffLabel.textColor = [UIColor blueColor];
  }else{
    diffLabel.textColor = [UIColor whiteColor];
  }
  diffLabel.text = [NSString stringWithFormat:@"差分：%0.1f",newWeight-oldWeight];

}
- (NSString*)getDateStr:(NSDate*)date {
  NSTimeInterval  since = [[NSDate date] timeIntervalSinceDate:date];
  NSInteger sinceDay = since/(24*60*60);

  NSString *Datestr;
  if (sinceDay == 0) {
    Datestr = @"今日 ";
  }else{
    Datestr = [NSString stringWithFormat:@"%d日前 ",sinceDay];
  }
  return Datestr;
}

- (void)viewDidAppear:(BOOL)animated
{
  [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (void)showPicker {
  //ピッカーが下から出るアニメーション
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.4];
	[UIView setAnimationDelegate:self];
  CGFloat toolbarHeight =  self.navigationController.toolbar.frame.size.height;

  CGRect bounds = [[UIScreen mainScreen]bounds];
  CGFloat screenHeight = bounds.size.height;
  CGFloat pvy = screenHeight-toolbarHeight-KM_PICKER_HEIGHT*2.5;
  piv.frame = CGRectMake(0, pvy, KM_PICKER_WEIGHT, KM_PICKER_HEIGHT);
  
	[UIView commitAnimations];
	IsPickerViewHidden = false;
}

- (void)hidePicker {
	//ピッカーを下に隠すアニメーション
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.4];
	[UIView setAnimationDelegate:self];
  piv.frame = CGRectMake(0, 480, KM_PICKER_WEIGHT, KM_PICKER_HEIGHT);	[UIView commitAnimations];
  IsPickerViewHidden = true;
}
-(void)saveButtonTap{
  [self weightBefore];
  [self weightNow];
  [self setNowWeightLabelColor];
  [self setDiffWeight];
  [self _saveWeight];

  self.editing = false;
  isSaved = true;
}
-(void)arrowButtonTap{
  DataTableViewController = [[KMDataTableViewController alloc] init];
  [self.navigationController pushViewController:DataTableViewController animated:YES];
}
-(void)redoPvValue{
  [piv selectRow:weightView.weight100Label.text.intValue inComponent:0 animated:NO];
  [piv selectRow:weightView.weight10Label.text.intValue inComponent:1 animated:NO];
  [piv selectRow:weightView.weight1Label.text.intValue inComponent:2 animated:NO];
  [piv selectRow:weightView.weight01Label.text.intValue inComponent:4 animated:NO];
}
-(void)weightNow{
  weightView.weight100Label.text = [NSString stringWithFormat:@"%d",[piv selectedRowInComponent:0]];
  weightView.weight10Label.text = [NSString stringWithFormat:@"%d",[piv selectedRowInComponent:1]];
  weightView.weight1Label.text = [NSString stringWithFormat:@"%d",[piv selectedRowInComponent:2]];
  weightView.weight01Label.text = [NSString stringWithFormat:@"%d",[piv selectedRowInComponent:4]];
  NSString *Datestr = [self getDateStr:[NSDate date]];
  weightView.dayLabel.text = [Datestr stringByAppendingString:[df stringFromDate:[NSDate date]]];
}
-(void)weightBefore{
  compareWeightView.weight100Label.text = weightView.weight100Label.text;
  compareWeightView.weight10Label.text = weightView.weight10Label.text;
  compareWeightView.weight1Label.text = weightView.weight1Label.text;
  compareWeightView.weight01Label.text = weightView.weight01Label.text;
//データ保存前のタイミングなのでlast dataを利用する。
  WeightData* weightData;
  weightData = [[KMweightDataManager sharedManager] lastWeightData];
  NSString *Datestr = [self getDateStr:weightData.date];
  compareWeightView.dayLabel.text = [Datestr stringByAppendingString:[df stringFromDate:weightData.date]];

}

-(void)setEditing:(BOOL)editing animated:(BOOL)animated
{
  [super setEditing:editing animated:animated];
  if (self.editing) {
    [self showPicker];
    [self.navigationItem setLeftBarButtonItem:nil];
    [self.navigationItem setRightBarButtonItem:savelItem_];
    self.editButtonItem.title = @"cancel";

    toolbarItems_ = [NSMutableArray arrayWithObjects:self.editButtonItem,spacer,spacer, savelItem_, nil];
    [self setToolbarItems:toolbarItems_ animated:NO];

  }else{
    //ToDo 要リファクタリング
    if (isSaved) {
      isSaved = false;
    }else{
      [self redoPvValue];
    }
      
    [self hidePicker];

    UIToolbar *myToolbar = self.navigationController.toolbar;
    NSMutableArray *items = [[NSMutableArray alloc]initWithArray:[myToolbar items]];
    [items removeObjectAtIndex:3];
    [myToolbar setItems:items];

    [self.navigationItem setLeftBarButtonItem:nil];
    [self.navigationItem setRightBarButtonItem:rightArrowlItem_];
  }
}
-(void)setNowWeightLabelColor {
  //ToDo refactoring
  float newWeight = [self NewWeight];
  float oldWeight = [self OldWeight];
  if (newWeight > oldWeight) {
    //led
    weightView.weight100Label.textColor = [UIColor redColor];
    weightView.weight10Label.textColor = [UIColor redColor];
    weightView.weight1Label.textColor = [UIColor redColor];
    weightView.weight01Label.textColor = [UIColor redColor];
    weightView.commaLabel.textColor =  [UIColor redColor];
    weightView.kgLabel.textColor = [UIColor redColor];
  }else if (newWeight < oldWeight) {
    //blue
    weightView.weight100Label.textColor = [UIColor blueColor];
    weightView.weight10Label.textColor = [UIColor blueColor];
    weightView.weight1Label.textColor = [UIColor blueColor];
    weightView.weight01Label.textColor = [UIColor blueColor];
    weightView.commaLabel.textColor =  [UIColor blueColor];
    weightView.kgLabel.textColor = [UIColor blueColor];
  }else{
    weightView.weight100Label.textColor = [UIColor whiteColor];
    weightView.weight10Label.textColor = [UIColor whiteColor];
    weightView.weight1Label.textColor = [UIColor whiteColor];
    weightView.weight01Label.textColor = [UIColor whiteColor];
    weightView.commaLabel.textColor =  [UIColor whiteColor];
    weightView.kgLabel.textColor = [UIColor whiteColor];
  }
}
-(float)NewWeight {
  float newWeight = weightView.weight100Label.text.integerValue*100;
  newWeight += weightView.weight10Label.text.integerValue*10;
  newWeight += weightView.weight1Label.text.integerValue;
  newWeight += weightView.weight01Label.text.integerValue*0.1;
  return newWeight;
}
-(float)OldWeight {
  float oldWeight = compareWeightView.weight100Label.text.integerValue*100;
  oldWeight += compareWeightView.weight10Label.text.integerValue*10;
  oldWeight += compareWeightView.weight1Label.text.integerValue;
  oldWeight += compareWeightView.weight01Label.text.integerValue*0.1;
  return oldWeight;
}

//pickerviewのデリゲート
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView*)pickerView{
  return 6;
}

-(NSInteger)pickerView:(UIPickerView*)pickerView numberOfRowsInComponent:(NSInteger)component{
  switch (component) {
    case 0:
    case 1:
    case 2:
    case 4:
      return 10;
      break;
    default:
      return 1;
      break;
  }
}

-(UIView*)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
  
	UILabel *label = [[UILabel alloc] init];
  switch (component) {
    case 0:
    case 1:
    case 2:
    case 4:
      label.text = [NSString stringWithFormat:@"%d", row];
      label.font = [UIFont systemFontOfSize:20];
      break;
    case 3:
      label.text = [NSString stringWithFormat:@"."];
      label.font = [UIFont boldSystemFontOfSize:20];
      break;
    case 5:
      label.text = [NSString stringWithFormat:@"kg"];
      label.font = [UIFont boldSystemFontOfSize:20];
      break;
    default:
      break;
  }
  label.textColor = [UIColor blackColor];
	label.backgroundColor = [UIColor clearColor];
	label.textAlignment = NSTextAlignmentCenter;
	CGRect sc = [[UIScreen mainScreen] applicationFrame];
	label.frame = CGRectMake(0, 0, (sc.size.width - 10), 50);
	
	return label;
}
- (void) pickerView: (UIPickerView*)pView didSelectRow:(NSInteger) row  inComponent:(NSInteger)component {
  
}

@end
