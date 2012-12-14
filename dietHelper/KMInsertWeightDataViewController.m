//
//  KMInsertWeightDataViewController.m
//  dietHelper
//
//  Created by KoujiMiura on 2012/12/14.
//  Copyright (c) 2012年 KoujiMiura. All rights reserved.
//

#import "KMInsertWeightDataViewController.h"
#import "KMInsertWeightDataView.h"

@interface KMInsertWeightDataViewController ()

@end
KMInsertWeightDataView *InsertWeightDataView;
UIBarButtonItem *saveButtonItem_;
UIBarButtonItem *spacer;
NSMutableArray *toolbarItems_;
UIPickerView *piv;
BOOL IsWeightPicker;
BOOL IsPickerViewHidden;
UILabel *InsertDateDataLbl;

@implementation KMInsertWeightDataViewController
@synthesize delegate = _delegate;

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
  gradient.colors = [NSArray arrayWithObjects:(id)[[UIColor colorWithRed:0.3 green:0.3 blue:0.3 alpha:1.0] CGColor], (id)[[UIColor colorWithRed:0 green:0 blue:0 alpha:1.0] CGColor], nil];
  [self.view.layer insertSublayer:gradient atIndex:0];
  self.title = @"追加";
  
	// Do any additional setup after loading the view.
  InsertWeightDataView = [[KMInsertWeightDataView alloc]initWithFrame:CGRectMake(10, 233, WEIGHT_VIEW_WIDTH, WEIGHT_VIEW_HEIGHT)];
  [self.view addSubview:InsertWeightDataView];
  UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(InsertWeightDataViewTaped)];
  [InsertWeightDataView addGestureRecognizer:tapGesture];

  InsertDateDataLbl = [[UILabel alloc]initWithFrame:CGRectMake(10, 133, 300, 50)];
  InsertDateDataLbl.backgroundColor = [UIColor grayColor];
  InsertDateDataLbl.layer.borderColor = [UIColor whiteColor].CGColor;
  InsertDateDataLbl.layer.borderWidth = 1.0;
  [self.view addSubview:InsertDateDataLbl];
  UITapGestureRecognizer *tapGestureDate = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(InsertDateDataLblTaped)];
  [InsertDateDataLbl addGestureRecognizer:tapGestureDate];
  InsertDateDataLbl.userInteractionEnabled = YES;
  
  CGRect viewFrame = self.view.bounds;
  IsPickerViewHidden = true;
  piv = [[UIPickerView alloc] initWithFrame:CGRectMake(0, viewFrame.size.height, KM_PICKER_WEIGHT, KM_PICKER_HEIGHT)];
  piv.delegate = self;
  piv.dataSource = self;
  piv.backgroundColor = [UIColor blackColor];
  piv.alpha = 1.0;
  piv.showsSelectionIndicator = YES;
/*
  [piv selectRow:0 inComponent:0 animated:NO];
  [piv selectRow:0 inComponent:1 animated:NO];
  [piv selectRow:0 inComponent:2 animated:NO];
  [piv selectRow:0 inComponent:4 animated:NO];
*/
  [self.view addSubview:piv];

  saveButtonItem_ = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(saveButtonTapped)];
  spacer = [[UIBarButtonItem alloc]
            initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
            target:nil action:nil];
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
  toolbarItems_ = [NSMutableArray arrayWithObjects:saveButtonItem_,spacer,spacer, spacer, nil];
  [self setToolbarItems:toolbarItems_ animated:NO];

}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)saveButtonTapped
{
  if ([_delegate respondsToSelector:@selector(InsertWeightDataViewControllerDidSave:)]) {
    [_delegate InsertWeightDataViewControllerDidSave:self];
  }
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

- (void)InsertWeightDataViewTaped
{
  IsWeightPicker = true;
  if (IsPickerViewHidden) {
    [self showPicker];
  }else{
    [self hidePicker];
    IsWeightPicker = false;
  }
}
- (void)InsertDateDataLblTaped{
  if (!IsWeightPicker) {
    if (IsPickerViewHidden) {
      [self showPicker];
    }else{
      [self hidePicker];
    }
  }
}
//pickerviewのデリゲート
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView*)pickerView{
//  if (IsWeightPicker) {
    return 6;
//  }else{
//    return 3;
//  }
}

-(NSInteger)pickerView:(UIPickerView*)pickerView numberOfRowsInComponent:(NSInteger)component{
//  if (IsWeightPicker) {
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
/*
  }else{
    switch (component) {
      case 0:
        return 99;
      case 1:
        return 12;
      case 2:
        return 31;
      default:
        return 1;
    }
  }
*/
}

-(UIView*)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
/*
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
*/
  UILabel* label;
  label = [self setWeightPickerVals:row forComponent:component reusingView:view];
	return label;
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

- (void) pickerView: (UIPickerView*)pView didSelectRow:(NSInteger) row  inComponent:(NSInteger)component {
  
}

@end
