//
//  ViewController.m
//  ReactiveCocoa
//
//  Created by Du_work on 16/8/9.
//  Copyright © 2016年 Du_work. All rights reserved.
//

#import "ViewController.h"
#import "NextViewController.h"
#import "MethodViewController.h"
@interface ViewController ()

@property(nonatomic, strong) RACCommand *command;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //RACSignal
    //[self RACSignal];
    
    
    
    //RACSubject | RACReplaySubject
//    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
//    button.frame = CGRectMake(0, 0, 100, 50);
//    button.backgroundColor = [UIColor redColor];
//    [button setTitle:@"Next " forState:UIControlStateNormal];
//    [button addTarget:self action:@selector(pushNextViewController) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:button];
//    [button mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(@30);
//        make.top.equalTo(@100);
//    }];
    
    
    
    //RACSequence NSDictionary
//    [self NSDictionaryChangeModel];
    //NSArray
//    [self arrayChangeModel];
//    [self RACCommand];
//    [self RACMuliticastConnection];
    
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(0, 0, 100, 50);
        button.backgroundColor = [UIColor redColor];
        [button setTitle:@"Method " forState:UIControlStateNormal];
        [button addTarget:self action:@selector(pushMethodViewController) forControlEvents:UIControlEventTouchUpInside];
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


/**
 RACSequence(Sequence序列) 集合用于代替NSArray、NSDictionary 用来快速便利数组和字典
 */


/**
 字典转模型
 遍历字典,遍历出来的键值对会包装成RACTuple(元组对象)
 */
- (void)NSDictionaryChangeModel {
    NSDictionary *dics = @{@1:@1,@2:@2,@3:@3};
    //RACTuple *x | id x 结果一样
    [dics.rac_sequence.signal subscribeNext:^(RACTuple *x) {
        //解包元组
        RACTupleUnpack(NSString *key, NSString *value) = x;
        NSLog(@"key = %@ value = %@", key, value);
        
    }];
    
}
/**
 数组转模型
 */
- (void)arrayChangeModel {
    NSArray *numbers = @[@1,@2,@3];
    /**
     革命三步走
     1: 将数组经过 numbers.rac_sequence 转换成RACSequence 这个集合类
     2: 将RACSequence 转换成信号
     3: 订阅信号激活信号
     */
//    [numbers.rac_sequence.signal subscribeNext:^(id x) {
//        NSLog(@"%@", x);
//    }];
    NSMutableArray *ar = [NSMutableArray array];
    [[numbers.rac_sequence map:^id(id value) {
        [ar addObject:value];
        return ar;
    }] array];
    
    NSLog(@"%@", ar);
    
}
/**
 RACCommand 用于处理事件的类，可以吧事件处理和事件中的数据包装到此类中，可以监听整个事件的流程
 二、RACCommand使用注意:
 // 1.signalBlock必须要返回一个信号，不能传nil.
 // 2.如果不想要传递信号，直接创建空的信号[RACSignal empty];
 // 3.RACCommand中信号如果数据传递完，必须调用[subscriber sendCompleted]，这时命令才会执行完毕，否则永远处于执行中。
 // 4.RACCommand需要被强引用，否则接收不到RACCommand中的信号，因此RACCommand中的信号是延迟发送的。

 */
- (void)RACCommand {
    
    __block NSInteger num = 0;
    //1
    RACCommand *command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        //如果返回空的信号则需要
//        return [RACSignal empty];
        
        return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            [subscriber sendNext:@"清气数据"];
            // 注意：数据传递完，最好调用sendCompleted，这时命令才执行完毕
//            [subscriber sendCompleted];
//            num++;
//            if (num == 2) {
            //调用此方法后会再次发送一次信号只不过是结束的信号
                [subscriber sendCompleted];
//            }
            return nil;
        }];
    }];
    
    //RACCommand需要强引用不要被销毁了否则接手不到信号
    _command = command;
    //2,订阅RACCommand中的信号 2, 3据我了解是一样的
    [command.executionSignals subscribeNext:^(id x) {
        
        [x subscribeNext:^(id x) {
            NSLog(@"----%@",x);
        }];
    }];
    //3 switchToLatest:用于signal of signals，获取signal of signals发出的最新信号,也就是可以直接拿到RACCommand中的信号
    [command.executionSignals.switchToLatest subscribeNext:^(id x) {
        NSLog(@"++%@",x);
    }];
//    4
    [[command.executing skip:1] subscribeNext:^(id x) {
        if ([x boolValue] == true) {
           NSLog(@"***%@",x);
        } else {
           NSLog(@"=== %@",x);
        }
    }];
    //5
    [self.command execute:@1];
//    [self.command execute:@2];
}
/**
 用于一个信号多次被订阅后，避免重复调用block，造成副作用，
 比如说：请求数据的时候两个方法都订阅了这个请求数据的信号，一个接口调用两次无意义还浪费时间
 两次订阅保存到数组中，调用connect后一起sendNext
 */
- (void)RACMuliticastConnection {
    RACSignal *signal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
//        [subscriber sendNext:@2];
        NSLog(@"发送请求");
        return nil;
    }];
    //下面不写的话，订阅一次信号就会调用一次信号内部的block方法
    RACMulticastConnection *connection = [signal publish];

    [connection.signal subscribeNext:^(id x) {
        NSLog(@"订阅信号");
    }];
    [connection.signal subscribeNext:^(id x) {
        NSLog(@"订阅信号");
    }];
    [connection connect];
}

- (void)pushMethodViewController {
    MethodViewController *methodVC = [MethodViewController new];
    [self.navigationController pushViewController:methodVC animated:true];
}
@end
