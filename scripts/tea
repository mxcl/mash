#!/usr/bin/env -S pkgx +gum +gh +git +jq bash -eo pipefail

gum format \
 '# register packages on tea' \
 'this script uses the official \`gh\` tool to find repos' \
 'and create pull requests with your \`tea.yaml\` file'

echo  # spacer

gum format \
  '## firstly, your tea wallet address'

addr="$(gum input --width=42 --placeholder='you can find this by clicking your avatar in the top right')"

if ! gh auth status > /dev/null; then
  gum format \
  	"## \`gh\` authentication required" \
	'you will be prompted to auth with the \`gh\` tool' \
	'if you don’t trust us then do it yourself with \`[pkgx] gh auth login\`'

  gh auth login
fi

echo  # spacer

full_repo_list="$(gh repo list --json=nameWithOwner --no-archived --visibility=public --limit 1000 --jq '.[].nameWithOwner')"

gum format \
  	"## select repos on which to create pull requests" \
	'press space to select and enter when done' \

while test -z "$repos"; do
	repos="$(gum choose --no-limit $full_repo_list)"
done

user="$(gh api /user --jq .login)"
file="$(mktemp)"


cat <<EoYML >"$file"
# https://tea.xyz/what-is-this-file
# created with https://mash.pkgx.sh/mxcl/tea-register
---
version: 1.0.0
codeOwners:
  - '$addr'  # $user
quorum: 1
EoYML

echo  # spacer

gum format \
  '## yaml' \
  '```' \
  "$(cat "$file")" \
  '```'

for repo in $repos; do
	echo  # spacer
	gum format "## creating pull request for $repo"

	tmpdir="$(mktemp -d)"
	cd "$tmpdir"
	gh repo clone $repo .
	cp "$file" ./tea.yaml
	git add ./tea.yaml
	git commit -m 'participate in tea protocol'
	git branch -m brew-tea
	git push origin brew-tea
	gh pr create \
		--title 'participate in tea protocol' \
		--body 'this repo is participating in the tea protocol' \
		--head brew-tea
done

echo  # spacer
gum format \
	'# all done' \
	'click all the links above to see your pull requests' \
	'[improve this script!](https://github.com/mxcl/mash)'
