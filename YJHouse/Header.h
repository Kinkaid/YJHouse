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
#define PushController(vc)  [self.navigationController pushViewController:vc animated:YES]

#define APP_VERSION  [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]


#define ISEMPTY(x)	(((x) == nil ||[(x) isKindOfClass:[NSNull class]] ||([(x) isKindOfClass:[NSString class]] &&  ([(NSString*)(x) length] == 0 ||[(NSString*)(x) isEqualToString:@"(null)"])) || ([(x) isKindOfClass:[NSArray class]] && [(NSArray*)(x) count] == 0))|| ([(x) isKindOfClass:[NSDictionary class]] && [(NSDictionary*)(x) count] == 0))
#define MainColor [UIColor ex_colorFromHexRGB:@"44A7FB"]


#define wbAppKey @"1016940085"
#define wbAppSecret @"c0b7808df96d41c5effed9ede7728cfd"
#define wxAppID @"wx82472494379ca921"
#define wxAppSecret @"eb5ed168a644f863d46d38ae43d3c703"
#define qqAppID @"1106304780"
#define qqAppKey @"D5N5wr4GpTzzUP1z"




#endif /* Header_h */
