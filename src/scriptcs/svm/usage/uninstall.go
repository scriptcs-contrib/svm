package usage

// UninstallMessage container for Print() method
type UninstallMessage struct {}

// NewUninstallMessage returns an initialised struct
func NewUninstallMessage() *UninstallMessage { return &UninstallMessage { } }

// Print prints out the uninstall usage message
func (m *UninstallMessage) Print() {
  header()
  
	title    (1, `Description`)
	text     (3, `Uninstall a scriptcs version. If this was set as the global active version, then this will be removed.`)
  lines(1)
	title    (1, `Usage`)
	text     (3, `svm uninstall <version>`)
	lines(2)
	command  (1, `svm uninstall <version>`)
	lines(1)
	text     (3, `Uninstall installed scriptcs version indicated by <version>.`)
	lines(1)
	subtitle (3, `Examples`)
	lines(1)
	code     (3, `> svm uninstall 0.14.0`)
  
	lines(1)
}
