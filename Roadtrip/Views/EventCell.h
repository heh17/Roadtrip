//
//  EventCell.h
//  Roadtrip
//
//  Created by Hannah Hsu on 7/18/18.
//  Copyright © 2018 heh17. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Event.h"
#import "Landmark.h"
#import "Canvas.h"

@protocol EventCellDelegate;

@interface EventCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *startEndLabel;
@property (strong, nonatomic)Event *event;
@property(strong, nonatomic)Landmark *landmark;
@property (weak, nonatomic) IBOutlet UIButton *checkBoxButton;
@property (nonatomic) BOOL isSelected;
@property (weak, nonatomic) IBOutlet UIImageView *posterView;

@property (nonatomic, weak) id<EventCellDelegate> delegate;
@property (weak, nonatomic) IBOutlet UILabel *warningLabel;
@property (weak, nonatomic) IBOutlet CSAnimationView *imageAnimation;

@end

@protocol EventCellDelegate


-(void) eventCell: (EventCell *) eventCell;
-(void) hideCheckmark: (EventCell *)eventCell;

@end
