//
//  KMViewController.m
//  dietHelper
//
//  Created by KoujiMiura on 2012/11/14.
//  Copyright (c) 2012年 KoujiMiura. All rights reserved.
//

#import "KMViewController.h"
#import "KMCustomButton.h"
#import "GradientButton.h"

@interface KMViewController ()
@end

@implementation KMViewController
//@synthesize saveButton;

- (void)viewDidLoad
{
  [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
  UIView *bgHeaderView = [[UIView alloc]init];
  CAGradientLayer *gradient = [CAGradientLayer layer];
  gradient.frame = self.view.bounds;
  gradient.colors = [NSArray arrayWithObjects:(id)[[UIColor colorWithRed:0.3 green:0.3 blue:0.3 alpha:1.0] CGColor], (id)[[UIColor colorWithRed:0 green:0 blue:0 alpha:1.0] CGColor], nil];
  [self.view.layer insertSublayer:gradient atIndex:0];
  bgHeaderView.frame = CGRectMake(0, 0, 320, 200);
  bgHeaderView.backgroundColor = [UIColor clearColor];//[UIColor colorWithRed:0.3 green:0.3 blue:0.3 alpha:1.0];
  [self.view addSubview:bgHeaderView];

/*
  CAGradientLayer *gradient = [CAGradientLayer layer];
  gradient.frame = bgHeaderView.bounds;
  gradient.colors = [NSArray arrayWithObjects:(id)[[UIColor colorWithRed:0.3 green:0.3 blue:0.3 alpha:1.0] CGColor], (id)[[UIColor colorWithRed:0 green:0 blue:0 alpha:1.0] CGColor], nil];
  [bgHeaderView.layer insertSublayer:gradient atIndex:0];
  
  self.view.backgroundColor = [UIColor colorWithRed:0.1 green:0.1 blue:0.1 alpha:1.0];
  [self.view addSubview:bgHeaderView];
*/

/*
  KMCustomButton *btn = [KMCustomButton buttonWithType:UIButtonTypeCustom];
  btn.frame = CGRectMake(320/2, 250/2, 66, 44);
  [btn setTitle:@"押して" forState:UIControlStateNormal];
  [btn setTitle:@"押した" forState:UIControlStateHighlighted];
  [btn setTitleColor:[UIColor redColor] forState:UIControlStateHighlighted];
  [bgHeaderView addSubview:btn];
*/

  UIPickerView *piv = [[UIPickerView alloc] init];
  piv.center = self.view.center;  // 中央に表示
//  piv.frame = CGRectMake(0, 500-250-100, 320, 90);
  piv.frame = CGRectMake(0, 400-100-50, KM_PICKER_WEIGHT, KM_PICKER_HEIGHT);
  piv.delegate = self;  // デリゲートを自分自身に設定
  piv.dataSource = self;  // データソースを自分自身に設定
  piv.backgroundColor = [UIColor clearColor];
  piv.showsSelectionIndicator = YES;
  [piv selectRow:0 inComponent:0 animated:NO];
  [piv selectRow:1 inComponent:1 animated:NO];
  [piv selectRow:2 inComponent:2 animated:NO];
  [piv selectRow:4 inComponent:4 animated:NO];
  [self.view addSubview:piv];
  
  UIView *bgFooterView = [[UIView alloc]init];
  bgFooterView.frame = CGRectMake(0, 460-50, KM_FOOTER_WEIGHT, KM_FOOTER_HEIGHT);
  bgFooterView.backgroundColor = [UIColor whiteColor];//[UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:1.0];
  /*
   CAGradientLayer *gradientFooter = [CAGradientLayer layer];
   gradientFooter.frame = bgFooterView.bounds;
   gradientFooter.colors = [NSArray arrayWithObjects:(id)[[UIColor colorWithRed:0.6 green:0.6 blue:0.6 alpha:1.0] CGColor], (id)[[UIColor colorWithRed:0.3 green:0.3 blue:0.3 alpha:1.0] CGColor], nil];
   [bgFooterView.layer insertSublayer:gradientFooter atIndex:0];
   */
   [self.view addSubview:bgFooterView];
//  KMCustomButton *saveButton = [KMCustomButton buttonWithType:UIButtonTypeCustom];
/*
  GradientButton *saveButton;
 saveButton = [[GradientButton alloc]init];
  saveButton.frame = CGRectMake
  ((KM_FOOTER_WEIGHT/FOOTER_BUTTON_NUM)/2-FOOTER_BUTTON_WEIGHT/2, 0, FOOTER_BUTTON_WEIGHT, KM_FOOTER_HEIGHT-2);
  saveButton.text = @"save";
*/
  //GradientButtonは初期化IFにinitWithFrameを指定しないとボタン動作をしない為注意！
  GradientButton *myButton = [[GradientButton alloc]initWithFrame:CGRectMake((KM_FOOTER_WEIGHT/FOOTER_BUTTON_NUM)/2-FOOTER_BUTTON_WEIGHT/2, 0, FOOTER_BUTTON_WEIGHT, KM_FOOTER_HEIGHT-2)];
  myButton.backgroundColor = [UIColor purpleColor];
  myButton.text = @"myButton";
//  [self.view addSubview:myButton];

  [bgFooterView addSubview:myButton];
//  [self.view addSubview:saveButton];
//  saveButton.enabled = YES;
  KMCustomButton *cancelButton = [KMCustomButton buttonWithType:UIButtonTypeCustom];
  cancelButton.frame = CGRectMake
  (((KM_FOOTER_WEIGHT/FOOTER_BUTTON_NUM)*1)+(FOOTER_BUTTON_WEIGHT/2), (KM_FOOTER_HEIGHT-FOOTER_BUTTON_HEIGHT)/2, FOOTER_BUTTON_WEIGHT, KM_FOOTER_HEIGHT-2);
  [cancelButton setTitle:@"cancel" forState:UIControlStateNormal];
  [cancelButton setTitle:@"canceled" forState:UIControlStateHighlighted];
  [cancelButton setTitleColor:[UIColor redColor] forState:UIControlStateHighlighted];
  [bgFooterView addSubview:cancelButton];
  self.view.userInteractionEnabled=YES;
  bgFooterView.userInteractionEnabled=YES;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
      break;
    case 3:
      label.text = [NSString stringWithFormat:@"."];
      break;
    case 5:
      label.text = [NSString stringWithFormat:@"kg"];
      break;
    default:
      break;
  }
  label.textColor = [UIColor blackColor];
	label.backgroundColor = [UIColor clearColor];
	label.textAlignment = NSTextAlignmentCenter;
	CGRect sc = [[UIScreen mainScreen] applicationFrame];
	label.frame = CGRectMake(0, 0, (sc.size.width - 10), 50);
	label.font = [UIFont boldSystemFontOfSize: 20];
	
	return label;
}
- (IBAction)touched:(id)sender {
  NSLog(@"%s|%@", __PRETTY_FUNCTION__, sender);
}
- (void)viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:animated];
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


@end
