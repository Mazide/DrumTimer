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
    
    [self initNumbers];
    self.needUpdate = NO;
    
    [self setupMainView];
    [self setupTableView];
}

- (void)initNumbers{

    self.numbers = [NSMutableArray new];
    for (int i=9; i >= 0; i--)
        [self.numbers addObject:@(i)];
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
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:currentRow inSection:0];
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
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        [self.numberTableView scrollToRowAtIndexPath:indexPath
                                    atScrollPosition:UITableViewScrollPositionTop
                                            animated:NO];
    }
}

@end
