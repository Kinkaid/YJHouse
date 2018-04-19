//
//  ArticleModel.h
//  YJHouse
//
//  Created by fangkuai on 2018/2/5.
//  Copyright © 2018年 刘金凯. All rights reserved.
//

#import <Mantle/Mantle.h>

@interface ArticleModel : MTLModel<MTLJSONSerializing>
@property(nonatomic,copy) NSString *content;
@property(nonatomic,copy) id articleId;
@property(nonatomic,copy) NSString *main_img;
@property(nonatomic,copy) NSString *origin;
@property(nonatomic,copy) id time;
@property(nonatomic,copy) NSString *title;
@end
