//
//  BBLayout.h
//  layout
//
//  Created by 程肖斌 on 2019/1/22.
//  Copyright © 2019年 ICE. All rights reserved.
//

#import <UIKit/UIKit.h>

/*
    弹框布局，注意如果有数据刷新，在reloadData之前要先刷新布局
*/
@interface BBSpringLayout : UICollectionViewFlowLayout
@property(nonatomic, strong) UIDynamicAnimator *animator;
@end

/*
    左对齐布局，请注意UICollectionView的尺寸和layout的关系
*/
@interface BBLeftLayout : UICollectionViewFlowLayout
@end

/*
    居中对齐，请注意UICollectionView的尺寸和layout的关系
*/
@interface BBCenterLayout : UICollectionViewFlowLayout
@end

