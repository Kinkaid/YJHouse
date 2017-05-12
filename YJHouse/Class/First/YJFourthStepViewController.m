//
//  YJFourthStepViewController.m
//  YJHouse
//
//  Created by 刘金凯 on 2017/4/21.
//  Copyright © 2017年 刘金凯. All rights reserved.
//

#import "YJFourthStepViewController.h"
#import "YJFourthStepPreview.h"
#import "YJFiveStepViewController.h"
@interface YJFourthStepViewController ()
@property (weak, nonatomic) IBOutlet UIView *myView;
@property (nonatomic,strong) NSMutableArray *oriCenterAry;
@property (assign, nonatomic) CGPoint startP;
@property (assign, nonatomic) CGPoint buttonP;
@end

@implementation YJFourthStepViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationBar.hidden = YES;
    YJFourthStepPreview *view = [[YJFourthStepPreview alloc] initWithFrame:CGRectMake(0, 0, APP_SCREEN_WIDTH, APP_SCREEN_HEIGHT)];
    [self.view addSubview:view];
    self.oriCenterAry = [@[] mutableCopy];
    for (int i=0;i<5 ; i++) {
        UIButton *btn = [self.view viewWithTag:i+1];
        [self.oriCenterAry addObject:btn];
        UILongPressGestureRecognizer * longGes = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressClick:)];
        [btn addGestureRecognizer:longGes];
    }
}
- (void)settingButtonFrame {
    // 设置按钮初始位置
    for (NSInteger i = 0; i < self.oriCenterAry.count; i++) {
        UIButton *btn = [self.view viewWithTag:i];
        btn.center =CGPointMake((APP_SCREEN_WIDTH / 5.0) / 2.0 + ((APP_SCREEN_WIDTH / 5.0) * i), 224);
    }
}
- (void)longPressClick:(UIGestureRecognizer *)longGes {
    UIButton * currentBtn = (UIButton *)longGes.view;
    if (UIGestureRecognizerStateBegan == longGes.state) {
        [UIView animateWithDuration:0.2 animations:^{
            currentBtn.transform = CGAffineTransformScale(currentBtn.transform, 1.4, 1.4);
            currentBtn.alpha = 0.7f;
            _startP = [longGes locationInView:currentBtn];
            _buttonP = currentBtn.center;
        }];
    }
    
    if (UIGestureRecognizerStateChanged == longGes.state) {
        CGPoint newP = [longGes locationInView:currentBtn];
        CGFloat movedX = newP.x - _startP.x;
        CGFloat movedY = newP.y - _startP.y;
        currentBtn.center = CGPointMake(currentBtn.center.x + movedX, currentBtn.center.y + movedY);
        
        // 获取当前按钮的索引
        NSInteger fromIndex = currentBtn.tag - 1;
        // 获取目标移动索引
        NSInteger toIndex = [self getMovedIndexByCurrentButton:currentBtn];
        
        if (toIndex < 0) {
            return;
        } else {
            currentBtn.tag = toIndex + 1;
            // 按钮向后移动
            if (fromIndex < toIndex) {
                
                for (NSInteger i = fromIndex; i < toIndex; i++) {
                    // 拿到下一个按钮
                    UIButton * nextBtn = self.oriCenterAry[i + 1];
                    CGPoint tempP = nextBtn.center;
                    [UIView animateWithDuration:0.5 animations:^{
                        nextBtn.center = _buttonP;
                    }];
                    _buttonP = tempP;
                    nextBtn.tag = i +1;
                }
                [self sortArray];
            } else if(fromIndex > toIndex) { // 按钮向前移动
                
                for (NSInteger i = fromIndex; i > toIndex; i--) {
                    UIButton * previousBtn = self.oriCenterAry[i - 1];
                    CGPoint tempP = previousBtn.center;
                    [UIView animateWithDuration:0.5 animations:^{
                        previousBtn.center = _buttonP;
                    }];
                    _buttonP = tempP;
                    previousBtn.tag = i +1;
                }
                [self sortArray];
            }
        }
    }
    // 手指松开之后 进行的处理
    if (UIGestureRecognizerStateEnded == longGes.state) {
        [UIView animateWithDuration:0.2 animations:^{
            currentBtn.transform = CGAffineTransformIdentity;
            currentBtn.alpha = 1.0f;
            currentBtn.center = _buttonP;
        }];
    }
}
- (void)sortArray {
    // 对已改变按钮的数组进行排序
    [self.oriCenterAry sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        UIButton *temp1 = (UIButton *)obj1;
        UIButton *temp2 = (UIButton *)obj2;
        return temp1.tag > temp2.tag;    //将tag值大的按钮向后移
    }];
    
}
- (NSInteger)getMovedIndexByCurrentButton:(UIButton *)currentButton {
    for (NSInteger i = 0; i<self.oriCenterAry.count ; i++) {
        UIButton * button = self.oriCenterAry[i];
        if (!currentButton || button != currentButton) {
            if (CGRectContainsPoint(button.frame, currentButton.center)) {
                return i;
            }
        }
    }
    return -1;
}
- (IBAction)nextStepAction:(id)sender {
    for (int i=0; i<5; i++) {
        UIButton *btn = self.oriCenterAry[i];
        YJLog(@"%@",btn.titleLabel.text);
    }
    YJFiveStepViewController *vc = [[YJFiveStepViewController alloc] init];
    PushController(vc);
}

@end
