.git.recreate() {
    local proj
    proj=$(.git.project_name)
    local repo
    repo=$(_git_config_url)
    echo "$proj:$repo"
    if [ -z "$proj" ] || [ -z "$repo" ]; then
        echo 'ups...'
        return 1
    fi
    read -p "rm -rf $proj? [N/y]" -n 1 -r
    if [[ $REPLY =~ ^[Yy]$ ]]
    then
        cd ..
        echo "rm -rf ./$proj"
        echo "git clone $repo"
        cd "./$proj" || return
    fi
}

