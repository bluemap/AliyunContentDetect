/*
 *****************************************************************************
 * Copyright (C) 2005-2014 UC Mobile Limited. All Rights Reserved
 * File			: ObserverContainer.h
 *
 * Description	: ObserverContainer  封装观察者（或类似）的容器，在添加和删除等操作时实现数据保护
 * Author		: bluemap@163.com
 *
 * History		: Creation, 14-8-23, bluemap@163.com, Create the file
 ******************************************************************************
 **/

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**************************************************************
 注意 ObserverContainer 只能在主线程中使用！！！
 **************************************************************/
@interface ObserverContainer<__covariant ObjectType> : NSObject

- (instancetype)initWithThreadFlag:(BOOL)allowsUsingInThread;

- (BOOL)addObserver:(ObjectType)observer;
- (BOOL)removeObserver:(ObjectType)observer;
- (void)removeAllObservers;

- (int)observerCount;

- (void)enumerateObjectsUsingBlock:(void (^)(ObjectType observer, NSUInteger idx, BOOL *stop))block;
- (void)sortUsingComparator:(NSComparisonResult(^)(ObjectType observer1, ObjectType observer2))cmptr;

@end

NS_ASSUME_NONNULL_END
