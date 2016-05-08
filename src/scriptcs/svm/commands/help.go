package commands

import (
  "errors"
  "fmt"  
  "strings"
  "scriptcs/messages"
	"scriptcs/svm/usage"
  "github.com/spf13/cobra"
)

// Commands:
// svm help [<command>]

var (
  message = ""
  helpCmd = &cobra.Command { Use: "help [command]", RunE: help, SilenceErrors: true, SilenceUsage: true }
)

func init() {
  helpCmd.SetHelpFunc( func (*cobra.Command, []string) { usage.NewOverviewMessage().Print()  } )
  svmCmd.AddCommand(helpCmd)
}

func help(cmd *cobra.Command, args []string) error {
  messages.Verbose(`Executing {{svm help}} command ...`)
  
  ok, msg := isValidHelpArguments(cmd, args)
  if (!ok) { 
    return errors.New("Invalid {{svm help}} command usage. " + msg) 
  }
  
  var command string
  if (len(args) == 1) { command = args[0] } 
  
  svmHelpCommand := &svmHelpCommand {
    Command:      command, 
    DisplayHelp:  func() {
                    c, _, _ := cmd.Root().Find(args)
                    helpFunc := c.HelpFunc()
                    helpFunc(c, args)
                  },
  }
  
  return svmHelpCommand.Execute()
}

type svmHelpCommand struct {
  Command       string
  DisplayHelp   func()
}

func (s *svmHelpCommand) Execute() error {
  message = "Displaying general help."
  if (s.Command != "") { message = fmt.Sprintf("Displaying help for {{%s}} command.", s.Command) } 
  messages.Verbose(message) 

  s.DisplayHelp()
  return nil
}

func isValidHelpArguments(cmd *cobra.Command, args []string) (bool, string) {
  var message = ""
  
  if (len(args) != 0 && len(args) > 1) {
    message = fmt.Sprintf("Multiple topics {{%v}} specified for the help.", strings.Join(args, ", "))
    messages.Verbose(message)
    return false, message
  }
  // The command must be defined
  c, _, e := cmd.Root().Find(args)
  if (c == nil || e != nil) {
    message = fmt.Sprintf("The help topic {{%s}} is invalid.", args[0]) 
    messages.Verbose(message)
    return false, message
  }
  
  return true, "" 
}