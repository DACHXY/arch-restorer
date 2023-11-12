# === FUNCTION === #
# SSH Agent when SSH connected
run_ssh_agent() {
    eval $(ssh-agent)
    ssh-add "$HOME/.ssh/dachxy_git_rsa"
}

# Run app silently
run_silent() {
    "$@" &> /dev/null
}
