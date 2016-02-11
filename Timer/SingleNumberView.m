//
//  SingleNumberView.m
//  Timer
//
//  Created by Nikita Demidov on 10.02.16.
//  Copyright © 2016 Nikita Demidov. All rights reserved.
//

#import "SingleNumberView.h"
#import "NumberTableViewCell.h"

@interface SingleNumberView() <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UIView* mainView;
@property (weak, nonatomic) IBOutlet UITableView* numberTableView;

@property (strong, nonatomic) NSMutableArray* numbers;
@property (nonatomic) BOOL needUpdate;

@end

@implementation SingleNumberView

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self){
        [self setup];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self){
        [self setup];
    }
    return self;
}

- (void)setup{
    
    self.numbers = [NSMutableArray arrayWithArray:@[@(9),@(8),@(7),@(6),@(5),@(4),@(3),@(2),@(1),@(0)]];
    self.needUpdate = NO;
    
    [self setupMainView];
    [self setupTableView];
}

- (void)setupMainView{
    NSString* singleNumberNibName = NSStringFromClass([SingleNumberView class]);
    [[NSBundle mainBundle] loadNibNamed:singleNumberNibName owner:self options:nil];
    [self addSubview:self.mainView];
}

- (void)setupTableView{
    
    self.numberTableView.dataSource = self;
    self.numberTableView.delegate = self;
    
    NSString* cellNibName = NSStringFromClass([NumberTableViewCell class]);
    UINib* cellNib = [UINib nibWithNibName:cellNibName bundle:[NSBundle mainBundle]];
    [self.numberTableView registerNib:cellNib forCellReuseIdentifier:cellNibName];
    [self.numberTableView reloadData];
}

#pragma mark - public

- (void)setValue:(NSInteger)value{
    NSInteger currentRow = [self.numbers indexOfObject:@(value)];
    NSInteger lastRow = [self.numbers indexOfObject:self.numbers.lastObject];
    
    if (currentRow == lastRow) {
        [self.numbers insertObject:self.numbers.lastObject atIndex:0];
        [self.numbers removeLastObject];
        self.needUpdate = YES;
    } else {
        self.needUpdate = NO;
    }
    
    [self showNumberWithIndex:currentRow animated:YES];
}

- (void)showNumberWithIndex:(NSInteger)index animated:(BOOL)animated{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
    [self.numberTableView scrollToRowAtIndexPath:indexPath
                                atScrollPosition:UITableViewScrollPositionTop
                                        animated:YES];

}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.numbers.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NumberTableViewCell* numberCell = (NumberTableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"NumberTableViewCell"];
    NSInteger numberIndex = self.needUpdate ? 0 : indexPath.row;
    NSInteger number = [self.numbers[numberIndex] integerValue];
    numberCell.numberLabel.text = [NSString stringWithFormat:@"%ld", number];
    return numberCell;
}


- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    if (self.needUpdate) {
        [self.numberTableView reloadData];
        [self showNumberWithIndex:0 animated:NO];
    }
}

@end
