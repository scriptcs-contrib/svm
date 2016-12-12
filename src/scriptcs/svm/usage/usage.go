package usage

import (
	"fmt"
  "strings"
  "scriptcs/svm/version"
	"github.com/fatih/color"
)

var (
	titleColour    = color.New(color.FgHiGreen)
	subtitleColour = color.New(color.FgWhite).Add(color.Underline)
	textColour     = color.New(color.FgWhite)
	commandColour  = color.New(color.FgHiCyan)
  codeColour     = color.New(color.FgWhite)
)

// Message is the interface that must be implemented by all the usage messages.
type Message interface { 
  Print() 
}

// header prints out the version header.
func header() {
  version.NewHeader().Print()
	lines(1)
}

// lines prints n empty lines to the console.
func lines(n int) {
	for i := 0; i < n; i++ { fmt.Println() }
}

func title(indent int, message string) {
  fmt.Print(strings.Repeat(" ", indent))
  titleColour.Println(message)
}

func subtitle(indent int, message string) {
  fmt.Print(strings.Repeat(" ", indent))
  subtitleColour.Println(message)
}

func text(indent int, message string) {
  fmt.Print(strings.Repeat(" ", indent))
  textColour.Println(message)
}

func command(indent int, message string) {
  fmt.Print(strings.Repeat(" ", indent))
  commandColour.Println(message)
}

func code(indent int, message string) {
  fmt.Print(strings.Repeat(" ", indent))
  codeColour.Println(message)
}