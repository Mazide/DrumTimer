//
//  SingleNumberView.m
//  Timer
//
//  Created by Nikita Demidov on 10.02.16.
//  Copyright © 2016 Nikita Demidov. All rights reserved.
//

#import "SingleNumberView.h"
#import "NumberTableViewCell.h"

static const NSInteger period = 10;
static const NSInteger maxValue = 9;

@interface SingleNumberView() <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UIView* mainView;
@property (weak, nonatomic) IBOutlet UITableView* numberTableView;

@property (nonatomic) NSInteger currentRow;
@property (nonatomic) NSInteger countOfRows;

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

    self.currentRow = 0;
    self.countOfRows = period;
    
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
    
    NSString* cellNibName = NSStringFromClass([NumberTableViewCell class]);
    UINib* cellNib = [UINib nibWithNibName:cellNibName bundle:[NSBundle mainBundle]];
    [self.numberTableView registerNib:cellNib forCellReuseIdentifier:cellNibName];
    [self.numberTableView reloadData];
}

#pragma mark - public

- (void)setValue:(NSInteger)value{

    self.currentRow = maxValue - value%period;
    
    if (self.currentRow >= self.countOfRows - 1) {
        self.countOfRows += period;
        [self.numberTableView reloadData];
    }
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.currentRow inSection:0];
    [self.numberTableView scrollToRowAtIndexPath:indexPath
                                atScrollPosition:UITableViewScrollPositionTop
                                        animated:YES];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.countOfRows;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NumberTableViewCell* numberCell = (NumberTableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"NumberTableViewCell"];
    numberCell.numberLabel.text = [NSString stringWithFormat:@"%ld", maxValue - indexPath.row%period];
    return numberCell;
}

@end
