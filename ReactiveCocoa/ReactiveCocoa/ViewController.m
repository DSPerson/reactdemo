//
//  ViewController.m
//  ReactiveCocoa
//
//  Created by Du_work on 16/8/9.
//  Copyright © 2016年 Du_work. All rights reserved.
//

#import "ViewController.h"
//#import <ReactiveCocoa/ReactiveCocoa.h>

//#import <ReactiveCocoa/ReactiveCocoa.h>

#import <Masonry/Masonry.h>

#import "ReactiveCocoa/ReactiveCocoa.h"
@interface ViewController ()

/**
 *  <#Description#>
 */
@property (nonatomic, strong) UITextField *usernameTextFiled;

/**
 *  <#Description#>
 */
@property (nonatomic, strong) UIButton *logInButton;

/**
 *  <#Description#>
 */
@property (nonatomic, copy) NSString *name;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    

    UITextField *name = [UITextField new];
    name.backgroundColor = [UIColor redColor];
    name.placeholder = @"名字";
    [[name.rac_textSignal filter:^BOOL(id value) {
        NSString *text = value;
        return text.length > 3;
    }] subscribeNext:^(id x) {
        NSLog(@"%@", x);
    }];
    [self.view addSubview:name];
    
    [name mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(30);
        make.height.offset(40);
        make.width.offset(200);
        make.top.equalTo(@50);
    }];
    
    UITextField *pass = [UITextField new];
    pass.backgroundColor = [UIColor redColor];
    pass.placeholder = @"密码";
    [self.view addSubview:pass];
    
    [pass mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(30);
         make.width.offset(200);
        make.height.offset(40);
        make.top.equalTo(name.mas_bottom).offset(10);
    }];
    
    
    
}
- (void)didRedView:(UIButton *)sender {
    
}

@end
