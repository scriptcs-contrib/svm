package commands

import (
  "fmt"
  "errors"
  "scriptcs/config"
  "scriptcs/svm/usage"
  "github.com/spf13/cobra"
)

// Commands:
// svm unset <version> <-g|--global>
// svm unset <version> <-l|--local>
  
var (
  errInvalidUnsetUsage = errors.New("Invalid 'svm unset' command usage.")
  unsetCmd = &cobra.Command { Use: "unset", RunE: unset, SilenceErrors: true, SilenceUsage: true }
)

func init() {
  unsetCmd.Flags().BoolVarP(&_global, "global", "g", false, "")
  unsetCmd.Flags().BoolVarP(&_local, "local", "l", false, "")
  unsetCmd.SetHelpFunc( func (*cobra.Command, []string) { usage.NewUnsetMessage().Print()  } )
  svmCmd.AddCommand(unsetCmd)
}

func unset(cmd *cobra.Command, args []string) error {
  if (!isValidUnsetArguments(cmd, args)) {
    return errInvalidUnsetUsage
  }
  
  fmt.Printf("unset command executed...\n")
  fmt.Println(args)
  fmt.Printf("Verbose: %t\n", config.Verbose)
  fmt.Printf("_global: %t\n", _global)
  fmt.Printf("_local: %t\n", _local)
  
  return nil
}

func isValidUnsetArguments(cmd *cobra.Command, args []string) bool {
  // Ensure that only one flag is selected
  var (
    a = _global
    b = _local
  )
  if ( ((a && !b) || (!a && b)) && (len(args) == 1) ) { return true}
  return false
}
