package version

// svm version constants
const versionLabel string = "1.0"

// Header is the interface that must be implemented by all header messages
type Header interface {
  Print()
}

// NewHeader will return the configured default header
func NewHeader() Header {
  return NewASCIIHeader()
}

// Label returns the svm version label
func Label() string {
  return versionLabel
}

