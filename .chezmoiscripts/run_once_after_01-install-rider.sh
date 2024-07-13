{{ if eq .chezmoi.os "linux" -}}
#!/bin/bash

jb refresh rider --install

{{ end -}}