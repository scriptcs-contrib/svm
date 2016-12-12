package commands

import (
  "scriptcs/config"
  "scriptcs/svm/usage"
  "scriptcs/svm/version"
  "scriptcs/messages"
  "github.com/spf13/cobra"
	
)

var (
  _version, _snapshot, _installed, _remote, _active, _global, _local bool
  _from string
  svmCmd = &cobra.Command { Use: "svm", Run: svm, SilenceErrors: true, SilenceUsage: true }
)

func init() {
  svmCmd.Flags().BoolVarP(&_version, "version", "v", false, "")
  svmCmd.PersistentFlags().BoolVarP(&config.Verbose, "verbose", "", false, "")
  svmCmd.SetHelpFunc( func (*cobra.Command, []string) { usage.NewOverviewMessage().Print()  } )
  svmCmd.SetUsageFunc( func (*cobra.Command) error { return nil } )
}

func svm (cmd *cobra.Command, args []string) {
  if (_version) {
    version.NewHeader().Print()
    return
  }     
  helpFunc := cmd.HelpFunc()
  helpFunc(cmd, args)
}

// Execute the command pipeline
func Execute() {
  cmd, err := svmCmd.ExecuteC()
  if err != nil {
    messages.Verbose(err.Error())    
    messages.Text("")
    messages.Error(err.Error())    
    helpFunc := cmd.HelpFunc()
    helpFunc(cmd, []string{})
  }  
}
