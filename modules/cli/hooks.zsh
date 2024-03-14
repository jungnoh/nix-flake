function detect_and_setup_tf() {
    if [ "$(find . -name "*.tf" -maxdepth 1 | wc -l | tr -d ' ')" -eq "0" ]; then
        return
    fi

    local required_version
    required_version=$(terraform-config-inspect . --json | jq '.required_core[0]' | tr -d '"')
    if [ -z "$required_version" ]; then
        return
    fi
    echo "Terraform required version: $required_version"

    if ! bin/asdf where terraform "$required_version" &>/dev/null; then
        echo "Installing Terraform $required_version"
        asdf install terraform "$required_version" &>/dev/null
    fi
    if ! asdf where terraform "$required_version" &>/dev/null; then
        echo "Failed to install Terraform $required_version"
        return 1
    fi
    export ASDF_TERRAFORM_VERSION="$required_version"
}

function chpwd() {
    detect_and_setup_tf
}