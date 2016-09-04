//
//  RedView.m
//  ReactiveCocoa
//
//  Created by 隋东晗 on 16/9/3.
//  Copyright © 2016年 Du_work. All rights reserved.
//

#import "RedView.h"

@implementation RedView
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor orangeColor];
        self.enable = @"false";
        [self createSubject];
    }
    return self;
}

- (void)createSubject {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 100, 50);
    button.backgroundColor = [UIColor redColor];
    [button setTitle:@"did Me" forState:UIControlStateNormal];
//    [button addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [[button rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        NSLog(@"I am did");
    }];
    [self addSubview:button];
    
    self.name = [UILabel new];
    self.name.backgroundColor = [UIColor whiteColor];
    self.name.font = [UIFont systemFontOfSize:12];
    [self addSubview:self.name];
    [self.name mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@20);
        make.top.offset(200);
    }];
}

- (void)btnClick:(UIButton *)sender {
    self.backgroundColor = [UIColor redColor];
    self.enable = @"true";
    self.center = CGPointMake(40, 40);
}
@end
