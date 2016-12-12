package commands

import (
  "fmt"
  "errors"
  "scriptcs/config"
  "scriptcs/svm/usage"
  "github.com/spf13/cobra"
)

// Commands:
// svm info <version>
  
var (
  errInvalidInfoUsage = errors.New("Invalid 'svm info' command usage.")
  infoCmd = &cobra.Command { Use: "info", RunE: info, SilenceErrors: true, SilenceUsage: true }
)

func init() {
  infoCmd.SetHelpFunc( func (*cobra.Command, []string) { usage.NewInfoMessage().Print()  } )
  svmCmd.AddCommand(infoCmd)
}

func info(cmd *cobra.Command, args []string) error {
  if (!isValidInfoArguments(cmd, args)) {
    fmt.Println(args)
    return errInvalidInfoUsage
  }
  
  fmt.Printf("info command executed...\n")
  fmt.Println(args)
  fmt.Printf("Verbose: %t\n", config.Verbose)
  return nil
}

func isValidInfoArguments(cmd *cobra.Command, args []string) bool {
  return len(args) == 1
}