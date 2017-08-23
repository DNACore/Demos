//
//  ViewController.m
//  UIDatePicker-Demo
//
//  Created by Encoder on 17/3/23.
//  Copyright © 2017年 Encoder. All rights reserved.
//

#import "ViewController.h"
#define FinalHour 17
@interface ViewController ()<UIPickerViewDelegate,UIPickerViewDataSource>
@property (weak, nonatomic) IBOutlet UIPickerView *customTimePickerView;
@property (strong,nonatomic) NSArray *todayHorArray;
@property (strong,nonatomic) NSArray *todayMinArray;
@property NSInteger nowHour;
@property NSInteger nowMinute;
@property NSInteger selectedHour;
@property NSInteger selectedMin;
@property BOOL isToday;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    _isToday = YES;
    _selectedHour = 0;
    _selectedMin = 0;

    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"HH"];
    NSDate *date = [NSDate date];
    _nowHour = [[dateFormatter stringFromDate:date] integerValue];
    [dateFormatter setDateFormat:@"mm"];
    _nowMinute = [[dateFormatter stringFromDate:date] integerValue];
    
    _todayHorArray = [self todayTimeList:9 to:17];
    _todayMinArray = [self todayHourMinuteList];
    [_customTimePickerView reloadAllComponents];
    [_customTimePickerView selectRow:0 inComponent:0 animated:YES];
    [self pickerView:_customTimePickerView didSelectRow:0 inComponent:0];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 2;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    switch (component) {
        case 0:
            return _todayHorArray.count;
            break;
        case 1:{
            if (_isToday && (_nowHour == _selectedHour)) {//优先判断当前时间，因为只要是在今天有效时间范围内，当前小时的分钟数总是返回正确的
                return _todayMinArray.count;
            }else if (_selectedHour == FinalHour){//判断是否选择了17时
                return 31;
            }
            else
            {
                return 60;
            }
        }
            break;
            
        default:
            return 0;
            break;
    }
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    switch (component) {
        case 0:
            return [[_todayHorArray objectAtIndex:row] stringValue];
            break;
        case 1:{
            if (_isToday && (_nowHour == _selectedHour)) {
                return [[_todayMinArray objectAtIndex:row] stringValue];
            }else{
                return [NSString stringWithFormat:@"%li",(long)row];
            }
        }
            break;
            
        default:
            return @"";
            break;
    }
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    switch (component) {
        case 0:
            _selectedHour = [[_todayHorArray objectAtIndex:row] integerValue];
            [_customTimePickerView reloadComponent:1];
            break;
        case 1:{
            if (_isToday && (_nowHour == _selectedHour)) {
                _selectedMin = [[_todayMinArray objectAtIndex:row] integerValue];
            }else{
                _selectedMin = row;
            }
        }
            break;
            
        default:
            break;
}
}

-(NSArray *)todayTimeList:(NSInteger)fromHour to:(NSInteger)toHour{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"HH"];
    NSDate *date = [NSDate date];
    NSInteger nowHour = [[dateFormatter stringFromDate:date] integerValue];
    NSLog(@"hour:----%@",[dateFormatter stringFromDate:date]);
    
    NSMutableArray *todayHourArray = [NSMutableArray array];
    
    if (fromHour<=nowHour) {
        for (NSInteger i = nowHour; i<=toHour; i++) {
            [todayHourArray addObject:[NSNumber numberWithInteger:i]];
        }
    }

    NSLog(@"----%@",todayHourArray);
    return todayHourArray.copy;
}

-(NSArray *)todayHourMinuteList{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"mm"];
    NSDate *date = [NSDate date];
    NSLog(@"min:----%@",[dateFormatter stringFromDate:date]);

    
    NSMutableArray *todayMinArray = [NSMutableArray array];
    if (_nowHour == FinalHour) {
        for (NSInteger i = _nowMinute; i<=30; i++) {
            [todayMinArray addObject:[NSNumber numberWithInteger:i]];
        }
    }else{
        for (NSInteger i = _nowMinute; i<=59; i++) {
            [todayMinArray addObject:[NSNumber numberWithInteger:i]];
        }
    }

    
    NSLog(@"----%@",todayMinArray);
    return todayMinArray.copy;
}


@end
