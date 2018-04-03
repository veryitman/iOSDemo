//
//  MZResolveClassMethodController.m
//  MZRuntimeMsgForward
//
//  Created by mark.zhang on 30/03/2018.
//  Copyright © 2018 IDS. All rights reserved.
//

#import "MZResolveClassMethodController.h"
#import "MZTempObj.h"
#import <objc/runtime.h>

static NSString * const sPerformClassMethodName = @"veryClassMethod";

@interface MZResolveClassMethodController ()

@end


@implementation MZResolveClassMethodController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = @"类方法的转发流程";
    
    // 运行类方法
    SEL selector = NSSelectorFromString(sPerformClassMethodName);
    SuppressPerformSelectorLeakWarning(
        [[self class] performSelector:selector withObject:nil];
    );
}

+ (BOOL)resolveClassMethod:(SEL)sel
{
    NSLog(@"---veryitman--- 1--- +resolveClassMethod. selector: %@", NSStringFromSelector(sel));
    
    NSString *methodName = NSStringFromSelector(sel);
    
    // 这里故意将 sPerformClassMethodName 改为 @"", 为了流程往下走
    if ([@"" isEqualToString:methodName]) {
        
        // 获取 MetaClass
        Class predicateMetaClass = objc_getMetaClass([NSStringFromClass(self) UTF8String]);
        // 根据 metaClass 获取方法的实现
        IMP impletor = class_getMethodImplementation(predicateMetaClass, @selector(proxyMethod));
        // 获取类方法
        Method predicateMethod = class_getClassMethod(predicateMetaClass, @selector(proxyMethod));
        const char *encoding = method_getTypeEncoding(predicateMethod);
        
        // 动态添加类方法
        class_addMethod(predicateMetaClass, sel, impletor, encoding);
        
        return YES;
    }
    
    return [super resolveClassMethod:sel];
}

+ (id)forwardingTargetForSelector:(SEL)aSelector
{
    NSLog(@"---veryitman--- 2--- +forwardingTargetForSelector");
    
    NSString *selectorName = NSStringFromSelector(aSelector);
    
    if ([sPerformClassMethodName isEqualToString:selectorName]) {
        
        // 注意1: 也可在此转发实例方法
#if 0
        // 让 MZTempObj 去执行 aSelector, 实现消息的转发
        MZTempObj *myobject = [[MZTempObj alloc] init];
        
        return myobject;
#endif
        
        // 转发类方法对应返回类对象
        return [MZTempObj class];
    }
    
    id obj = [super forwardingTargetForSelector:aSelector];
    
    return obj;
}

+ (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector
{
    NSLog(@"---veryitman--- 3--- +methodSignatureForSelector");
    
    // 找出对应的 aSelector 签名
    NSMethodSignature *signature = [super methodSignatureForSelector:aSelector];
    
    // 注意2: 也可以在此获取实例方法的签名
#if 0
    if (nil == signature) {
        
        // 是否有 aSelector
        if ([MZTempObj instancesRespondToSelector:aSelector]) {
            signature = [MZTempObj instanceMethodSignatureForSelector:aSelector];
        }
    }
    
    return signature;
#endif
    
    if (nil == signature) {
        
        // 是否有 aSelector
        if ([MZTempObj respondsToSelector:aSelector]) {
            
            //methodSignatureForSelector 可以获取类方法和实例方法的签名
            //instanceMethodSignatureForSelector只能获取实例方法的签名
            signature = [MZTempObj methodSignatureForSelector:aSelector];
        }
    }
    
    return signature;
}

+ (void)forwardInvocation:(NSInvocation *)anInvocation
{
    NSLog(@"---veryitman--- 4--- +forwardInvocation");
    
    // 注意3: 也可以调用实例方法
#if 0
    if ([MZTempObj instancesRespondToSelector:anInvocation.selector]) {
        [anInvocation invokeWithTarget:[[MZTempObj alloc] init]];
    }
    else {
        [super forwardInvocation:anInvocation];
    }
    
    return;
#endif
    
    if ([MZTempObj respondsToSelector:anInvocation.selector]) {
        
        // 这里转发的是 MZTempObj Class, 不是对象
        [anInvocation invokeWithTarget:[MZTempObj class]];
    }
    else {
        [super forwardInvocation:anInvocation];
    }
}

+ (void)doesNotRecognizeSelector:(SEL)aSelector
{
    NSLog(@"---veryitman--- 5--- +doesNotRecognizeSelector: %@", NSStringFromSelector(aSelector));
}

+ (void)proxyMethod
{
    NSLog(@"---veryitman--- +proxyMethod of class's method for OC.");
}

@end
