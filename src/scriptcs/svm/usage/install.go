package usage

// InstallMessage container for Print() method
type InstallMessage struct {}

// NewInstallMessage returns an initialised struct
func NewInstallMessage() *InstallMessage { return &InstallMessage { } }

// Print prints out the install usage message
func (m *InstallMessage) Print() {
  header()
  
	title    (1, `Description`)
	text     (3, `Install a scriptcs version. If this is the only version installed, then it will be automatically set as the active version at a global level.`)
	lines(1)
	title    (1, `Usage`)
	text     (3, `svm install <version|latest>`)
	text     (3, `svm install <version> <-f|--from> <path> [<-s|--snapshot>]`)
	text     (3, `svm install <version> <-f|--from> <url>`)
	lines(2)
	command  (1, `svm install <version|latest>`)
	lines(1)
	text     (3, `Install scriptcs version indicated by <version>. If <latest> is provided, then the latest stable scriptcs version available will be downloaded and installed.`)
	lines(1)
	subtitle (3, `Examples`)
	lines(1)
	code     (3, `> svm install 0.14.1`)
	code     (3, `> svm install 0.14.0`)
	code     (3, `> svm install latest`)
	lines(1)
	command  (1, `svm install <version> <-f|--from> <path> [<-s|--snapshot>]`)
	lines(1)
	text     (3, `Install scriptcs version from path <path> as version <version>. Path may be a local folder or a local NuGet package. If Path is a local folder, then a soft link to the local folder is created. Use the --snapshot option to create a snapshot of the local folder instead of a soft link.`)
	lines(1)
	subtitle (3, `Examples`)
	lines(1)
	code     (3, `> svm install devbuild -f 'C:\scriptcs\artifacts\Release\bin'`)
	code     (3, `> svm install mysnapshot --from 'C:\scriptcs\artifacts\Release\bin' --snapshot`)
	code     (3, `> svm install 0.11.0 --from 'C:\Downloads\ScriptCs.0.11.0.nupkg'`)
	lines(1)
	command  (1, `svm install <version> <-f|--from> <url>`)
	lines(1)
	text     (3, `Install scriptcs version from url <url> as version <version>. Url must refer to a remote NuGet package directly or must eventually resolve to a remote NuGet package through one or more 302 http responses.`)
	lines(1)
	subtitle (3, `Examples`)
	lines(1)
	code     (3, `> svm install 0.14.1 -f 'https://scriptcs.mydomain.com/ScriptCs.0.14.1-bugfix.nupkg'`)
	code     (3, `> svm install choco-0.14.1 -f 'https://chocolatey.org/api/v2/package/ScriptCs/0.14.1'`)
  
	lines(1)
}
