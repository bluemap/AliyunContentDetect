/*
 *****************************************************************************
 * Copyright (C) 2005-2014 UC Mobile Limited. All Rights Reserved
 * File			: ObserverContainer.m
 *
 * Description	: ObserverContainer  封装观察者（或类似）的容器，在添加和删除等操作时实现数据保护
 * Author		: bluemap@163.com
 *
 * History		: Creation, 14-8-23, bluemap@163.com, Create the file
 ******************************************************************************
 **/
#if ! __has_feature(objc_arc)
#error This file must be compiled with ARC. Use -fobjc-arc flag (or convert project to ARC).
#endif

#import "ObserverContainer.h"


@interface ObserverItem : NSObject
@property (nonatomic, weak) id observer;

+ (ObserverItem *)observerItemWith:(id)observer;
@end

#pragma mark -
@implementation ObserverItem

+ (ObserverItem *)observerItemWith:(id)observer
{
    ObserverItem *item = [[[self class] alloc] init];
    item.observer = observer;
    return item;
}

- (NSString *)description
{
    NSString *itemInfo = [NSString stringWithFormat:@"ObserverClass:%@", self.observer];
    return itemInfo;
}

@end


#pragma mark -
@interface ObserverContainer()

@property (nonatomic, assign) int iterativeRef; //标记迭代状态，设为int目的是解决循环迭代的问题
@property (nonatomic, assign) BOOL allowsUsingInThread;

@property (nonatomic, readonly) NSMutableArray<ObserverItem *> *normalList;
@property (nonatomic, retain) NSMutableArray<ObserverItem *> *increaseList; //需要添加到normallist中去的对象
@property (nonatomic, retain) NSMutableArray<ObserverItem *> *decreaseList; //需要从normallist中移除的对象
@end

@implementation ObserverContainer

- (instancetype)init
{
    return [self initWithThreadFlag:NO];
}

- (instancetype)initWithThreadFlag:(BOOL)allowsUsingInThread
{
    self = [super init];
    if (self)
    {
        _iterativeRef = 0;
        _allowsUsingInThread = allowsUsingInThread;
        _normalList = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)dealloc
{
}

- (NSMutableArray<ObserverItem *> *)increaseList
{
    if(nil == _increaseList)
    {
        _increaseList = [[NSMutableArray alloc] init];
    }
    
    return _increaseList;
}

- (NSMutableArray<ObserverItem *> *)decreaseList
{
    if(nil == _decreaseList)
    {
        _decreaseList = [[NSMutableArray alloc] init];
    }
    
    return _decreaseList;
}

- (BOOL)addObserver:(id)observer
{
    //assert(_allowsUsingInThread || [NSThread isMainThread]);
    if ([self isObserverExist:observer])
    {
        return NO;
    }
    
    if (_iterativeRef > 0)
    {
        [self addObserver:observer toArray:self.increaseList];
    }
    else
    {
        [self addObserver:observer toArray:self.normalList];
    }
    
    return YES;
}

- (BOOL)removeObserver:(id)observer
{
    assert(_allowsUsingInThread || [NSThread isMainThread]);
    BOOL foundInNormal = NO;
    if (_iterativeRef > 0)
    {
        for (ObserverItem *item in self.normalList)
        {
            if (observer == item.observer)
            {
                foundInNormal = YES;
                [self.decreaseList addObject:item];
                break;
            }
        }
    }
    else
    {
        foundInNormal = [self removeObserver:observer fromArray:self.normalList];
    }
    
    BOOL foundInIncrease = [self removeObserver:observer fromArray:self.increaseList];
    return (foundInNormal || foundInIncrease);
}

- (void)removeAllObservers
{
    [self.increaseList removeAllObjects];
    
    if (_iterativeRef > 0)
    {
        [self.decreaseList addObjectsFromArray:self.normalList];
    }
    else
    {
        [self.normalList removeAllObjects];
    }
}

- (BOOL)isObserverExist:(id)observer
{
    int count = 0;
    if ([self isObserver:observer inArray:self.increaseList])
    {
        ++count;
    }
    else if([self isObserver:observer inArray:self.normalList])
    {
        ++count;
    }
    
    return (count > 0);
}

#pragma mark assist functions
- (void)addObserver:(id)observer toArray:(NSMutableArray *)array
{
    ObserverItem *item = [ObserverItem observerItemWith:observer];
    [array addObject:item];
}

- (BOOL)removeObserver:(id)observer fromArray:(NSMutableArray *)array
{
    BOOL result = NO;
    @autoreleasepool {
        NSMutableArray *needDelArray = [[NSMutableArray alloc] init];
        
        for (ObserverItem *item in array)
        {
            if(observer == item.observer)
            {
                [needDelArray addObject:item];
                result = YES;
            }
            else if(nil == item.observer)
            {
                [needDelArray addObject:item];
            }
        }
        
        [array removeObjectsInArray:needDelArray];
    }

    return result;
}

//恢复观察者列表
- (void)recoverNormalList
{
    [self.normalList addObjectsFromArray:self.increaseList];
    [self.increaseList removeAllObjects];
    
    [self.normalList removeObjectsInArray:self.decreaseList];
    [self.decreaseList removeAllObjects];
}

- (BOOL)isObserver:(id)observer inArray:(NSArray *)array
{
    BOOL exist = NO;
    for (ObserverItem *item in array)
    {
        if (item.observer == observer)
        {
            exist = YES;
            break;
        }
    }
    return exist;
}

- (id)observerAtIndex:(int)index
{
    ObserverItem *item = nil;
    if (index < [self.normalList count])
    {
        item = (ObserverItem *)[self.normalList objectAtIndex:index];
    }
    
    return item.observer;
}

- (int)observerCount
{
    assert(_allowsUsingInThread || [NSThread isMainThread]);
    return (int)[self.normalList count];
}

- (void)sortUsingComparator:(NSComparisonResult(^)(id observer1, id observer2))cmptr
{
    assert(_allowsUsingInThread || [NSThread isMainThread]);
    if (cmptr)
    {
        ++_iterativeRef;
        
        [self.normalList sortUsingComparator:^NSComparisonResult(ObserverItem* obj1, ObserverItem* obj2) {
            return cmptr(obj1.observer, obj2.observer);
        }];
        
        if (0 == --_iterativeRef)
        {
            [self recoverNormalList];
        }
    }
}

- (void)enumerateObjectsUsingBlock:(void (^)(id , NSUInteger , BOOL *))block
{
    assert(_allowsUsingInThread || [NSThread isMainThread]);
    ++_iterativeRef;
    
    [self.normalList enumerateObjectsUsingBlock:^(ObserverItem* obj, NSUInteger idx, BOOL *stop) {
        if(obj.observer != nil)
        {
            block(obj.observer, idx, stop);
        }
    }];
    
    if (0 == --_iterativeRef)
    {
        [self recoverNormalList];
    }
}


@end
