//
//  MethodViewController.m
//  ReactiveCocoa
//
//  Created by 隋东晗 on 16/9/3.
//  Copyright © 2016年 Du_work. All rights reserved.
//

#import "MethodViewController.h"
#import "RedView.h"
//#import <RACEx>
@interface MethodViewController ()

@end

@implementation MethodViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self rac_signalForSelector];
    [self rac_addObserverForName];
}
- (void)rac_signalForSelector {
    RedView *redV = [[RedView alloc] initWithFrame:CGRectMake(0, 50, 100, 100)];
    redV.tag = 10001;
    [self.view addSubview:redV];
    [[redV rac_signalForSelector:@selector(btnClick:)] subscribeNext:^(id x) {
        NSLog(@"i am did");
    }];
    [[redV rac_valuesAndChangesForKeyPath:@"center" options:NSKeyValueObservingOptionNew observer:nil] subscribeNext:^(id x) {
        NSLog(@"en able changge");
    }];
    
}
- (void)rac_addObserverForName {
    UITextField *textFile = [UITextField new];
    textFile.frame = CGRectMake(0, 100, 100, 30);
    textFile.placeholder = @"I am here";
    [self.view addSubview:textFile];
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:UIKeyboardWillShowNotification object:nil] subscribeNext:^(id x) {
        NSLog(@"keyBoard will Show");
    }];
    
    
    RACSignal *request1 = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        
        // 发送请求1
        [subscriber sendNext:@"发送请求1"];
        return nil;
    }];
    
    RACSignal *request2 = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        // 发送请求2
        [subscriber sendNext:@"发送请求2"];
        return nil;
    }];
    [self rac_liftSelector:@selector(updateUIWithR1:r2:) withSignalsFromArray:@[request1, request2]];
    
    RedView *redV = [self.view viewWithTag:10001];
    RAC(redV.name,text) = textFile.rac_textSignal;
    
    [RACObserve(redV, center) subscribeNext:^(id x) {
        NSLog(@"value = %@", x);
    }];
//    weakify(self);
    
}

- (void)updateUIWithR1:(id )r1 r2:(id)r2 {
    NSLog(@"togeter %@ %@", r1, r2);
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
