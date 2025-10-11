#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
alias grep='grep --color=auto'

# Check if the terminal supports colors
if [ -t 1 ]; then
  # For PS1 (escaped)
  RED='\[\033[0;31m\]'
  CYAN='\[\033[0;36m\]'
  MAGENTA='\[\033[0;35m\]'
  YELLOW='\[\033[0;33m\]'
  WHITE='\[\033[1;37m\]'
  NC='\[\033[0m\]'

  # For functions (raw)
  RAW_RED=$'\033[0;31m'
  RAW_CYAN=$'\033[0;36m'
  RAW_YELLOW=$'\033[0;33m'
  RAW_NC=$'\033[0m'
else
  RED=''; CYAN=''; MAGENTA=''; YELLOW=''; WHITE=''; NC=''
  RAW_RED=''; RAW_CYAN=''; RAW_YELLOW=''; RAW_NC=''
fi

git_prompt_info() {
  # Return empty if not in a git repo
  if ! git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
    echo ""
    return
  fi

  local branch staged unstaged untracked
  branch=$(git symbolic-ref --short HEAD 2>/dev/null || git rev-parse --short HEAD 2>/dev/null)
  status_output=$(git status --porcelain 2>/dev/null || true)

  # Detect staged, unstaged, untracked changes
  if printf '%s\n' "$status_output" | grep -q '^[MADRC]'; then
    staged="${RAW_YELLOW}+"
  fi

  if printf '%s\n' "$status_output" | grep -q '^.[MD]'; then
    unstaged="${RAW_RED}*"
  fi

  if printf '%s\n' "$status_output" | grep -q '^??'; then
    untracked="${RAW_RED}?"
  fi

  # Proper color reset after symbols so the closing ) is not tinted
  echo "(${RAW_CYAN}${branch}${RAW_NC}${staged}${unstaged}${untracked}${RAW_NC})"
}

# Proper PS1
# - includes color reset at the very end
# - includes $ for clarity
PS1="[${RED}\u${NC}${WHITE}@${CYAN}\h${NC} ${MAGENTA}\w${NC}] \[\$(git_prompt_info)\]${NC} \$ "

# Export PATH
export PATH=$HOME/.local/bin:$PATH
