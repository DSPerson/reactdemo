//
//  NextViewController.m
//  ReactiveCocoa
//
//  Created by Du_work on 16/9/2.
//  Copyright © 2016年 Du_work. All rights reserved.
//

#import "NextViewController.h"
//测试RACSubject 和RACRelaySubject(将下面宏定义注释掉)
#define RACSubjectDe
@implementation NextViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 100, 50);
    button.backgroundColor = [UIColor redColor];
    [button setTitle:@"回去" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(backtViewController) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@30);
        make.top.equalTo(@100);
    }];
    
    
#ifdef RACSubjectDe
    [self RACSubject];
#else
    [self RACReplaySubject];
#endif
}

- (void)backtViewController {
    if (self.replaySubject) {
        [self.replaySubject sendNext:@{@"name":@"dushuai"}];
    }
    
}



#ifdef RACSubjectDe
// RACSubject:底层实现和RACSignal不一样。
// 1.调用subscribeNext订阅信号，只是把订阅者保存起来，并且订阅者的nextBlock已经赋值了。
// 2.调用sendNext发送信号，遍历刚刚保存的所有订阅者，一个一个调用订阅者的nextBlock。
- (void)RACSubject {
    RACSubject *racsubject = [RACSubject subject];
    [racsubject subscribeNext:^(id x) {
        NSLog(@"第一个订阅者");
    }];
    [racsubject subscribeNext:^(id x) {
        NSLog(@"第二个订阅者");
    }];
    [racsubject sendNext:@"Notification"];
}
#else
// RACReplaySubject:底层实现和RACSubject不一样。
// 1.调用sendNext发送信号，把值保存起来，然后遍历刚刚保存的所有订阅者，一个一个调用订阅者的nextBlock。
// 2.调用subscribeNext订阅信号，遍历保存的所有值，一个一个调用订阅者的nextBlock

// 如果想当一个信号被订阅，就重复播放之前所有值，需要先发送信号，在订阅信号。
// 也就是先保存值，在订阅值。(RACSubject就是先保存订阅者，在发送值)
- (void)RACReplaySubject {
    
    RACReplaySubject *racReplay = [RACReplaySubject subject];
    [racReplay sendNext:@"Notification"];
    
    [racReplay subscribeNext:^(id x) {
        NSLog(@"第一个订阅者");
    }];
    
    [racReplay subscribeNext:^(id x) {
        NSLog(@"第二个订阅者");
    }];
    
    
}
#endif

@end
