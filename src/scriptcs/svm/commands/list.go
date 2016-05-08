package commands

import (
  "fmt"
  "errors"
  "scriptcs/config"
  "scriptcs/svm/usage"
  "github.com/spf13/cobra"
)

// Commands:
// svm list [<-i|--installed>]
// svm list <-r|--remote>
// svm list <-a|--active>
  
var (
  errInvalidListUsage = errors.New("Invalid 'svm list' command usage.")
  listCmd = &cobra.Command { Use: "list", RunE: list, SilenceErrors: true, SilenceUsage: true }
)

func init() {
  listCmd.Flags().BoolVarP(&_installed, "installed", "i", false, "")
  listCmd.Flags().BoolVarP(&_remote, "remote", "r", false, "")
  listCmd.Flags().BoolVarP(&_active, "active", "a", false, "")    
  listCmd.SetHelpFunc( func (*cobra.Command, []string) { usage.NewListMessage().Print()  } )
  svmCmd.AddCommand(listCmd)
}

func list(cmd *cobra.Command, args []string) error {
  if (!isValidListArguments(cmd, args)) {
    return errInvalidListUsage
  }
  applyListDefaults()
  
  fmt.Printf("list command executed...\n")
  fmt.Println(args)
  fmt.Printf("Verbose: %t\n", config.Verbose)
  fmt.Printf("_installed: %t\n", _installed)
  fmt.Printf("_remote: %t\n", _remote)
  fmt.Printf("_active: %t\n", _active)
  
  return nil
}

func applyListDefaults() {
  if (!_installed && !_remote && !_active) { _installed = true }
}

func isValidListArguments(cmd *cobra.Command, args []string) bool {
  // Ensure that no flags are selected (default) or if any are, then ensure that only one is selected
  var (
    a = _installed
    b = _remote
    c = _active
  )
  if (!a && !b && !c) { return true }
  return ((a && !b && !c) || (!a && b && !c) || (!a && !b && c)) 
}
