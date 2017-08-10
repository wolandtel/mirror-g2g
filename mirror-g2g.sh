#!/bin/bash

scriptName="$(basename $0)"
cfgName=${scriptName/.sh/.conf}
cfg=("$(dirname $0)/$cfgName" $HOME/.config/$cfgName)
for c in ${cfg[@]}; do
	[ -r "$c" ] && {
		. "$c"
		break
	}
done
[[ -z "$GITHUB_USER" || -z "$GITLAB_SYS_USER" || -z "$REPODIR" ]] && \
{
	if [ -r "$c" ]; then
		echo "Configuration file '$c' is incomplete" >&2
	else
		echo "Configuration file doesn't exist" >&2
	fi
	exit 1
}

CH_DIR="custom_hooks"
HOOK_FILE="post-receive"
HOOK="/usr/bin/git push --quiet github &"

function usage ()
{
	echo "USAGE: $scriptName <namespace>/<repository>"
}

if [[ $(id -u) -eq 0 ]]; then
	su - $GITLAB_SYS_USER -c "'$0' $@"
	let res=1000+$?
	exit $res
fi

if [[ "$(id -un)" != "$GITLAB_SYS_USER" ]]; then
	echo "ERROR: You should be root or $GITLAB_SYS_USER to perform operation" >&2
	exit 2
fi

r=($(echo "$1" | sed -r 's#.*/([^/]+/[^/]+)#\1#; s#\.git$##; s#/# #'))
namespace=${r[0]}
repository=${r[1]}

if [[ -z "$namespace" || -z "$repository" ]]; then
	usage
	exit 3
fi

github="git@github.com:$GITHUB_USER/$repository.git"
gitlab="$REPODIR/$namespace/$repository.git"

[ -d "$gitlab" ] || {
	echo "ERROR: GitLab repository $namespace/$repository doesn't exists" >&2
	exit 4
}

git ls-remote -qh "$github" > /dev/null 2>&1 || {
	echo "ERROR: GitHub repository '$repository' doesn't exists or deploy key hasn't been configured on GitHub" >&2
	exit 5
}

cd "$gitlab"
git remote add --mirror=push github "$github" || exit 6

[ -d "$CH_DIR" ] || mkdir "$CH_DIR"
cd "$CH_DIR"

[ -e "$HOOK_FILE" ] && {
	echo "ERROR: $(pwd)/$HOOK_FILE already exists. Please add string '$HOOK' manually if hook is bash script"
	exit 7
}

cat > "$HOOK_FILE" <<EOF
#!/bin/bash
$HOOK
EOF
chmod 755 "$HOOK_FILE"
