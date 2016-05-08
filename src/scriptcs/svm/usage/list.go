package usage

// ListMessage container for Print() method
type ListMessage struct {}

// NewListMessage returns an initialised struct
func NewListMessage() *ListMessage { return &ListMessage { } }

// Print prints out the list usage message
func (m *ListMessage) Print() {
  header()
  
	title    (1, `Description`)
	text     (3, `List scriptcs versions.`)
	lines(1)
	title    (1, `Usage`)
	text     (3, `svm list [<-i|--installed>]`)
	text     (3, `svm list <-r|--remote>`)
	text     (3, `svm list <-a|--active>`)
	lines(2)
	command  (1, `svm list [<-i|--installed>]`)
	lines(1)
	text     (3, `List the locally installed scriptcs versions available to use by specifying the -i or --installed switches. The active version of the installed scriptcs versions will be highlighted and will be specific to the path in which this command is executed taking into account global and local version selections.`)
	lines(1)
	text     (3, `NOTE: This is also the default option and will be used when no switch is specified on this command.`)
	lines(1)
	subtitle (3, `Examples`)
	lines(1)
	code     (3, `> svm list --installed`)
	code     (3, `> svm list`)
	lines(1)
	command  (1, `svm list <-r|--remote>`)
	lines(1)
	text     (3, `List the scriptcs versions available to install from the remote repositories by specifying the -r or --remote switches.`)
	lines(1)
	subtitle (3, `Examples`)
	lines(1)
	code     (3, `> svm list --remote`)
	lines(1)
	command  (1, `svm list <-a|--active>`)
	lines(1)
	text     (3, `List the active version of the installed scriptcs versions available to use by specifying the -a or --active switches. This will be specific to the path in which the command is executed and will take into account global and local version selections.`)
	lines(1)
	subtitle (3, `Examples`)
	lines(1)
	code     (3, `> svm list -a`)
  
	lines(1)
}
