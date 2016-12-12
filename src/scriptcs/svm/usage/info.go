package usage

// InfoMessage container for Print() method
type InfoMessage struct {}

// NewInfoMessage returns an initialised struct
func NewInfoMessage() *InfoMessage { return &InfoMessage { } }

// Print prints out the info usage message
func (m *InfoMessage) Print() {
  header()
  
	// title.Println    (` Description`)
	// text.Println     (`    Display detailed scriptcs version information.`)
	// printEmptyLines(1)
	// title.Println    (` Usage`)
	// text.Println     (`    svm info <version>`)
	// printEmptyLines(2)
	// command.Println  (` svm info <version>`)
	// printEmptyLines(1)
	// text.Println     (`    Display detailed information about the specified scriptcs version. This will include scriptcs version, source of installed versions and soft link information if scriptcs version is symlinked to local folders.`)
	// printEmptyLines(1)
  // text.Print       (`    `); subtitle.Println(`Examples`)
	// printEmptyLines(1)
	// code.Println     (`    > svm info 0.15.0`)
  
  title    (1, `Description`)
  text     (3, `Display detailed scriptcs version information.`)
	lines(1)
	title    (1, `Usage`)
	text     (3, `svm info <version>`)
	lines(2)
	command  (1, `svm info <version>`)
	lines(1)
	text     (3, `Display detailed information about the specified scriptcs version. This will include scriptcs version, source of installed versions and soft link information if scriptcs version is symlinked to local folders.`)
	lines(1)
  subtitle (3, `Examples`)
	lines(1)
	code     (3, `> svm info 0.15.0`)
	lines(1)
}
