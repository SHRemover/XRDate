//
//  ViewController.m
//  Date
//
//  Created by sh on 2017/11/17.
//  Copyright © 2017年 sh. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()<UITextFieldDelegate>
{
    NSString *inputString;
    NSString *beginString;
    NSString *endString;
}
@property (weak, nonatomic) IBOutlet UIButton *beginBtn;
@property (weak, nonatomic) IBOutlet UITextField *beginYearTF;
@property (weak, nonatomic) IBOutlet UITextField *beginMonthTF;
@property (weak, nonatomic) IBOutlet UITextField *beginDayTF;

@property (weak, nonatomic) IBOutlet UIButton *endBtn;
@property (weak, nonatomic) IBOutlet UITextField *endYearTF;
@property (weak, nonatomic) IBOutlet UITextField *endMonthTF;
@property (weak, nonatomic) IBOutlet UITextField *endDayTF;

@property (weak, nonatomic) IBOutlet UILabel *realLab;
@property (weak, nonatomic) IBOutlet UILabel *normLab;
@property (weak, nonatomic) IBOutlet UILabel *monthLab;

@property (weak, nonatomic) IBOutlet UIButton *sureBtn;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

// 计算
- (IBAction)sureBtnAction:(UIButton *)sender {
    
    beginString = [NSString stringWithFormat:@"%@-%@-%@", _beginYearTF.text, _beginMonthTF.text, _beginDayTF.text];
    endString = [NSString stringWithFormat:@"%@-%@-%@", _endYearTF.text, _endMonthTF.text, _endDayTF.text];
    
    //首先创建格式化对象
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *beginDate = [dateFormatter dateFromString:beginString];
    NSDate *endDate = [dateFormatter dateFromString:endString];
    
    //创建日历
    NSCalendar * calendar = [NSCalendar currentCalendar];
    NSCalendarUnit unit = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    //利用日历对象比较两个时间的差值
    NSDateComponents * components = [calendar components:unit fromDate:beginDate toDate:endDate options:0];
    _monthLab.text = [NSString stringWithFormat:@"%ld年 %ld月 %ld日 \n", components.year, components.month, components.day+1];
    
#pragma 标准格式
    //计算时间间隔（单位是秒）
    NSTimeInterval time = [endDate timeIntervalSinceDate:beginDate];
    //计算天数、时、分、秒
    int sumDay = ((int)time)/(3600*24);
    _realLab.text = [NSString stringWithFormat:@"%d天", sumDay+1];
    
#pragma 每月30天格式
    
    //计算天数、时、分、秒
    NSInteger sumDay30 = components.year*360+components.month*30+components.day+1;
    _normLab.text = [NSString stringWithFormat:@"%ld天", (long)sumDay30];
}


#pragma UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    inputString = string;
    NSString * subString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    
    NSInteger tag = textField.tag;
    
    if (string.length) {
        
        if ((tag == 1 || tag == 4) && subString.length >4) {
            [self nextFieldBecomeFirstResponder:textField];
        }
        else if (tag == 2 || tag == 3 || tag == 5 || tag == 6) {
            
            if (subString.length > 2) {
                if (tag == 6) {
                    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
                } else {
                    [self nextFieldBecomeFirstResponder:textField];
                }
            }
            else if (subString.intValue > (tag == 3 || tag == 6 ? 31 : 12)) {
                return NO;
            }
            else {
                return YES;
            }
        }
        return YES;
    }
    else {
        return YES;
    }
    
}

- (void)nextFieldBecomeFirstResponder:(UITextField *)textField {

    UITextField *nextField = [self.view viewWithTag:textField.tag + 1];
    [nextField becomeFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
