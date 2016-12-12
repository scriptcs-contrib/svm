package path

import (
  "errors"
  "path/filepath"
  "os"
	"scriptcs/messages"
)

var (
  ErrFileNotFound = errors.New("The file or path specified does not exist.")
)

func Exists(path string) bool {
  _, err := os.Stat(path)
  if (err != nil) {
    messages.Verbose("os.Stat():" + err.Error())
    return false
  }
  return true
}

func IsDirectory(path string) bool {
  finfo, err := os.Stat(path)
  if (err != nil) {
    messages.Verbose("os.Stat():" + err.Error())
    return false
  } 
  return finfo.Mode().IsDir() 
}

func IsFile(path string) bool {
  finfo, err := os.Stat(path)
  if (err != nil) {
    messages.Verbose("os.Stat():" + err.Error())
    return false
  } 
  return finfo.Mode().IsRegular() 
}

func FileExt(path string) string {
  return filepath.Ext(path)
}