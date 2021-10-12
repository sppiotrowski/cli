## bash
# bash.cli
# C-r -> C-xC-e -> open in vim and exec
```sh

# print last command
!!:p

# demonize a process
nohup sleep 10000 &>/dev/null & jobs -p %1 > ./_mypid
kill $(cat ./_mypid)

```

# bash.utils
brew install shellcheck  # bash linter
mkdir -p && cd $_  # create and go inside new dir

# bash.syntax
TEST=abc; echo ${TEST//[a-zA-Z]/1}  # simple regex

# bash.apps
cal  # calendar

## python
echo '{"a":"1"}' | python -m json.tool  # format json

## vim
```vim
" current line as bash stdin
.w !bash
```

## git
```sh
# replace link / origin
git remote -v
git remote remove origin
git remote add origin git@github.com:sppiotrowski/<repo>.git

# merge conflict: ours
git co --ours <file>

# replace all
git grep -e redirectToYourShop --name-only | xargs sed -i '' 's/redirectToYourShop/RedirectToYourShop/g'
```
todo: configure tpope/vim-surround

## publish changes to design-guidelines/ott-react-components
# pre-publish
npm run version prepatch && npm run dist

# webpack analyse
webpack --profile --json > stats.json && open http://webpack.github.io/analyse/

