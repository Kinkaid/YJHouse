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


#define ISEMPTY(x)	(((x) == nil ||[(x) isKindOfClass:[NSNull class]] ||([(x) isKindOfClass:[NSString class]] &&  ([(NSString*)(x) length] == 0 ||[(NSString*)(x) isEqualToString:@"(null)"])) || ([(x) isKindOfClass:[NSArray class]] && [(NSArray*)(x) count] == 0))|| ([(x) isKindOfClass:[NSDictionary class]] && [(NSDictionary*)(x) count] == 0))

#endif /* Header_h */
