//
//  BBLayout.m
//  layout
//
//  Created by 程肖斌 on 2019/1/22.
//  Copyright © 2019年 ICE. All rights reserved.
//

#import "BBLayout.h"

@implementation BBSpringLayout

- (instancetype)init{
    self = [super init];
    if(self){
        self.animator = [[UIDynamicAnimator alloc]initWithCollectionViewLayout:self];
    }
    return self;
}

- (void)prepareLayout{
    [super prepareLayout];
    if (!self.animator.behaviors.count) {
        CGSize size = [self collectionViewContentSize];
        CGRect rect = CGRectZero;
        rect.size   = size;
        NSArray<id<UIDynamicItem>> *items = [super layoutAttributesForElementsInRect:rect];
        for(id<UIDynamicItem> item in items){
            UIAttachmentBehavior *behaviour = [[UIAttachmentBehavior alloc] initWithItem:item
                                                                        attachedToAnchor:item.center];
            
            behaviour.length  = 0.0f;
            behaviour.damping = 0.8f;
            behaviour.frequency = 1.0f;
            
            [self.animator addBehavior:behaviour];
        }
    }
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath{
    return [self.animator layoutAttributesForCellAtIndexPath:indexPath];
}

- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect{
    return (NSArray<UICollectionViewLayoutAttributes *> *)[self.animator itemsInRect:rect];
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds{
    
    UIScrollView *scrollView = self.collectionView;
    CGFloat delta = newBounds.origin.y - scrollView.bounds.origin.y;
    
    CGPoint touchLocation = [self.collectionView.panGestureRecognizer locationInView:self.collectionView];
    
    for(UIAttachmentBehavior *springBehaviour in self.animator.behaviors){
        CGFloat yDistanceFromTouch = fabs(touchLocation.y - springBehaviour.anchorPoint.y);
        CGFloat xDistanceFromTouch = fabs(touchLocation.x - springBehaviour.anchorPoint.x);
        CGFloat scrollResistance   = (yDistanceFromTouch + xDistanceFromTouch) / 750.0f;
        
        UICollectionViewLayoutAttributes *item = (UICollectionViewLayoutAttributes *)springBehaviour.items.firstObject;
        CGPoint center = item.center;
        CGFloat value  = delta * scrollResistance;
        center.y += (delta < 0) ? MAX(delta, value) : MIN(delta, value);
        item.center = center;
        
        [self.animator updateItemUsingCurrentState:item];
    }
    
    return NO;
}

@end

@implementation BBLeftLayout

- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect{
    NSArray<UICollectionViewLayoutAttributes *> *layouts = [[NSArray alloc]initWithArray:[super layoutAttributesForElementsInRect:rect] copyItems:YES];
    NSInteger X = (NSInteger)self.sectionInset.left;
    NSInteger Y = (NSInteger)self.sectionInset.top;
    for(UICollectionViewLayoutAttributes *layout in layouts){
        BOOL state = (layout.representedElementKind == UICollectionElementKindSectionHeader);
        if(state){continue;}
        state = (layout.representedElementKind == UICollectionElementKindSectionFooter);
        if(state){continue;}
        
        NSInteger originY = (NSInteger)layout.frame.origin.y;
        CGRect frame = layout.frame;
        if(Y == originY){frame.origin.x = X;}
        else{//换行了
            X = self.sectionInset.left;
            Y = originY;
            
            frame.origin.x = X;
        }
        layout.frame = frame;
        X += frame.size.width;
        X += self.minimumInteritemSpacing;
    }
    
    return layouts;
}

@end

@implementation BBCenterLayout

- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect{
    NSArray<UICollectionViewLayoutAttributes *> *attrs = [super layoutAttributesForElementsInRect:rect];
    if(!attrs.count){return attrs;}
    
    NSArray *layouts = [[NSArray alloc]initWithArray:attrs copyItems:YES];
    BOOL state = (self.scrollDirection == UICollectionViewScrollDirectionHorizontal);
    state ? [self horizontal:layouts] : [self vertical:layouts];

    return layouts;
}

//水平滚动的居中
- (void)horizontal:(NSArray<UICollectionViewLayoutAttributes *> *)layouts{
    UICollectionViewLayoutAttributes *last = layouts.lastObject;
    NSInteger length = (NSInteger)(self.collectionView.bounds.size.width-self.sectionInset.left-self.sectionInset.right-self.collectionView.contentInset.left-self.collectionView.contentInset.right);
    NSInteger last_value = (NSInteger)(last.frame.origin.x+last.frame.size.width);
    if(last_value >= length && self.scrollDirection == UICollectionViewScrollDirectionHorizontal){return ;}
    
    NSInteger total = 0;
    for(UICollectionViewLayoutAttributes *attr in layouts){
        total += (NSInteger)attr.frame.size.width;
    }
    NSInteger dis = (NSInteger)((length-total)/(layouts.count+1));
    CGFloat X = self.sectionInset.left + dis;

    for(UICollectionViewLayoutAttributes *attr in layouts){
        CGRect frame = attr.frame;
        frame.origin.x = X;
        attr.frame = frame;
        
        X += attr.frame.size.width;
        X += dis;
    }
}

//竖直滚动的居中
- (void)vertical:(NSArray<UICollectionViewLayoutAttributes *> *)layouts{
    NSInteger Y = (NSInteger)layouts.firstObject.frame.origin.y;
    NSInteger from = 0;
    BOOL state = NO;
    for(NSInteger index = 0; index < layouts.count; index ++){
        UICollectionViewLayoutAttributes *attr = layouts[index];
        if((NSInteger)attr.frame.origin.y == Y){continue;}
        state = YES;
        NSRange range = NSMakeRange(from, index-from);
        [self horizontal:[layouts subarrayWithRange:range]];
        from = index;
        Y = attr.frame.origin.y;
    }
    if(from != layouts.count){[self horizontal:[layouts subarrayWithRange:NSMakeRange(from, layouts.count-from)]];}
    
    //说明虽然是竖直方向，但是没有折行，那就按照水平居中布局
    if(!state){[self horizontal:layouts];}
}

@end
