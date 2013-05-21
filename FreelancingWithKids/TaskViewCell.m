#import "TaskViewCell.h"
#import "Task.h"

@interface TaskViewCell()

@property(nonatomic, strong) IBOutlet UILabel *taskName;
@property(nonatomic, strong) IBOutlet UIProgressView *progress;

-(IBAction) startTask:(id) sender;

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
  _task = task;
  self.taskName.text = task.name;
}

-(IBAction) startTask:(id)sender
{
  [self.task start:self];
}

-(void) updateProgress:(NSDecimalNumber *)progress
{
  [self.progress setProgress:[progress floatValue] animated:YES];
}

@end
