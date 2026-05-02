# Shell options
setopt PROMPT_SUBST

# Environment variables
export GPG_TTY=$(tty)

# Utility functions
git_clean_branches() {
	echo "--- Fetching and pruning ---"
	git fetch --prune

	local branches_to_delete=$(git branch --merged | grep -vE '^\*|master|main|stable')

	if [ -n "$branches_to_delete" ]; then
		echo "--- Deleting merged branches ---"
		echo "$branches_to_delete" | xargs -n 1 git branch -d
	else
		echo "--- No merged branches to delete ---"
	fi
}

fl() {
	local base="${1:-.}"
	local abs_base="$(cd "$base" && pwd)"

	(
		cd "$abs_base" || exit

		for f in **/*(D); do
			if [[ -d $f ]]; then
				print "$abs_base/$f/"
			else
				print "$abs_base/$f"
			fi
		done
	)
}

# Aliases
alias gbclean=git_clean_branches
alias ll='ls -la'
alias uuid="uuidgen | tr '[:upper:]' '[:lower:]' | tr -d '\n' | pbcopy"
alias l_rmnode='find . -type d -name "node_modules" -prune -exec rm -rf '{}' +'
alias rmnode="rm -rf -- **/node_modules(/N)"

# Prompt appearance
COLOR_DEF='%f'
COLOR_USR='%F{243}'
COLOR_DIR='%F{197}'
COLOR_GIT='%F{39}'

PROMPT='${COLOR_USR}%n ${COLOR_DIR}%~${vcs_info_msg_0_} ${COLOR_DEF}$ '

# Version control (Git prompt integration)
autoload -Uz vcs_info
autoload -U zmv

zstyle ':vcs_info:*' enable git
zstyle ':vcs_info:*:*' check-for-changes true
zstyle ':vcs_info:*:*' unstagedstr '%F{red}*'
zstyle ':vcs_info:*:*' formats       " ${COLOR_GIT}(%b%u)${COLOR_DEF}"
zstyle ':vcs_info:*:*' actionformats " ${COLOR_GIT}(%b%u | %a)${COLOR_DEF}"

precmd_functions+=(vcs_info)
