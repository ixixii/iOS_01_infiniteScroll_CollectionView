//
//  MJNewsCell.m
//  08-无限滚动
//
//  Created by apple on 14-5-31.
//  Copyright (c) 2014年 itcast. All rights reserved.
//

#import "MJNewsCell.h"
#import "MJNews.h"

@interface MJNewsCell()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *iconView;

@end

@implementation MJNewsCell
- (void)setNews:(MJNews *)news
{
    _news = news;
    UIImage *img = [UIImage imageNamed:news.icon];
    self.iconView.image = img;
//    self.titleLabel.text = news.title;
    self.titleLabel.text = [NSString stringWithFormat:@"%@", news.title];
}

@end
