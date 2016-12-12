package main

import (  
  "scriptcs/config"
  "scriptcs/svm/commands"  
)

func main() {
  config.Verbose = false
   
  commands.Execute()
}