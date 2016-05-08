package usage

// SetMessage container for Print() method
type SetMessage struct {}

// NewSetMessage returns an initialised struct
func NewSetMessage() *SetMessage { return &SetMessage { } }

// Print prints out the set usage message
func (m *SetMessage) Print() {
  header()
  
	title    (1, `Description`)
	text     (3, `Set the active scriptcs version.`)
	lines(1)
	title    (1, `Usage`)
	text     (3, `svm set <version> [<-g|--global>]`)
	text     (3, `svm set <version> <-l|--local>`)
	lines(2)
	command  (1, `svm set <version> [<-g|--global>]`)
	lines(1)
	text     (3, `If the -g or --global switch is utilised, this will be set at a global level and will be the active scriptcs version for all paths in which scriptcs is executed.`)
	lines(1)
	text     (3, `If there is an existing active scriptcs version at the specified level, it will be superceded by the version specified via this command.`)
	lines(1)
	text     (3, `NOTE: This is also the default option and will be used when no switch is specified on this command.`)
	lines(1)
	subtitle (3, `Examples`)
	lines(1)
	code     (3, `> svm set 0.15.0`)
	code     (3, `> svm set 0.15.0 -g`)
	lines(1)
	command  (1, `svm set <version> <-l|--local>`)
	lines(1)
	text     (3, `If the -l or --local switch is utilised, this will be set at a local level and will be the active scriptcs version only for the path in which this command was executed. This version will supercede any active scriptcs version set at a global level. An .svm file will be added at the path location that will contain the active scriptcs version details.`)
	lines(1)
	text     (3, `If there is an existing active scriptcs version at the specified level, it will be superceded by the version specified via this command.`)
	lines(1)
	subtitle (3, `Examples`)
	lines(1)
	code     (3, `> svm set 0.14.1 --local`)
  
	lines(1)
}
