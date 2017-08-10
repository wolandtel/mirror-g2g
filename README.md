# DESCRIPTION
This script helps you to create GitHub mirrors of your GitLab repositories. You should have filesystem access to your GitLab server as **root** or **\<gitlab system user>** to use it. Original respository: https://git.woland.me/adm/mirror-g2g

# CONFIGURATION
* Copy `mirror-g2g.conf.samle` to `mirror.g2g.conf`.
* Configure your github username, name of the gitlab system user and gitlab repositories dir (as described at **"Gitlab custom hooks"**).
* `su - <gitlab system user> -c ssh-keygen`.
* add **~\<gitlab system user>/.ssh/id_rsa.pub** to github deploy keys.

# USAGE
To create mirror of **\<group>/\<repository>.git**:
* Create **\<repository>** GitHub repository (or import it from GitLab with GitHub importing tool).
* Run `mirror-g2g.sh <group>/<repository>` as **root** or **\<gitlab system user>** user.

# HELP TOPICS
## StackExchange
1. GitLab to GitHub mirror configuring: https://stackoverflow.com/questions/21962872/how-to-create-a-gitlab-webhook-to-update-a-mirror-repo-on-github  
	See also:  
		https://stackoverflow.com/questions/14288288/gitlab-repository-mirroring
2. Checking for remote git repository: https://superuser.com/questions/227509/git-ping-check-if-remote-repository-exists
3. Scripting with 'su': https://stackoverflow.com/questions/3420280/can-i-run-su-in-the-middle-of-a-bash-script

## GitLab custom hooks
https://docs.gitlab.com/ee/administration/custom_hooks.html

## Native GitLab Enterprise mirroring feature
https://about.gitlab.com/2016/05/10/feature-highlight-push-to-remote-repository/
