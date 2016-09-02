//
//  ViewController.m
//  ReactiveCocoa
//
//  Created by Du_work on 16/8/9.
//  Copyright © 2016年 Du_work. All rights reserved.
//

#import "ViewController.h"
#import "NextViewController.h"

@interface ViewController ()


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    [self RACSignal];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 100, 50);
    button.backgroundColor = [UIColor redColor];
    [button setTitle:@"Next " forState:UIControlStateNormal];
    [button addTarget:self action:@selector(pushNextViewController) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@30);
        make.top.equalTo(@100);
    }];
}
/**
 RACSignal 信号类
 RACSubscriber 订阅者用于发送信号是一个Delegate并不是一个类
 RACDisposable 用于取消订阅和清理资源 如果调用[subscriber sendCompleted]||[subscriber sendError];则自动调用这个方法(disposableWithBlock)
 */
- (void)RACSignal {
    RACSignal *racS = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
       
        [subscriber sendNext:@1];
        [subscriber sendCompleted];
//        return nil;
        return [RACDisposable disposableWithBlock:^{
            
        }];
    }];
    //订阅信号，才能激活
    [racS subscribeNext:^(id x) {
        NSLog(@"信号来了");
    }];
    
}
/**
 * RACSubject | RACReplaySubject
 * 信号提供者，自己可以充当信号，又能发送信号。
 */
- (void)pushNextViewController {
    NextViewController *next = [NextViewController new];
    RACReplaySubject *replaySubject = [RACReplaySubject subject];
    next.replaySubject = replaySubject;
    [replaySubject subscribeNext:^(id x) {
        NSLog(@"更新数据");
        if ([x isKindOfClass:[NSDictionary class]]) {
            NSLog(@"更新数据字典");
        }
        if ([x isKindOfClass:[NSArray class]]) {
            NSLog(@"更新数据数组");
        }
    }];
    [self.navigationController pushViewController:next animated:YES];
    
}

/**
 RACTuple 元组，类似NSArray用来包装值
 */
@end
