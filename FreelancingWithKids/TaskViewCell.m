#import "TaskViewCell.h"
#import "Task.h"

@interface TaskViewCell()

@property(nonatomic, strong) IBOutlet UILabel *taskName;
@property(nonatomic, strong) IBOutlet UIProgressView *progress;

@end

@implementation TaskViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
      self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

-(void) setTask:(Task *)task
{
  self.taskName.text = task.name;
  
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

@end
