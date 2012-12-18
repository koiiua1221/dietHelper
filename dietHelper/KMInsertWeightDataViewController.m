//
//  KMInsertWeightDataViewController.m
//  dietHelper
//
//  Created by KoujiMiura on 2012/12/14.
//  Copyright (c) 2012年 KoujiMiura. All rights reserved.
//

#import "KMInsertWeightDataViewController.h"
#import "KMInsertWeightDataView.h"
#import "KMInsertDateDataView.h"
#import "KMweightDataManager.h"

@interface KMInsertWeightDataViewController ()

@end
KMInsertWeightDataView *InsertWeightDataView;
UIBarButtonItem *saveButtonItem_;
UIBarButtonItem *cancelButtonItem_;
UIBarButtonItem *spacer;
NSMutableArray *toolbarItems_;
UIPickerView *piv;
UIPickerView *datePiv;
UIView *currentPicker;
BOOL IsDateWritten;
BOOL IsWeightWritten;
BOOL IsPickerViewHidden;
UILabel *InsertDateDataLbl;
KMInsertDateDataView *InsertDateDataView;

@implementation KMInsertWeightDataViewController
@synthesize delegate = _delegate;
@synthesize WeightData = _WeightData;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  CAGradientLayer *gradient = [CAGradientLayer layer];
  gradient.frame = self.view.bounds;
  gradient.colors = [NSArray arrayWithObjects:(id)[[UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:1.0] CGColor], (id)[[UIColor colorWithRed:0 green:0 blue:0 alpha:1.0] CGColor], nil];
  [self.view.layer insertSublayer:gradient atIndex:0];
  self.title = @"手動追加";
  
	// Do any additional setup after loading the view.
  InsertWeightDataView = [[KMInsertWeightDataView alloc]initWithFrame:CGRectMake(10, 233, WEIGHT_VIEW_WIDTH, WEIGHT_VIEW_HEIGHT)];
  
  [InsertWeightDataView setBorderColor:[UIColor blackColor].CGColor];
  
  [self.view addSubview:InsertWeightDataView];
  UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(InsertWeightDataViewTaped)];
  [InsertWeightDataView addGestureRecognizer:tapGesture];

  UITapGestureRecognizer *tapGestureDate = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(InsertDateDataLblTaped)];

  InsertDateDataView = [[KMInsertDateDataView alloc]initWithFrame:CGRectMake(10, 133, 300, 50)];
  [InsertDateDataView setBorderColor:[UIColor blackColor].CGColor];
  [InsertDateDataView addGestureRecognizer:tapGestureDate];
  [self.view addSubview:InsertDateDataView];

  CGRect viewFrame = self.view.bounds;
  IsPickerViewHidden = true;
  CGFloat toolbarHeight =  self.navigationController.toolbar.frame.size.height;
  
  CGRect bounds = [[UIScreen mainScreen]bounds];
  CGFloat screenHeight = bounds.size.height;
  CGFloat pvy = screenHeight-toolbarHeight-KM_PICKER_HEIGHT*2.5;

  piv = [[UIPickerView alloc] init];
  piv.frame = CGRectMake(0, screenHeight, KM_PICKER_WEIGHT, KM_PICKER_HEIGHT);
  piv.delegate = self;
  piv.dataSource = self;
  piv.backgroundColor = [UIColor blackColor];
  piv.alpha = 1.0;
  piv.showsSelectionIndicator = YES;
  piv.tag = KM_PICKER_TAG_WEIGHT;
  [self.view addSubview:piv];

  datePiv = [[UIPickerView alloc] init];
  datePiv.frame = CGRectMake(0, screenHeight, KM_PICKER_WEIGHT, KM_PICKER_HEIGHT);
  datePiv.delegate = self;
  datePiv.dataSource = self;
  datePiv.backgroundColor = [UIColor blackColor];
  datePiv.alpha = 1.0;
  datePiv.showsSelectionIndicator = YES;
  datePiv.tag = KM_PICKER_TAG_DATE;
  [self.view addSubview:datePiv];

  WeightData* weightData;
  weightData = [[KMweightDataManager sharedManager] lastWeightData];
  if (weightData) {
    [piv selectRow:weightData.weight100.intValue inComponent:0 animated:NO];
    [piv selectRow:weightData.weight010.intValue inComponent:1 animated:NO];
    [piv selectRow:weightData.weight001.intValue inComponent:2 animated:NO];
    [piv selectRow:weightData.weight000_1.intValue inComponent:4 animated:NO];

    NSCalendar* calendar = [NSCalendar currentCalendar];
    NSDateComponents* components = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:weightData.date];
    [datePiv selectRow:components.year-2000 inComponent:1 animated:NO];
    [datePiv selectRow:components.month-1 inComponent:3 animated:NO];
    [datePiv selectRow:components.day-1 inComponent:5 animated:NO];
  }
  saveButtonItem_ = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(saveButtonTapped)];
  saveButtonItem_.enabled = false;
  spacer = [[UIBarButtonItem alloc]
            initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
            target:nil action:nil];
  cancelButtonItem_ = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelButtonTapped)];
  cancelButtonItem_.enabled = true;
  
  IsDateWritten = false;
  IsWeightWritten = false;
}
- (void)loadView
{
  [super loadView];
}
- (void)viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:animated];
  self.navigationController.navigationBar.tintColor  = [UIColor blackColor];
  [self.navigationController setToolbarHidden:NO animated:NO];
  self.navigationController.toolbar.tintColor = [UIColor blackColor];
  toolbarItems_ = [NSMutableArray arrayWithObjects:saveButtonItem_,spacer,spacer, cancelButtonItem_, nil];
  [self setToolbarItems:toolbarItems_ animated:NO];

}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)saveButtonTapped
{
  if (IsWeightWritten&&IsDateWritten) {
    if ([self isSafeData]) {
      [self _saveData];
      [self backView];
    }else{
      UIAlertView *alert = [[UIAlertView alloc] init];
      alert.title = @"データエラー";
      alert.message = @"未来日付です";
      [alert addButtonWithTitle:@"確認"];
      [alert show];
    }
  }
}
- (void)cancelButtonTapped
{
  [self backView];
}
- (void)backView
{
  if ([_delegate respondsToSelector:@selector(InsertWeightDataViewControllerDidSave:)]) {
    [_delegate InsertWeightDataViewControllerDidSave:self];
  }
}
- (BOOL)isSafeData {
  BOOL ret = true;
  NSCalendar* calendar = [NSCalendar currentCalendar];
  NSDateComponents* components = [[NSDateComponents alloc] init];
  components.year = 2000+InsertDateDataView.yearLabel.text.integerValue;
  components.month = InsertDateDataView.monthLabel.text.integerValue;
  components.day = InsertDateDataView.dayLabel.text.integerValue;
  NSDate* saveDate = [calendar dateFromComponents:components];
  
  if ([saveDate compare:[NSDate date]]==NSOrderedDescending) {
    ret = false;
  }
  return ret;
}
- (void)showPicker:(NSInteger)tag {
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.4];
	[UIView setAnimationDelegate:self];
  CGFloat toolbarHeight =  self.navigationController.toolbar.frame.size.height;
  CGRect bounds = [[UIScreen mainScreen]bounds];
  CGFloat screenHeight = bounds.size.height;
  CGFloat pvy = screenHeight-toolbarHeight-KM_PICKER_HEIGHT*2.5;

  if (tag == KM_PICKER_TAG_WEIGHT) {
    piv.frame = CGRectMake(0, pvy, KM_PICKER_WEIGHT, KM_PICKER_HEIGHT);
    currentPicker = piv;
  }else{
    datePiv.frame = CGRectMake(0, pvy, KM_PICKER_WEIGHT, KM_PICKER_HEIGHT);
    currentPicker = datePiv;
  }

	[UIView commitAnimations];
	IsPickerViewHidden = false;
}
- (void)hidePicker:(NSInteger)tag {
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.4];
	[UIView setAnimationDelegate:self];
  if (tag == KM_PICKER_TAG_WEIGHT) {
    piv.frame = CGRectMake(0, 480, KM_PICKER_WEIGHT, KM_PICKER_HEIGHT);
  }else{
    datePiv.frame = CGRectMake(0, 480, KM_PICKER_WEIGHT, KM_PICKER_HEIGHT);
  }
  [UIView commitAnimations];
  IsPickerViewHidden = true;
}

- (void)InsertWeightDataViewTaped
{
  if (IsPickerViewHidden) {
    [self hidePicker:KM_PICKER_TAG_DATE];
    [self showPicker:KM_PICKER_TAG_WEIGHT];
    [InsertWeightDataView setBorderColor:[UIColor whiteColor].CGColor];
  }else{
    if ([currentPicker isEqual:piv]) {
      [self hidePicker:KM_PICKER_TAG_WEIGHT];
      [self writeWeight];
      [InsertWeightDataView setBorderColor:[UIColor blackColor].CGColor];    }
  }
}
- (void)InsertDateDataLblTaped{
  if (IsPickerViewHidden) {
    [self hidePicker:KM_PICKER_TAG_WEIGHT];
    [self showPicker:KM_PICKER_TAG_DATE];
    [InsertDateDataView setBorderColor:[UIColor whiteColor].CGColor];
  }else{
    if ([currentPicker isEqual:datePiv]) {
      [self hidePicker:KM_PICKER_TAG_DATE];
      [self writeDate];
      [InsertDateDataView setBorderColor:[UIColor blackColor].CGColor];
    }
  }
}
- (void)writeDate {
  InsertDateDataView.yearLabel.text = [NSString stringWithFormat:@"%d",[datePiv selectedRowInComponent:1]];
  InsertDateDataView.monthLabel.text = [NSString stringWithFormat:@"%d",[datePiv selectedRowInComponent:3]+1];
  InsertDateDataView.dayLabel.text = [NSString stringWithFormat:@"%d",[datePiv selectedRowInComponent:5]+1];
  IsDateWritten = true;
  if (IsWeightWritten) {  //ToDo refactoring is necessary
    saveButtonItem_.enabled = true;
  }
}
- (void)writeWeight {
  InsertWeightDataView.weight100Label.text = [NSString stringWithFormat:@"%d",[piv selectedRowInComponent:0]];
  InsertWeightDataView.weight10Label.text = [NSString stringWithFormat:@"%d",[piv selectedRowInComponent:1]];
  InsertWeightDataView.weight1Label.text = [NSString stringWithFormat:@"%d",[piv selectedRowInComponent:2]];
  InsertWeightDataView.weight01Label.text = [NSString stringWithFormat:@"%d",[piv selectedRowInComponent:4]];
  IsWeightWritten = true;
  if (IsDateWritten) {  //ToDo refactoring is necessary
    saveButtonItem_.enabled = true;
  }
}

-(void)_saveData {
  WeightData* weightData;
  weightData = _WeightData;
  
  if (!weightData) {
    NSCalendar* calendar = [NSCalendar currentCalendar];
    NSDateComponents* components = [[NSDateComponents alloc] init];
    components.year = 2000+InsertDateDataView.yearLabel.text.integerValue;
    components.month = InsertDateDataView.monthLabel.text.integerValue;
    components.day = InsertDateDataView.dayLabel.text.integerValue;
    NSDate* saveDate = [calendar dateFromComponents:components];
    weightData.date = saveDate;
    
    weightData = [[KMweightDataManager sharedManager] insertNewWeightData];
    weightData.weight000_1 = InsertWeightDataView.weight01Label.text;
    weightData.weight001 = InsertWeightDataView.weight1Label.text;
    weightData.weight010 = InsertWeightDataView.weight10Label.text;
    weightData.weight100 = InsertWeightDataView.weight100Label.text;
    
    [[KMweightDataManager sharedManager] save];
    saveButtonItem_.enabled = false;
  }
}

-(UIView*)setWeightPickerVals:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
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

-(UIView*)setDatePickerVals:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
	UILabel *label = [[UILabel alloc] init];
  
  switch (component) {
    case 0:
      label.text = @"20";
      label.font = [UIFont systemFontOfSize:20];
      break;
    case 1:
      label.text = [NSString stringWithFormat:@"%d", row];
      label.font = [UIFont systemFontOfSize:20];
      break;
    case 2:
      label.text = @"年";
      label.font = [UIFont systemFontOfSize:25];
      break;
    case 3:
      label.text = [NSString stringWithFormat:@"%d", row+1];
      label.font = [UIFont systemFontOfSize:20];
      break;
    case 4:
      label.text = @"月";
      label.font = [UIFont systemFontOfSize:25];
      break;
    case 5:
      label.text = [NSString stringWithFormat:@"%d", row+1];
      label.font = [UIFont systemFontOfSize:20];
      break;
    case 6:
      label.text = @"日";
      label.font = [UIFont systemFontOfSize:25];
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

#pragma mark - Picker view delegate
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView*)pickerView{
  if (pickerView.tag == KM_PICKER_TAG_WEIGHT) {
    return 6;
  }else{
    return 7;
  }
}

-(NSInteger)pickerView:(UIPickerView*)pickerView numberOfRowsInComponent:(NSInteger)component{
  if (pickerView.tag == KM_PICKER_TAG_WEIGHT) {
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
  }else{
    switch (component) {
      case 1:
        return 99;
      case 3:
        return 12;
      case 5:
        return 31;
      default:
        return 1;
    }
  }
}

-(UIView*)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
  UILabel* label;
  if (pickerView.tag == KM_PICKER_TAG_WEIGHT) {
    label = (UILabel*)[self setWeightPickerVals:row forComponent:component reusingView:view];
  }else{
    label = (UILabel*)[self setDatePickerVals:row forComponent:component reusingView:view];
  }
	return label;
}

- (void) pickerView: (UIPickerView*)pView didSelectRow:(NSInteger) row  inComponent:(NSInteger)component {
  
}

@end
