//
//  YJWeatherView.m
//  YJHouse
//
//  Created by fangkuai on 2018/2/7.
//  Copyright © 2018年 刘金凯. All rights reserved.
//

#import "YJWeatherView.h"


@implementation YJWeatherView {
    UIImageView *_bgImgView;
    UILabel *_temLabel;
    UILabel *_weathInfo;
    
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.clipsToBounds = YES;
        _bgImgView = [[UIImageView alloc] initWithFrame:self.bounds];
        _bgImgView.image = [UIImage imageNamed:@"icon_homeheader"];
        [self addSubview:_bgImgView];
        _temLabel = [[UILabel alloc] init];
        [self addSubview:_temLabel];
        _temLabel.font = [UIFont systemFontOfSize:14];
        _temLabel.textColor = [UIColor whiteColor];
        _temLabel.textAlignment = NSTextAlignmentRight;
        _temLabel.numberOfLines = 1;
        [_temLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-8);
            make.top.mas_equalTo(22);
        }];
        _weathInfo = [[UILabel alloc] init];
        _weathInfo.font = [UIFont systemFontOfSize:10];
        _weathInfo.textColor = [UIColor whiteColor];
        _weathInfo.textAlignment = NSTextAlignmentRight;
        [self addSubview:_weathInfo];
        [_weathInfo mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-6);
            make.top.mas_equalTo(_temLabel.mas_bottom).offset(3);
        }];
        [self loadWeatherData];
    }
    return self;
}
- (void)loadWeatherData {
    [[NetworkTool sharedTool]requestWithURLString:[NSString stringWithFormat:@"%@/condition/weather",Server_url] parameters:@{@"city_id":@"330100000"} method:GET callBack:^(id responseObject) {
        NSDictionary *weather =  [LJKHelper stringToJSON:responseObject[@"result"]];
        [_bgImgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",weather_url,weather[@"results"][0][@"now"][@"img"]]] placeholderImage:[UIImage imageNamed:@"icon_homeheader"]];
        _temLabel.text = [NSString stringWithFormat:@"%@℃",weather[@"results"][0][@"now"][@"temperature"]];
        _weathInfo.text = weather[@"results"][0][@"now"][@"text"];
        
    } error:nil];
    
}
- (void)snow {
    //粒子发射器图层
    self.rainDropEmitterLayer=[CAEmitterLayer layer];
    
    //粒子发射器位置
    _rainDropEmitterLayer.emitterPosition=CGPointMake(self.frame.size.width / 2, -30);
    
    //粒子发射器的范围
    _rainDropEmitterLayer.emitterSize=CGSizeMake(self.frame.size.width, 0);
    
    //发射模式
    _rainDropEmitterLayer.emitterMode=kCAEmitterLayerLine;
    
    //粒子模式
    _rainDropEmitterLayer.emitterShape=kCAEmitterLayerLine;
    
    //创建粒子
    CAEmitterCell *emitterCell=[CAEmitterCell emitterCell];
    
    //设置粒子内容
    emitterCell.contents=(__bridge id)([UIImage imageNamed:@"icon_snow"].CGImage);
    
    //设置粒子缩放比例
//    emitterCell.scale=0.6;
    
    //缩放范围
//    emitterCell.scaleRange=0.5;
    
    //每秒粒子产生数量
    emitterCell.birthRate=50;
    
    //粒子生命周期
    emitterCell.lifetime=5;
    
    //粒子透明速度
//    emitterCell.alphaSpeed=-0.1;
    
    //粒子速度
    emitterCell.velocity=100;
    emitterCell.velocityRange=100;
    
    //设置发射角度
    emitterCell.emissionLongitude=-M_PI *(2.8/3.0);
      emitterCell.emissionRange=M_PI;
    
    //设置粒子旋转角速度
//      emitterCell.spin=M_PI_4;
    
    //设置layer阴影
//    _rainDropEmitterLayer.shadowOpacity=1.0;
    
    //设置圆角
//    _rainDropEmitterLayer.shadowRadius=2;
    
    //设置偏移
//    _rainDropEmitterLayer.shadowOffset=CGSizeMake(1, 1);
    
    //设置颜色
    _rainDropEmitterLayer.shadowColor=[UIColor whiteColor].CGColor
    ;
    
    //设置layer的粒子
    _rainDropEmitterLayer.emitterCells=@[emitterCell];
    
    _rainDropEmitterLayer.transform=CATransform3DMakeRotation(-M_PI/4, 0, 0, 1);
    
    [self.layer addSublayer:_rainDropEmitterLayer];
}
@end
