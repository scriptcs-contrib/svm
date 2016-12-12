package commands

import (
  "fmt"
  "scriptcs/config"
  "scriptcs/svm/usage"
  "github.com/spf13/cobra"
)

// Commands:
// svm upgrade
  
var (
  upgradeCmd = &cobra.Command { Use: "upgrade", RunE: upgrade, SilenceErrors: true, SilenceUsage: true }
)

func init() {
  upgradeCmd.SetHelpFunc( func (*cobra.Command, []string) { usage.NewUpgradeMessage().Print()  } )
  svmCmd.AddCommand(upgradeCmd)
}

func upgrade(cmd *cobra.Command, args []string) error {
  fmt.Printf("upgrade command executed...\n")
  fmt.Println(args)
  fmt.Printf("Verbose: %t\n", config.Verbose)
  
  return nil
}
