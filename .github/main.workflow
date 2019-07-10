workflow "Push" {
  on = "push"
  resolves = ["Generate formulae.brew.sh"]
}

action "Generate formulae.brew.sh" {
  uses = "docker://linuxbrew/brew"
  runs = ".github/linux.workflow.sh"
  secrets = [
    "FORMULAE_DEPLOY_KEY",
    "ANALYTICS_JSON_KEY",
  ]
}
