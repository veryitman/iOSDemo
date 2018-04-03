//
//  MZResolveInstanceMethodController.m
//  MZRuntimeMsgForward
//
//  Created by mark.zhang on 30/03/2018.
//  Copyright © 2018 IDS. All rights reserved.
//

#import "MZResolveInstanceMethodController.h"
#import "MZTempObj.h"
#import <objc/runtime.h>

static NSString * const sPerformInstanceMethodName = @"veryTestMethod";

@interface MZResolveInstanceMethodController ()

@end


@implementation MZResolveInstanceMethodController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.navigationItem.title = @"实例方法的转发流程";
    
    // 运行实例方法
    SEL selector = NSSelectorFromString(sPerformInstanceMethodName);
    
    SuppressPerformSelectorLeakWarning(
        [self performSelector:selector withObject:nil];
    );
}

+ (BOOL)resolveInstanceMethod:(SEL)sel
{
    NSLog(@"---veryitman--- 1--- +resolveInstanceMethod: %@", NSStringFromSelector(sel));
    
    NSString *methodName = NSStringFromSelector(sel);
    
    // 这里可以将 @"" 改为 sPerformInstanceMethodName
    if ([@"" isEqualToString:methodName]) {
        
        SEL proxySelector = NSSelectorFromString(@"proxyMethod");
        IMP impletor = class_getMethodImplementation(self, proxySelector);
        
        // 获取实例方法
        Method method = class_getInstanceMethod(self, proxySelector);
        const char *types = method_getTypeEncoding(method);
        
        //参数1：给谁添加
        //参数2：添加的selector
        //参数3：添加的imp实现
        //参数4："v@:"方法的签名，代表没有参数的方法
        
        /* BOOL class_addMethod(Class _Nullable cls,
                             SEL _Nonnull name,
                             IMP _Nonnull imp,
                        const char * _Nullable types) */
        
        // 添加 C 的函数
        //class_addMethod([self class], sel, (IMP)proxyMethod,"v@:");
        
        // 添加 OC 的函数
        class_addMethod([self class], sel, impletor, types);
        
        return YES;
    }
    
    return [super resolveInstanceMethod:sel];
}

/// 转发给对应的某个对象来执行 aSelector
- (id)forwardingTargetForSelector:(SEL)aSelector
{
    NSLog(@"---veryitman--- 2--- -forwardingTargetForSelector");
    
    NSString *selectorName = NSStringFromSelector(aSelector);
    
    // 这里可以将 @"" 改为 sPerformInstanceMethodName
    if ([@"" isEqualToString:selectorName]) {
        
        // 让 MZTempObj 去执行 aSelector, 实现消息的转发
        MZTempObj *myobject = [[MZTempObj alloc] init];
        
        return myobject;
    }
    
    id obj = [super forwardingTargetForSelector:aSelector];
    
    return obj;
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector
{
    NSLog(@"---veryitman--- 3--- -methodSignatureForSelector");
    
    // 找出对应的 aSelector 签名
    NSMethodSignature *signature = [super methodSignatureForSelector:aSelector];
    
    if (nil == signature) {
        
        // 是否有 aSelector
        if ([MZTempObj instancesRespondToSelector:aSelector]) {
            
            signature = [MZTempObj instanceMethodSignatureForSelector:aSelector];
            
            // 返回指定的函数签名
            //signature = [MZTempObj instanceMethodSignatureForSelector:NSSelectorFromString(@"veryMethod")];
        }
    }
    
    return signature;
}

- (void)forwardInvocation:(NSInvocation *)anInvocation
{
    NSLog(@"---veryitman--- 4--- -forwardInvocation");
    
    // 改变转发执行的函数
    //anInvocation.selector = NSSelectorFromString(@"veryMethod");
    
    if ([MZTempObj instancesRespondToSelector:anInvocation.selector]) {
        [anInvocation invokeWithTarget:[[MZTempObj alloc] init]];
    }
    else {
        [super forwardInvocation:anInvocation];
    }
}

- (void)doesNotRecognizeSelector:(SEL)aSelector
{
    NSLog(@"---veryitman--- 5--- -doesNotRecognizeSelector: %@", NSStringFromSelector(aSelector));
}

// OC 实现
- (void)proxyMethod
{
    NSLog(@"---veryitman--- -proxyMethod of instance's method for OC.");
}

// C 实现
void proxyMethod() //(id self, SEL _cmd)
{
    NSLog(@"---veryitman--- proxyMethod for C");
}

@end
