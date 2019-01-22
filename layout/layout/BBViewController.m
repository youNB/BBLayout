//
//  BBViewController.m
//  layout
//
//  Created by 程肖斌 on 2019/1/22.
//  Copyright © 2019年 ICE. All rights reserved.
//

#import "BBViewController.h"

@interface BBViewController ()<UICollectionViewDelegate, UICollectionViewDataSource>
@property(nonatomic, strong) UICollectionView *col_view;
@end

@implementation BBViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.whiteColor;
    
    UICollectionViewFlowLayout *layout = [[self.layoutClass alloc]init];
    layout.minimumLineSpacing = 10;
    layout.minimumInteritemSpacing = 10;
    layout.itemSize = CGSizeMake(100, 50);
    layout.sectionInset = UIEdgeInsetsMake(0, 10, 0, 10);
    CGRect frame = CGRectMake(0, 100, self.view.bounds.size.width, self.view.bounds.size.height-120);
    self.col_view = [[UICollectionView alloc]initWithFrame:frame
                                      collectionViewLayout:layout];
    self.col_view.dataSource = self;
    self.col_view.delegate   = self;
    self.col_view.backgroundColor = UIColor.whiteColor;
    [self.col_view registerClass:UICollectionViewCell.class forCellWithReuseIdentifier:@"cell"];
    [self.view addSubview:self.col_view];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 50;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    cell.contentView.backgroundColor = UIColor.greenColor;

    return cell;
}

@end
