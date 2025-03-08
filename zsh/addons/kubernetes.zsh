#!/usr/bin/env zsh

# See https://github.com/ohmyzsh/ohmyzsh/blob/master/plugins/kubectl/kubectl.plugin.zsh for ideas

#
# General
#

alias k='kubectl'

alias kaf='kubectl apply -f'
alias kdf='kubectl delete -f'

alias kx='kubectl exec -t -i' # Connect interactive terminal to container

#
# Contexts
#

alias kc='kubectl config get-contexts'     # List contexts
alias kcs='kubectl config set-context'     # Set context
alias kcc='kubectl config current-context' # Current context
alias kcd='kubectl config delete-context'  # Delete context

#
# Nodes
#

alias kn='kubectl get nodes' # List nodes

#
# Namespaces
#

alias kns='kubectl get namespaces' # List namespaces

#
# Pods
#

alias kp='kubectl get pods' # List pods

#
# Services
# 

alias ks='kubectl get svc' # List services
