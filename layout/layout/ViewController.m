//
//  ViewController.m
//  layout
//
//  Created by 程肖斌 on 2019/1/22.
//  Copyright © 2019年 ICE. All rights reserved.
//

#import "ViewController.h"
#import "BBLayout.h"
#import "BBViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (IBAction)spring:(UIButton *)sender {
    BBViewController *vc = [[BBViewController alloc]init];
    vc.layoutClass = BBSpringLayout.class;
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)left:(UIButton *)sender {
    BBViewController *vc = [[BBViewController alloc]init];
    vc.layoutClass = BBLeftLayout.class;
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)center:(UIButton *)sender {
    BBViewController *vc = [[BBViewController alloc]init];
    vc.layoutClass = BBCenterLayout.class;
    [self.navigationController pushViewController:vc animated:YES];
}


@end
