#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
alias grep='grep --color=auto'

# Check if the terminal supports colors
if [ -t 1 ]; then
  # Define colors with \[ \] for use in PS1
  RED='\[\033[0;31m\]'
  CYAN='\[\033[0;36m\]'
  MAGENTA='\[\033[0;35m\]'
  YELLOW='\[\033[0;33m\]'
  WHITE='\[\033[1;37m\]'
  NC='\[\033[0m\]'
  # Define colors without \[ \] for use in git_prompt_info
  RAW_RED='\033[0;31m'
  RAW_CYAN='\033[0;36m'
  RAW_YELLOW='\033[0;33m'
  RAW_NC='\033[0m'
else
  # Fallback to no colors if terminal doesn't support them
  RED=''
  CYAN=''
  MAGENTA=''
  YELLOW=''
  WHITE=''
  NC=''
  RAW_RED=''
  RAW_CYAN=''
  RAW_YELLOW=''
  RAW_NC=''
fi

# Git prompt function
function git_prompt_info() {
  # Check if inside a Git repository
  if ! git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
    echo ""
    return
  fi

  # Get the current branch
  local branch
  branch=$(git symbolic-ref --short HEAD 2>/dev/null || git rev-parse --short HEAD 2>/dev/null)

  # Initialize status indicators
  local staged=""
  local unstaged=""
  local untracked=""

  # Parse git status
  local status_output
  status_output=$(git status --porcelain 2>/dev/null)

  # Debug: Log the status_output to a file for inspection
  echo "$status_output" > /tmp/git_prompt_debug.log

  # Check for staged changes (lines starting with M, A, D, R, or C in the first column)
  if echo "$status_output" | grep -q '^[MADRC][ MTD]'; then
    staged="${RAW_YELLOW}+"
  fi

  # Check for unstaged changes (lines with M or D in the second column)
  if echo "$status_output" | grep -q '^.[MD]'; then
    unstaged="${RAW_RED}*"
  fi

  # Check for untracked files (lines starting with ??)
  if echo "$status_output" | grep -E '^\?\?'; then
    untracked="${RAW_RED}?"
  fi

  # Construct the Git prompt
  echo "(${RAW_CYAN}${branch}${staged}${unstaged}${untracked}${RAW_NC})"
}

# Set PROMPT_COMMAND to ensure dynamic updates
PROMPT_COMMAND='PS1="[${RED}\u${NC}${WHITE}@${CYAN}\h${NC} ${MAGENTA}\w${NC}] \[$(git_prompt_info)\] "'


# PS1='[\u@\h \W]\$ '
export PATH=$HOME/.local/bin:$PATH
