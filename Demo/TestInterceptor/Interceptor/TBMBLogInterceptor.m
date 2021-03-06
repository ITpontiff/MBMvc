/*
 * (C) 2007-2013 Alibaba Group Holding Limited
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License version 2 as
 * published by the Free Software Foundation.
 *
 *
 */
//
// Created by <a href="mailto:wentong@taobao.com">文通</a> on 13-1-2 下午11:12.
//


#import "TBMBLogInterceptor.h"
#import "TBMBCommandInvocation.h"
#import "TBMBGlobalFacade.h"
#import "TBMBUtil.h"

//这是一个拦截器 当调用的Command 方法返回 YES时 会发一个$$receiveLog:通知出去
@implementation TBMBLogInterceptor {

}
- (id)intercept:(id <TBMBCommandInvocation>)invocation {
    NSLog(@"invocation: %@", invocation);
    id ret = [invocation invoke];
    NSLog(@"Return: %@", ret);

    if ([ret isKindOfClass:[NSNumber class]] && [ret boolValue]) {
        TBMBGlobalSendNotificationForSELWithBody((@selector($$receiveLog:)),
                [NSString stringWithFormat:@"[%@][%d] has log @ %@", invocation.commandClass,
                                           TBMBIsNotificationProxy(invocation.notification), [NSDate date]]
        );
    } else {
        TBMBGlobalSendNotificationForSEL((@selector($$receiveNonLog:)));
    }
    return ret;
}


@end