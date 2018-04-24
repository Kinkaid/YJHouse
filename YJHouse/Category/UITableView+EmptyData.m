//
//  UITableView+EmptyData.m
//  wadaowsc
//
//  Created by fangkuai on 2018/1/23.
//  Copyright © 2018年 刘金凯. All rights reserved.
//

#import "UITableView+EmptyData.h"
#import "EmptyDataView.h"
#import <objc/runtime.h>
@protocol FKTableViewDelegate <NSObject>
@optional
- (UIView   *)fk_noDataView;                //  完全自定义占位图
- (UIImage  *)fk_noDataViewImage;           //  使用默认占位图, 提供一张图片,    可不提供, 默认不显示
- (NSString *)fk_noDataViewMessage;         //  使用默认占位图, 提供显示文字,    可不提供, 默认为暂无数据
- (UIColor  *)fk_noDataViewMessageColor;    //  使用默认占位图, 提供显示文字颜色, 可不提供, 默认为灰色
- (NSNumber *)fk_noDataViewCenterYOffset;   //  使用默认占位图, CenterY 向下的偏移量
@end

@implementation UITableView (EmptyData)


/**
 加载时, 交换方法
 */
+ (void)load {
    //  只交换一次
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        Method reloadData    = class_getInstanceMethod(self, @selector(reloadData));
        Method fk_reloadData = class_getInstanceMethod(self, @selector(fk_reloadData));
        method_exchangeImplementations(reloadData, fk_reloadData);
        
        Method dealloc       = class_getInstanceMethod(self, NSSelectorFromString(@"dealloc"));
        Method fk_dealloc    = class_getInstanceMethod(self, @selector(fk_dealloc));
        method_exchangeImplementations(dealloc, fk_dealloc);
    });
}
/**
在 ReloadData 的时候检查数据
*/
- (void)fk_reloadData {
    
    [self fk_reloadData];
    
    //  忽略第一次加载
    if (![self isInitFinish]) {
        [self fk_havingData:YES];
        [self setIsInitFinish:YES];
        return ;
    }
    //  刷新完成之后检测数据量
    dispatch_async(dispatch_get_main_queue(), ^{
        
        NSInteger numberOfSections = [self numberOfSections];
        BOOL havingData = NO;
        for (NSInteger i = 0; i < numberOfSections; i++) {
            if ([self numberOfRowsInSection:i] > 0) {
                havingData = YES;
                break;
            }
        }
        
        [self fk_havingData:havingData];
    });
}

/**
 展示占位图
 */
- (void)fk_havingData:(BOOL)havingData {
    
    //  不需要显示占位图
    if (havingData) {
        [self freeNoDataViewIfNeeded];
        self.backgroundView = nil;
        return ;
    }
    
    //  不需要重复创建
    if (self.backgroundView) {
        return ;
    }
    
    //  自定义了占位图
    if ([self.delegate respondsToSelector:@selector(fk_noDataView)]) {
        self.backgroundView = [self.delegate performSelector:@selector(fk_noDataView)];
        return ;
    }
    //  使用自带的
    UIImage  *img   = nil;
    NSString *msg   = @"暂无数据";
    UIColor  *color = [UIColor ex_colorFromHexRGB:@"C0CCDA"];
    CGFloat  offset = 0;
    
    //  获取图片
    if ([self.delegate    respondsToSelector:@selector(fk_noDataViewImage)]) {
        img = [self.delegate performSelector:@selector(fk_noDataViewImage)];
    }
    //  获取文字
    if ([self.delegate    respondsToSelector:@selector(fk_noDataViewMessage)]) {
        msg = [self.delegate performSelector:@selector(fk_noDataViewMessage)];
    }
    //  获取颜色
    if ([self.delegate      respondsToSelector:@selector(fk_noDataViewMessageColor)]) {
        color = [self.delegate performSelector:@selector(fk_noDataViewMessageColor)];
    }
    //  获取偏移量
    if ([self.delegate        respondsToSelector:@selector(fk_noDataViewCenterYOffset)]) {
        offset = [[self.delegate performSelector:@selector(fk_noDataViewCenterYOffset)] floatValue];
    }
    
    //  创建占位图
    self.backgroundView = [self fk_defaultNoDataViewWithImage  :img message:msg color:color offsetY:offset];
}

/**
 默认的占位图
 */
- (UIView *)fk_defaultNoDataViewWithImage:(UIImage *)image message:(NSString *)message color:(UIColor *)color offsetY:(CGFloat)offset {
    
    //  计算位置, 垂直居中, 图片默认中心偏上.
    CGFloat sW = self.bounds.size.width;
    CGFloat cX = sW / 2;
    CGFloat cY = self.bounds.size.height * (1 - 0.618) + offset;
    CGFloat iW = image.size.width;
    CGFloat iH = image.size.height;
    
    //  图片
    UIImageView *imgView = [[UIImageView alloc] init];
    imgView.frame        = CGRectMake(cX - iW / 2, cY - iH / 2, iW, iH);
    imgView.image        = image;
    
    //  文字
    UILabel *label       = [[UILabel alloc] init];
    label.font           = [UIFont systemFontOfSize:17];
    label.textColor      = color;
    label.text           = message;
    label.textAlignment  = NSTextAlignmentCenter;
    label.frame          = CGRectMake(0, CGRectGetMaxY(imgView.frame) + 24, sW, label.font.lineHeight);
    
    //  视图
    EmptyDataView *view   = [[EmptyDataView alloc] init];
    [view addSubview:imgView];
    [view addSubview:label];
    
    //  实现跟随 TableView 滚动
    [view addObserver:self forKeyPath:kEmptyDataViewObserveKeyPath options:NSKeyValueObservingOptionNew context:nil];
    return view;
}


/**
 监听
 */
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:kEmptyDataViewObserveKeyPath]) {
        
        /**
         在 TableView 滚动 ContentOffset 改变时, 会同步改变 backgroundView 的 frame.origin.y
         可以实现, backgroundView 位置相对于 TableView 不动, 但是我们希望
         backgroundView 跟随 TableView 的滚动而滚动, 只能强制设置 frame.origin.y 永远为 0
         兼容 MJRefresh
         */
        CGRect frame = [[change objectForKey:NSKeyValueChangeNewKey] CGRectValue];
        if (frame.origin.y != 0) {
            frame.origin.y  = 0;
            self.backgroundView.frame = frame;
        }
    }
}

#pragma mark - 属性

/// 加载完数据的标记属性名
static NSString * const kFKTableViewPropertyInitFinish = @"kFKTableViewPropertyInitFinish";

/**
 设置已经加载完成数据了
 */
- (void)setIsInitFinish:(BOOL)finish {
    objc_setAssociatedObject(self, &kFKTableViewPropertyInitFinish, @(finish), OBJC_ASSOCIATION_ASSIGN);
}

/**
 是否已经加载完成数据
 */
- (BOOL)isInitFinish {
    id obj = objc_getAssociatedObject(self, &kFKTableViewPropertyInitFinish);
    return [obj boolValue];
}

/**
 移除 KVO 监听
 */
- (void)freeNoDataViewIfNeeded {
    
    if ([self.backgroundView isKindOfClass:[EmptyDataView class]]) {
        [self.backgroundView removeObserver:self forKeyPath:kEmptyDataViewObserveKeyPath context:nil];
    }
}

- (void)fk_dealloc {
    [self freeNoDataViewIfNeeded];
    [self fk_dealloc];
}

@end