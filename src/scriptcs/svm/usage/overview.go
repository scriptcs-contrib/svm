package usage

// OverviewMessage container for Print() method
type OverviewMessage struct {}

// NewOverviewMessage returns an initialised struct
func NewOverviewMessage() *OverviewMessage { return &OverviewMessage { } }

// Print prints out the overview usage message
func (m *OverviewMessage) Print() {
  header()
  
	title    (1, `Usage`)
	text     (3, `svm <command> [arguments] [--verbose]`)
	lines(1)
	title    (1, `Display general help or help for a given command`)
	text     (3, `svm help [<command>]`)
	lines(1)
	title    (1, `Display svm version`)
	text     (3, `svm (-v|--version)`)
	lines(1)
	title    (1, `Commands`)
	lines(1)
	text     (3, `install      Install a scriptcs version.`)
	text     (3, `uninstall    Uninstall a scriptcs version.`)
	lines(1)
	text     (3, `list         List scriptcs versions.`)
	text     (3, `info         Display detailed scriptcs version information.`)
	text     (3, `set          Set the active scriptcs version.`)
	text     (3, `unset        Unset the active scriptcs version.`)
	lines(1)
	text     (3, `upgrade      Upgrade svm.`)
	
  lines(1)
}