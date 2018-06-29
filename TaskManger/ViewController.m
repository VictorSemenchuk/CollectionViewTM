//
//  ViewController.m
//  TaskManger
//
//  Created by Victor Macintosh on 29/06/2018.
//  Copyright © 2018 Victor Semenchuk. All rights reserved.
//

#import "ViewController.h"
#import "CustomCollectionViewCell.h"
#import "CustomFlowLayout.h"

static NSString * const kCellIdentifier = @"CellIdentifier";

@interface ViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (nonatomic) UICollectionView *collectionView;
@property (nonatomic) NSMutableArray *dataSource;

- (void)setupViews;
- (void)addNewItem;
- (void)handleLongGesture:(UILongPressGestureRecognizer *)gesture;

@end

@implementation ViewController

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        CustomFlowLayout *layout = [[CustomFlowLayout alloc] init];
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.backgroundColor = UIColor.lightGrayColor;
        [_collectionView registerClass:[CustomCollectionViewCell class] forCellWithReuseIdentifier:kCellIdentifier];
        
        UILongPressGestureRecognizer *longPressGesture = [[UILongPressGestureRecognizer alloc] init];
        [longPressGesture addTarget:self action:@selector(handleLongGesture:)];
        [_collectionView addGestureRecognizer:longPressGesture];
    }
    return _collectionView;
}

- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Tasks";
    [self setupViews];
}

- (void)setupViews {
    
    //navigationItem
    
    UIBarButtonItem *rightNavigationItem = [[UIBarButtonItem alloc] initWithTitle:@"New task" style:UIBarButtonItemStylePlain target:self action:@selector(addNewItem)];
    self.navigationItem.rightBarButtonItem = rightNavigationItem;
    
    //collectionView
    
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    
    [self.view addSubview:self.collectionView];
    self.collectionView.translatesAutoresizingMaskIntoConstraints = NO;
    
    UILayoutGuide *guide = self.view.safeAreaLayoutGuide;
    [NSLayoutConstraint activateConstraints:@[
                                              [self.collectionView.leadingAnchor constraintEqualToAnchor:guide.leadingAnchor],
                                              [self.collectionView.topAnchor constraintEqualToAnchor:guide.topAnchor],
                                              [self.collectionView.trailingAnchor constraintEqualToAnchor:guide.trailingAnchor],
                                              [self.collectionView.bottomAnchor constraintEqualToAnchor:guide.bottomAnchor]
                                              ]];
    
}

- (void)addNewItem {
    NSArray *newData = @[[NSString stringWithFormat:@"Item %lu", [self.dataSource count] + 1]];
    [self.collectionView performBatchUpdates:^{
        NSUInteger resultSize = [self.dataSource count];
        [self.dataSource addObjectsFromArray:newData];
        NSMutableArray *arrayWithIndexPaths = [NSMutableArray array];
        for(NSUInteger i = resultSize; i < resultSize + [newData count]; i++) {
            [arrayWithIndexPaths addObject:[NSIndexPath indexPathForRow:i inSection:0]];
        }
        [self.collectionView insertItemsAtIndexPaths:arrayWithIndexPaths];
    } completion:nil];
}

- (void)handleLongGesture:(UILongPressGestureRecognizer *)gesture {
    
    CGPoint location = [gesture locationInView:self.collectionView];
    NSIndexPath *movingIndexPath = [self.collectionView indexPathForItemAtPoint:location];
    if (!movingIndexPath) {
        return;
    }
    switch (gesture.state) {
        case UIGestureRecognizerStateBegan:
            [self.collectionView beginInteractiveMovementForItemAtIndexPath:movingIndexPath];
            break;
        case UIGestureRecognizerStateChanged:
            [self.collectionView updateInteractiveMovementTargetPosition:[gesture locationInView:self.collectionView]];
            break;
        case UIGestureRecognizerStateEnded:
            [self.collectionView endInteractiveMovement];
            break;
        default:
            [self.collectionView cancelInteractiveMovement];
    }
}

#pragma mark - UICollectionViewDataCource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.dataSource count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CustomCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCellIdentifier forIndexPath:indexPath];
    cell.titleLabel.text = self.dataSource[indexPath.row];
    return cell;
}

#pragma mark - UICollectionViewDelegate

- (BOOL)collectionView:(UICollectionView *)collectionView canMoveItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)collectionView:(UICollectionView *)collectionView moveItemAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {
    NSString *item = self.dataSource[sourceIndexPath.row];
    [self.dataSource removeObjectAtIndex:sourceIndexPath.row];
    [self.dataSource insertObject:item atIndex:destinationIndexPath.row];
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(self.view.frame.size.width, 50.0);
}

@end
