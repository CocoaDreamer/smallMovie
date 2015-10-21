//
//  interface.h
//  smallMovie
//
//  Created by aayongche on 15/9/9.
//  Copyright (c) 2015年 lei.cheng. All rights reserved.
//

#define Movie_List [NSString stringWithFormat:@"http://magicapi.vmovier.com/magicapi/find"]


#define Intro_Movie @"http://magicapi.vmovier.com/magicapi/index/shareview?id=5639&source=recommend&viewfrom=magic_collect_inner&MagicBoxApp=2.0&device=ios&video=native"

#define Comment_List @"http://magicapi.vmovier.com/magicapi/comment/getList"

//#define MV_List_1 @"http://mapi.yinyuetai.com/vchart/trend.json?D-A=0&area="
//#define MV_List_2 @"&offset="
//#define MV_List_3 @"&size=20&deviceinfo=%7B%22aid%22%3A%2210201024%22%2C%22os%22%3A%22Android%22%2C%22ov%22%3A%224.2.2%22%2C%22rn%22%3A%22480*800%22%2C%22dn%22%3A%22H30-T00%22%2C%22cr%22%3A%2246002%22%2C%22as%22%3A%22WIFI%22%2C%22uid%22%3A%22c5aa133090bd0d5d9ecd4163bb27f3cb%22%2C%22clid%22%3A110013000%7D"
//#define MV_List(x,y) [NSString stringWithFormat:@"%@%@%@%@%@",MV_List_1,x,MV_List_2,y,MV_List_3]
#define MV_List @"http://mapi.yinyuetai.com/vchart/trend.json"


#define MV_Related_List_1 @"http://mapi.yinyuetai.com/video/show.json?D-A=0&relatedVideos=true&id="
#define MV_Related_List_2 @"&deviceinfo=%7B%22aid%22%3A%2210201024%22%2C%22os%22%3A%22Android%22%2C%22ov%22%3A%224.2.2%22%2C%22rn%22%3A%22480*800%22%2C%22dn%22%3A%22H30-T00%22%2C%22cr%22%3A%2246002%22%2C%22as%22%3A%22WIFI%22%2C%22uid%22%3A%22c5aa133090bd0d5d9ecd4163bb27f3cb%22%2C%22clid%22%3A110013000%7D"
//#define MV_Related_List(x) [NSString stringWithFormat:@"%@%@%@",MV_Related_List_1,x,MV_Related_List_2]
#define MV_Related_List @"http://mapi.yinyuetai.com/video/show.json"


//#define MV_Search_1 @"http://mapi.yinyuetai.com/search/video.json?D-A=0&offset="
//#define MV_Search_2 @"&size=20&keyword="
//#define MV_Search_3 @"&deviceinfo=%7B%22aid%22%3A%2210201024%22%2C%22os%22%3A%22Android%22%2C%22ov%22%3A%224.2.2%22%2C%22rn%22%3A%22480*800%22%2C%22dn%22%3A%22H30-T00%22%2C%22cr%22%3A%2246002%22%2C%22as%22%3A%22WIFI%22%2C%22uid%22%3A%22c5aa133090bd0d5d9ecd4163bb27f3cb%22%2C%22clid%22%3A110013000%7D"
//#define MV_Search(x,y) [NSString stringWithFormat:@"%@%@%@%@%@",MV_Search_1,x,MV_Search_2,y,MV_Search_3]
#define MV_Search @"http://mapi.yinyuetai.com/search/video.json"


#define GAMEASK_URL @"http://renlifang.msra.cn/Q20/api/gamestart.ashx?alias=WP7&stamp=366"
