# CI 

This is a simple CI made with `benderyml` and [git-hooks](https://git-scm.com/book/en/v2/Customizing-Git-Git-Hooks).


## Order of git hooks scritps

### Client side

1. `pre-commit`: Run every time yo made a `git commit`.
2. `prepare-commit-msg`: Run before the commit message is shown to the user.
3. `commit-msg`: Run after the message is edited.
4. `post-commit`: Run after commit.

#### Email hooks

_Only needed when use email with `git am`_

#### Other client hooks

1. `pre-rebase`: Run before a rebase.
2. `post-rewrite`: When rewrite a commit like `git ammend`.
3. `post-merge`: Run after a merge.
4. `pre-push`: Run before a `git push`.

### Server side

1. `pre-receive`: When reciving a `git push`.
2. `update`:  Like before but run one time per branch. 
3. `post-receive`: Use this one to start CI.