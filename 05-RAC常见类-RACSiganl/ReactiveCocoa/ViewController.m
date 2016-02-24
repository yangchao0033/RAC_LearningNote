//
//  ViewController.m
//  ReactiveCocoa
//
//  Created by yz on 15/9/23.
//  Copyright © 2015年 yz. All rights reserved.
//

#import "ViewController.h"

#import "ReactiveCocoa.h"


@interface ViewController ()

@end

@implementation ViewController

// 讲解：1. RACSignal使用步骤 2.RACSignal底层实现 3.每个block调用时刻

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
//     RACSignal使用步骤：
//     1.创建信号 + (RACSignal *)createSignal:(RACDisposable * (^)(id<RACSubscriber> subscriber))didSubscribe
//     2.发送信号 - (void)sendNext:(id)value
    RACSignal *signal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        
        // 发送信号了
        [subscriber sendNext:@"信号1"];
        
        // 如果信号发完就不发了，调用complete
        [subscriber sendCompleted]; // 这样内部会调用dispose方法销毁
        
        return [RACDisposable disposableWithBlock:^{
            NSLog(@"信号被销毁了");
        }];
    }];

//     3.订阅信号,才会激活信号. - (RACDisposable *)subscribeNext:(void (^)(id x))nextBlock
//    
//     RACSignal底层实现：
//     1.创建信号，首先把didSubscribe保存到信号中，还不会触发。
//     2.当信号被订阅，也就是调用signal的subscribeNext:nextBlock
//     2.2 subscribeNext内部会创建订阅者subscriber，并且把nextBlock保存到subscriber中。
//     2.1 subscribeNext内部会调用siganl的didSubscribe
//     3.siganl的didSubscribe中调用[subscriber sendNext:@1];
//     3.1 sendNext底层其实就是执行subscriber的nextBlock
    
    
    // 1.创建信号
    RACSignal *siganl = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        
        // block调用时刻：每当有订阅者订阅信号，就会调用block。
        
        // 2.发送信号
        [subscriber sendNext:@1];
        
        // 如果不在发送，最好发送信号完成，内部会自动调用[RACDisposable disposable]取消订阅信号。
//        [subscriber sendCompleted];
 
        return [RACDisposable disposableWithBlock:^{
            
            // block调用时刻：当信号发送完成或者发送错误，就会自动执行这个block,取消订阅信号。
            
            // 执行完Block后，当前信号就不在被订阅了。
            
            NSLog(@"信号被销毁");
            
        }];
    }];
    
    // 3.订阅信号,才会激活信号.
    [siganl subscribeNext:^(id x) {
        // block调用时刻：每当有信号发出数据，就会调用block.
//        NSLog(@"接收到数据:%@",x);
    }];
    
    [[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        
        [subscriber sendNext:@"信号2"];
        
        // 发完了
//        [subscriber sendCompleted];
        // 发错了
        NSError *error = [[NSError alloc] initWithDomain:@"superyang" code:2 userInfo:@{@"错误":@"一个super自定义的错误"}];
//        [subscriber sendError:error];
        
        return [RACDisposable disposableWithBlock:^{
            NSLog(@"信号被销毁了");
        }];
    }] subscribeNext:^(id x) {
        NSLog(@"收到消息了%@", x);
    }];
    
    
    
    
}


@end
