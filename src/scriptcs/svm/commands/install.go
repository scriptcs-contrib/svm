package commands

import (
	"errors"
  "fmt"
  "strings"
  "scriptcs/messages"
  "scriptcs/svm/usage"  
	"scriptcs/svm/path"
  "github.com/spf13/cobra"
)

// Commands:
// svm install <version|latest>
// svm install <version> <-f|--from> <path> [<-s|--snapshot>]
// svm install <version> <-f|--from> <url>
  
var (
  installCmd = &cobra.Command { Use: "install", RunE: install, SilenceErrors: true, SilenceUsage: true }
)

func init() {
  installCmd.Flags().StringVarP(&_from, "from", "f", "", "")
  installCmd.Flags().BoolVarP(&_snapshot, "snapshot", "s", false, "")  
  installCmd.SetHelpFunc( func (*cobra.Command, []string) { usage.NewInstallMessage().Print()  } )
  svmCmd.AddCommand(installCmd)
}

func install(cmd *cobra.Command, args []string) error {
  messages.Verbose(`Executing {{svm install}} command ...`)

  ok, msg := isValidInstallArguments(cmd, args)
  if (!ok) { 
    return errors.New("Invalid {{svm install}} command usage. " + msg) 
  }
  
  fromType := "repository"
  if (_from != "") { fromType = "path" }
  if (strings.HasPrefix(strings.ToLower(_from), "http")) { fromType = "http" } 
  
  svmInstallCommand := &svmInstallCommand { 
    Version:    args[0],
    From:       _from,
    FromType:   fromType,
    Snapshot:   _snapshot,
  }
 
  return svmInstallCommand.Execute()
}

type svmInstallCommand struct {
  Version     string
  From        string
  FromType    string
  Snapshot    bool
}

func (s *svmInstallCommand) Execute() error {
  
  fmt.Printf("%+v\n", s)
  return nil
}

func isValidInstallArguments(cmd *cobra.Command, args []string) (bool, string) {
  var (
    isPath      = _from != "" && !strings.HasPrefix(strings.ToLower(_from), "http")
    isFile      = isPath && path.Exists(_from) && path.IsFile(_from)
    isHTTP      = _from != "" && strings.HasPrefix(strings.ToLower(_from), "http")
    message     = ""
  )
  
  if (len(args) != 1) {
    message = `No {{<version>}} was specified.`
    messages.Verbose(message)
    return false, message
  }
  if (isPath && !path.Exists(_from)) {
    message = `The {{<path>}} specified cannot be found.`
    messages.Verbose(message)
    return false, message
  } 
  if (isFile && path.FileExt(_from) != ".nupkg") {
    message = `Cannot specify a file that is not a nupkg.`
    messages.Verbose(message)
    return false, message
  }
  if (isFile && _snapshot) {
    message = `Cannot specify {{<-s|--snapshot>}} when using a {{<path>}} that refers to a file.`
    messages.Verbose(message)
    return false, message
  }
  if (isHTTP && _snapshot) {
    message = `Cannot specify {{<-s|--snapshot>}} when using a {{<url>}}.` 
    messages.Verbose(message)
    return false, message
  }
  
  return true, ""
}