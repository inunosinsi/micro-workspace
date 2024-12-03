# micro-workspace for Micro
This repository holds the find plugin for micro. This plugin has been updated for use with micro 2.0.
## Install  
```
$ sudo apt update
$ sudo apt install git fzf rg
$ git clone https://github.com/inunosinsi/micro-workspace.git ~/.config/micro/plug/workspace
```
## Usage
Run the command below in the directory set to the root of your workspace.  
```$ mkdir .micro```

When opening a file.  
```> find PATTERN```

When searching for files by pattern.  
```> rg PATTERN```
