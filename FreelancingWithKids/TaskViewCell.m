#import "TaskViewCell.h"
#import "WorkdayController.h"

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

-(void) setName:(NSString *)name
{
  _name = name;
  self.taskName.text = name;
}

-(IBAction) startTask:(id)sender
{
  [self.controller startWorkingOn: self.name withDelegate:self];
}

-(void) updateProgress:(NSDecimalNumber *)progress
{
  [self.progress setProgress:[progress floatValue] animated:YES];
}

@end
