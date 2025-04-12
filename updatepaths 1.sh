#!/bin/bash

scoring_users=(
benjamin_franklin alexander_hamilton john_adams theodore_roosevelt
winston_churchill florence_nightingale eleanor_roosevelt mother_teresa
mahatma_gandhi socrates plato aristotle hippocrates archimedes
rene_descartes voltaire jean_jacques_rousseau immanuel_kant
friedrich_nietzsche sigmund_freud charles_darwin marie_antoinette
louis_xiv peter_the_great
)

for user in "${scoring_users[@]}"; do
    wrong_path="/home/${user}1/.ssh/authorized_keys"
    right_path="/home/${user}/.ssh/authorized_keys"
    
    # If the key is in the wrong path
    if [ -f "$wrong_path" ]; then
        echo "Fixing authorized_keys for $user"

        sudo mkdir -p "/home/${user}/.ssh"
        sudo mv "$wrong_path" "$right_path"

        sudo chown -R "$user:$user" "/home/$user/.ssh"
        sudo chmod 700 "/home/$user/.ssh"
        sudo chmod 600 "$right_path"
    fi
done
