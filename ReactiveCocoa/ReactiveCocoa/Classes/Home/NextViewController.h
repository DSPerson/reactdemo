//
//  NextViewController.h
//  ReactiveCocoa
//
//  Created by Du_work on 16/9/2.
//  Copyright © 2016年 Du_work. All rights reserved.
//

#import <UIKit/UIKit.h>
/**
 * 用RACSubject 代替代理方法
 */
@interface NextViewController : BaseViewController

/**
 *  是RACSubject的子类，可以先发送信息后再订阅信号
 */
@property (nonatomic, strong) RACReplaySubject *replaySubject;
// 必须先订阅后发送信息
@property (nonatomic, strong) RACSubject *subject;

@end
