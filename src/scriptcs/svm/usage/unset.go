package usage

// UnsetMessage container for Print() method
type UnsetMessage struct {}

// NewUnsetMessage returns an initialised struct
func NewUnsetMessage() *UnsetMessage { return &UnsetMessage { } }

// Print prints out the unset usage message
func (m *UnsetMessage) Print() {
  header()
  
	title    (1, `Description`)
	text     (3, `Unset the active scriptcs version.`)
	lines(1)
	title    (1, `Usage`)
	text     (3, `svm unset <version> <-g|--global>`)
	text     (3, `svm unset <version> <-l|--local>`)
	lines(2)
	command  (1, `svm unset <version> <-g|--global>`)
	lines(1)
	text     (3, `If the -g or --global switch is utilised, this will be unset at a global level and there will be no active scriptcs version for any paths in which scriptcs is executed.`)
	lines(1)
	text     (3, `NOTE: This does not uninstall/remove the scriptcs version. It simply removes any global references to it.`)
	lines(1)
	subtitle (3, `Examples`)
	lines(1)
	code     (3, `> svm unset --global`)
	lines(1)
	command  (1, `svm unset <version> <-l|--local>`)
	lines(1)
	text     (3, `If the -l or --local switch is utilised, this will unset at a local level and there will no longer be a local override of the active scriptcs version for the path in which this command was executed. The .svm file will be removed from the path location.`)
	lines(1)
	text     (3, `NOTE: This does not uninstall/remove the scriptcs version. It simply removes any global references to it.`)
	lines(1)
	subtitle (3, `Examples`)
	lines(1)
	code     (3, `> svm unset -l`)
  
	lines(1)
}
