//
//  MZDyncAddMethodController.m
//  MZRuntimeMsgForward
//
//  Created by mark.zhang on 01/04/2018.
//  Copyright © 2018 IDS. All rights reserved.
//

#import "MZDyncAddMethodController.h"
#import <objc/runtime.h>

@implementation Student

- (instancetype)init
{
    self = [super init];
    
    if (self) {
        
#if 0
        SEL proxySelector = NSSelectorFromString(@"studentWalkImp");
        IMP impletor = class_getMethodImplementation([self class], proxySelector);

        // 获取实例方法
        Method method = class_getInstanceMethod([self class], proxySelector);
        const char *types = method_getTypeEncoding(method);
        SEL origSel = NSSelectorFromString(@"walk");
        class_addMethod([self class], origSel, impletor, types);

        // C 实现
        {
            SEL origSel = NSSelectorFromString(@"walk");
            class_addMethod([self class], origSel, (IMP)studentWalkImp, "v:@");
        }
#endif
        
        // 获取 MetaClass, 类方法不可以使用 [self class]
        Class metaCls = objc_getMetaClass([NSStringFromClass([self class]) UTF8String]);
        
        SEL proxySelector = NSSelectorFromString(@"clsImp");
        IMP impletor = class_getMethodImplementation(metaCls, proxySelector);
        
        // 获取类方法
        Method method = class_getClassMethod([self class], proxySelector);
        
        const char *types = method_getTypeEncoding(method);
        SEL origSel = NSSelectorFromString(@"walk");
        
        class_addMethod(metaCls, origSel, impletor, types);
    }
    
    return self;
}

- (void)studentWalkImp
{
    NSLog(@"---veryitman--- Student studentWalkImp");
}

void studentWalkImp()
{
    NSLog(@"---veryitman--- Student studentWalkImp");
}

+ (void)clsImp
{
    NSLog(@"---veryitman--- Student clsImp");
}

@end


@interface MZDyncAddMethodController ()

@end

@implementation MZDyncAddMethodController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    Student *stud = [[Student alloc] init];
    //[stud performSelector:NSSelectorFromString(@"walk") withObject:nil];
    
    [[stud class] performSelector:NSSelectorFromString(@"walk") withObject:nil];
}

@end
