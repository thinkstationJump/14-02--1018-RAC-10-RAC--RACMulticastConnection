//
//  ViewController.m
//  ReactiveCocoa框架
//
//  Created by apple on 15/10/18.
//  Copyright © 2015年 小码哥. All rights reserved.
//

#import "ViewController.h"

#import "ReactiveCocoa.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    // 一个信号即使被订阅多次,也只是发送一次请求
    // RACMulticastConnection:用于信号中请求数据,避免多次请求数据
    // 1.创建信号
    RACSignal *signal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        
        NSLog(@"发送请求");
        
        // 3.发送信号
        [subscriber sendNext:@"网络数据"];
        
        return nil;
    }];
    
    // 2.把信号转换成连接类
    RACMulticastConnection *connect = [signal publish];
    
    // 3.订阅连接类的信号,注意:一定是订阅连接类的信号,不再是源信号
    [connect.signal subscribeNext:^(id x) {
       
        NSLog(@"%@",x);
        
    }];
    
    [connect.signal subscribeNext:^(id x) {
        
        NSLog(@"%@",x);
        
    }];
    [connect.signal subscribeNext:^(id x) {
        
        NSLog(@"%@",x);
        
    }];
    
    // 4.连接
    [connect connect];

    /* 执行流程
     // 1.创建信号
        * 创建RACDynamicSignal,并且把didSubscribe保存到
        2.把信号转换成连接类
        * 创建信号提供者RACSubject
        * [self multicast:subject]:设置原始信号的多点传播subject,本质就是把subject设置为原始信号的订阅者
        * 创建RACMulticastConnection,把原始信号保存到_sourceSignal,把subject保存到_signal
        3.保存订阅者
        4.连接 [connect connect]
        * 订阅_sourceSignal,并且设置订阅者为subject
        5.执行didSubscribe
        6.[subject sendNext]遍历所有的订阅者发送信号
     */
}

/* RACSubject
    [RACSubject subscribeNext]:仅仅是保存订阅者
    [RACSubject sendNext:];遍历所有的订阅者发送信号
 
 */

/*
 2015-10-18 17:05:51.299 ReactiveCocoa框架[11749:2147650] 发送请求
 2015-10-18 17:05:51.299 ReactiveCocoa框架[11749:2147650] 接收到网络数据
 2015-10-18 17:05:51.299 ReactiveCocoa框架[11749:2147650] 接收到网络数据
 */
- (void)test
{
    // 1.创建信号
    RACSignal *signal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        
        NSLog(@"发送请求");
        
        // 3.发送信号
        [subscriber sendNext:@"网络数据"];
        
        return nil;
    }];
    
    // 2.订阅信号
    [signal subscribeNext:^(id x) {
        
        NSLog(@"接收到%@",x);
    }];
    
    [signal subscribeNext:^(id x) {
        
        NSLog(@"接收到%@",x);
    }];
    

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
