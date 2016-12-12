package messages

import (
  "time"
  "regexp"
  "runtime"
  "strings"	  
  "scriptcs/config"
  "github.com/fatih/color"
)

var (
  colorCommand    = color.New(color.FgHiCyan)
  colorText       = color.New(color.FgWhite)
  colorHighlight  = color.New(color.FgHiGreen)
  colorVerbose    = color.New(color.FgHiBlack)
  
  colorInfo       = color.New(color.FgBlack).Add(color.BgHiCyan)
  colorWarn       = color.New(color.FgBlack).Add(color.BgYellow)
  colorError      = color.New(color.FgHiWhite).Add(color.BgRed)
)

func Command (message string) {
  colorText.Print(`  `)
  printMessage(message, colorText, colorHighlight)
}

func Text (message string) {
  colorText.Print(`  `)
  printMessage(message, colorText, colorHighlight)
}

func Info (message string) {
  colorText.Print(` `)
  colorInfo.Print(` info  » `)
  colorText.Print(` `)
  printMessage(message, colorText, colorHighlight)
}

func Warn (message string) {
  colorText.Print(` `)
  colorWarn.Print(` warn  » `)
  colorText.Print(` `)
  printMessage(message, colorText, colorHighlight)
}

func Error (message string) {
  colorText.Print(` `)
  colorError.Print(` error » `)
  colorText.Print(` `)
  printMessage(message, colorText, colorHighlight)
}

func Verbose (message string) {
  if (config.Verbose) {
    pc, fn, line, _ := runtime.Caller(1)
    t := time.Now().Format(time.RFC3339)
    file := strings.Split(fn, "src/")
    colorVerbose.Printf(" [%s] [%s:%d] %s\n", t, file[1], line, runtime.FuncForPC(pc).Name())
    printMessage(" » " + message, colorVerbose, colorText)
  }
}

func printMessage(message string, normalColour *color.Color, highlightColour *color.Color) {
  var (
    strindex  = 0
	  highlight = ""
  )
  
	r, _ := regexp.Compile("{{[^}]+}}")
	i := r.FindAllStringIndex(message, -1)
	t := r.FindAllString(message, -1)
	for index,element := range i {
    normalColour.Print(message[strindex:element[0]])
	  strindex = element[1]
	  highlight = t[index]
	  highlight = strings.Replace(highlight , "{{", "", -1)
    highlight = strings.Replace(highlight , "}}", "", -1)
    highlightColour.Print(highlight)
	}
  normalColour.Println(message[strindex:])
}