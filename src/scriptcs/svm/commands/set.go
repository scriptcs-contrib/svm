package commands

import (
  "fmt"
  "errors"
  "scriptcs/config"
  "scriptcs/svm/usage"
  "github.com/spf13/cobra"
)

// Commands:
// svm set <version> [<-g|--global>]
// svm set <version> <-l|--local>
  
var (
  errInvalidSetUsage = errors.New("Invalid 'svm set' command usage.")
  setCmd = &cobra.Command { Use: "set", RunE: set, SilenceErrors: true, SilenceUsage: true }
)

func init() {
  setCmd.Flags().BoolVarP(&_global, "global", "g", false, "")
  setCmd.Flags().BoolVarP(&_local, "local", "l", false, "")
  setCmd.SetHelpFunc( func (*cobra.Command, []string) { usage.NewSetMessage().Print()  } )
  svmCmd.AddCommand(setCmd)
}

func set(cmd *cobra.Command, args []string) error {
  if (!isValidSetArguments(cmd, args)) {
    return errInvalidSetUsage
  }
  applySetDefaults()
  
  fmt.Printf("set command executed...\n")
  fmt.Println(args)
  fmt.Printf("Verbose: %t\n", config.Verbose)
  fmt.Printf("_global: %t\n", _global)
  fmt.Printf("_local: %t\n", _local)
  
  return nil
}

func applySetDefaults() {
  if (!_global && !_local) { _global = true }
}

func isValidSetArguments(cmd *cobra.Command, args []string) bool {
  // Ensure that no flags are selected (default) or if any are, then ensure that only one is selected
  var (
    a = _global
    b = _local
  )
  if (!a && !b) { return true }
  if ( ((a && !b) || (!a && b)) && (len(args) == 1) ) { return true}
  return false
}
