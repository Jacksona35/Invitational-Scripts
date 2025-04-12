#!/bin/bash

# List of scoring usernames
users=(
  benjamin_franklin alexander_hamilton john_adams theodore_roosevelt
  winston_churchill florence_nightingale eleanor_roosevelt mother_teresa
  mahatma_gandhi socrates plato aristotle hippocrates archimedes
  rene_descartes voltaire jean_jacques_rousseau immanuel_kant
  friedrich_nietzsche sigmund_freud charles_darwin marie_antoinette
  louis_xiv peter_the_great
)

for user in "${users[@]}"; do
  # Create user with home directory if it doesn't exist
  if ! id "$user" &>/dev/null; then
    sudo adduser --disabled-password --gecos "" "$user"
  fi

  # Setup SSH directory and permissions
  sudo mkdir -p /home/$user/.ssh
  sudo chmod 700 /home/$user/.ssh
  sudo touch /home/$user/.ssh/authorized_keys
  sudo chmod 600 /home/$user/.ssh/authorized_keys
  sudo chown -R $user:$user /home/$user/.ssh
done
