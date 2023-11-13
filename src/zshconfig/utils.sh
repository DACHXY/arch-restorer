# === FUNCTION === #
# SSH Agent when SSH connected
run_ssh_agent() {
    eval $(ssh-agent)
    if [[ -e "$HOME/.ssh/dachxy_git_rsa" ]]; then
        ssh-add "$HOME/.ssh/dachxy_git_rsa"
    fi
}

# Run app silently
run_silent() {
    "$@" &> /dev/null
}
