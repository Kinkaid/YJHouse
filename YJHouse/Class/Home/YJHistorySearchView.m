//
//  YJHistorySearchView.m
//  YJHouse
//
//  Created by 刘金凯 on 2017/2/24.
//  Copyright © 2017年 刘金凯. All rights reserved.
//

#import "YJHistorySearchView.h"

@implementation YJHistorySearchView

- (id)init{
    self = [super init];
    if (self) {
        self.label = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, APP_SCREEN_WIDTH-120, 30)];
        self.label.text = @"历史搜索";
        self.label.textColor = [UIColor colorWithRed:72/255.0 green:70/255.0 blue:71/255.0 alpha:1];
        self.label.font = [UIFont systemFontOfSize:14];
        self.label.tag = 100;
        [self addSubview:self.label];
        
        
        self.deleBtn = [[UIButton alloc]initWithFrame:CGRectMake(APP_SCREEN_WIDTH-70, 0, 60, 30)];
        [self.deleBtn setImage:[UIImage imageNamed:@"hot_dele"] forState:UIControlStateNormal];
        [self.deleBtn setTitle:@"清空" forState:UIControlStateNormal];
        [self.deleBtn setTitleColor:[UIColor colorWithRed:117/255.0 green:117/255.0 blue:117/255.0 alpha:1] forState:UIControlStateNormal];
        self.deleBtn.titleLabel.font = [UIFont systemFontOfSize:11];
        [self addSubview:self.deleBtn];
        self.deleBtn.tag = 200;
        [self.deleBtn addTarget:self action:@selector(clickDele) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return self;
}
- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.label = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, APP_SCREEN_WIDTH-120, 30)];
        self.label.text = @"历史搜索";
        self.label.textColor = [UIColor colorWithRed:72/255.0 green:70/255.0 blue:71/255.0 alpha:1];
        self.label.font = [UIFont systemFontOfSize:14];
        self.label.tag = 100;
        [self addSubview:self.label];
        
        
        self.deleBtn = [[UIButton alloc]initWithFrame:CGRectMake(APP_SCREEN_WIDTH-100, 0,100, 30)];
        [self.deleBtn setImage:[UIImage imageNamed:@"hot_dele"] forState:UIControlStateNormal];
        [self.deleBtn setTitle:@"清除历史记录" forState:UIControlStateNormal];
        [self.deleBtn setTitleColor:[UIColor colorWithRed:117/255.0 green:117/255.0 blue:117/255.0 alpha:1] forState:UIControlStateNormal];
        self.deleBtn.titleLabel.font = [UIFont systemFontOfSize:11];
        [self addSubview:self.deleBtn];
        self.deleBtn.tag = 200;
        [self.deleBtn addTarget:self action:@selector(clickDele) forControlEvents:UIControlEventTouchUpInside];

    }
    return self;
}
- (CGFloat)KeyViewH:(NSArray *)array {
    
    
    self.keyArray = array;
    float spx = 10;
    float x = 20;
    float y = 31+10;
    float w = APP_SCREEN_WIDTH/4-50;
    float h = 0;
    
    for (int i = 0; i < array.count; i++) {
        NSString *key = [array objectAtIndex:i];
        
        CGSize size = [key boundingRectWithSize:CGSizeMake(APP_SCREEN_WIDTH-60, MAXFLOAT)
                                        options: NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                     attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:11]}
                                        context:nil].size;
        w = size.width+30;
        
        if(w+x>=(APP_SCREEN_WIDTH-10)){
            x = 20;
            y = y+h+spx;
        }
        h = size.height+10;
        
        UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(x, y, w, h)];
        bgView.layer.cornerRadius = 10;
        bgView.layer.masksToBounds = YES;
        bgView.backgroundColor = [UIColor ex_colorFromHexRGB:@"F6F6F6"];
        bgView.tag = 20000+i;
        [self addSubview:bgView];
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickBgview:)];
        [bgView addGestureRecognizer:tapGesture];
        
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, size.width, size.height)];
        label.textColor = [UIColor ex_colorFromHexRGB:@"5A5A5A"];
        label.font = [UIFont systemFontOfSize:11];
        label.numberOfLines = 0;
        label.tag = 10000;
        label.text = [array objectAtIndex:i];
        label.center = CGPointMake(bgView.frame.size.width/2, bgView.frame.size.height/2);
        [bgView addSubview:label];
        
        x = x+w+spx;
        
    }
    
    return y+h;
}
- (void)removeAllKey{
    
    for (UIView *view in self.subviews) {
        if (view.tag ==100 || view.tag == 200||view.tag==300) {
            
        }else{
            [view removeFromSuperview];
        }
    }
    
    
}
-(void)clickBgview:(UITapGestureRecognizer *)gesture{
    UIView *bgView = gesture.view;
    UILabel *label = [bgView viewWithTag:10000];
    if ([self.delegate respondsToSelector:@selector(getKeyValue:)]) {
        [self.delegate getKeyValue:label.text];
    }
}
- (void)clickDele{
    if ([self.delegate respondsToSelector:@selector(clickDeleKey)]) {
        [self.delegate clickDeleKey];
    }
}


@end
