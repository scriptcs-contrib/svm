package commands

import (
  "fmt"
  "errors"  
  "scriptcs/config"
  "scriptcs/svm/usage"
	"github.com/spf13/cobra"
)

// Commands
// svm uninstall <version>

var (
  errInvalidUninstallUsage = errors.New("Invalid 'svm uninstall' command usage.")
  uninstallCmd  = &cobra.Command { Use: "uninstall", RunE: uninstall, SilenceErrors: true, SilenceUsage: true }
)

func init() {
  uninstallCmd.SetHelpFunc( func (*cobra.Command, []string) { usage.NewUninstallMessage().Print()  } )
  svmCmd.AddCommand(uninstallCmd)
}

func uninstall(cmd *cobra.Command, args []string) error {
  if (!isValidUninstallArguments(cmd, args)) {
    return errInvalidUninstallUsage
  }
  
  fmt.Printf("uninstall command executed...\n")
  fmt.Println(args)
  fmt.Printf("Verbose %t\n", config.Verbose)
  return nil
}

func isValidUninstallArguments(cmd *cobra.Command, args []string) bool {
  return len(args) == 1
}