//
//  Header.h
//  YJHouse
//
//  Created by 刘金凯 on 2017/2/17.
//  Copyright © 2017年 刘金凯. All rights reserved.
//

#ifndef Header_h
#define Header_h

#define APP_SCREEN_WIDTH    ([[UIScreen mainScreen]bounds].size.width)
#define APP_SCREEN_HEIGHT   ([[UIScreen mainScreen]bounds].size.height)
#define APP_SCREEN_SCALE_WIDTH (([[UIScreen mainScreen]bounds].size.width) / 375.0)
#define APP_SCREEN_SCALE_HEIGHT (([[UIScreen mainScreen]bounds].size.height) / 667.0)

#define PushController(vc)  [self.navigationController pushViewController:vc animated:YES]

#define APP_VERSION  [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]

#define KIsiPhoneX ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO)

#define ISEMPTY(x)	(((x) == nil ||[(x) isKindOfClass:[NSNull class]] ||([(x) isKindOfClass:[NSString class]] &&  ([(NSString*)(x) length] == 0 ||[(NSString*)(x) isEqualToString:@"(null)"])) || ([(x) isKindOfClass:[NSArray class]] && [(NSArray*)(x) count] == 0))|| ([(x) isKindOfClass:[NSDictionary class]] && [(NSDictionary*)(x) count] == 0))
#define MainColor [UIColor ex_colorFromHexRGB:@"44A7FB"]


#define wbAppKey @"1016940085"
#define wbAppSecret @"c0b7808df96d41c5effed9ede7728cfd"

#define wxAppID @"wx8c6a5706ca4e48db"
#define wxAppSecret @"29acdc782046007b1bbe5d841adc64df"

#define qqAppID @"1106304780"
#define qqAppKey @"D5N5wr4GpTzzUP1z"

#define kPushRemoteNotification @"kPushRemoteNotification"



#endif /* Header_h */
/*
 {"name":"桐庐县",
 "children_children":
 [{"name":"不限","id":"330122000"}],
 "id":"330122000"},
 
 {"name":"淳安县",
 "children_children":
 [{"name":"不限","id":"330127000"}],
 "id":"330127000"},
 
 {"name":"建德市",
 "children_children":
 [{"name":"不限","id":"330182000"}],
 "id":"330182000"},
 
 {"name":"临安市",
 "children_children":
 [{"name":"不限","id":"330185000"}],
 "id":"330185000"}
 */
