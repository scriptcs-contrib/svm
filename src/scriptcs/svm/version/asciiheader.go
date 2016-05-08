package version

import (
  "github.com/fatih/color"
)

// ASCIIHeader holds the state for the ascii header
type ASCIIHeader struct {
  colour  *color.Color
  label   string
}

// NewASCIIHeader returns an intialised ASCIIHeader struct
func NewASCIIHeader() *ASCIIHeader { 
  return &ASCIIHeader { 
    colour: color.New(color.FgHiCyan),
    label:  versionLabel,
  } 
}

// Print prints out the svm version header
func (h *ASCIIHeader) Print() {
  h.colour.Println("    ______   ______ ___")
  h.colour.Println("   / ___/ | / / __ `__ \\")
  h.colour.Println("  (__  )| |/ / / / / / /")
  h.colour.Println(" /____/ |___/_/ /_/ /_/")
  h.colour.Printf("             scriptcs version manager %s\n", h.label)
}
