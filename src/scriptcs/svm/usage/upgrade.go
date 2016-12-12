package usage

// UpgradeMessage container for Print() method
type UpgradeMessage struct {}

// NewUpgradeMessage returns an initialised struct
func NewUpgradeMessage() *UpgradeMessage { return &UpgradeMessage { } }

// Print prints out the upgrade usage message
func (m *UpgradeMessage) Print() {
  header()
  
	title    (1, `Description`)
	text     (3, `Upgrade svm.`)
	lines(1)
	title    (1, `Usage`)
	text     (3, `svm upgrade`)
	lines(2)
	command  (1, `svm upgrade`)
	lines(1)
	text     (3, `Performs an inplace upgrade of svm if there is a newer version. All existing versions and configuration is preserved.`)
	lines(1)
	subtitle (3, `Examples`)
	lines(1)
	code     (3, `> svm upgrade`)
  
	lines(1)
}
