# repo-completion
Bash completion for changing directories to a git repository.

## Background
I have git repositories in several locations. The ones that have
software written in golang are under `~/go/src/${site}/${org}/${name}`,
where all three of those things can vary wildly. I have a bunch of other
stuff under `~/Work/${org}/${name}`. A lot of the time when I want to go
work on one of these, I can't remember what `${site}` or `${org}` is.
Heck, maybe I can't even remember how to spell `${name}`.

Enter `repo-completion`.

With a little bit of configuration (e.g. in my case telling it to start
looking at `~/go/src` and `~/Work`) I can use the `repo` bash function
with the `Tab` key just like I would for regular directories or
whatever.

```shell
$ pwd
/home/efried
$ repo aw<Tab>
         s-<Tab><Tab>
aws-account-operator  aws-efs-manage        aws-k8s-tester        
aws-efs-csi-driver    aws-efs-operator      aws-sdk-go            
           sd<Tab>
             k-go<Enter>
/home/efried/go/src/github.com/aws/aws-sdk-go
$ pwd
/home/efried/go/src/github.com/aws/aws-sdk-go
```

## Installation

0. Copy `repo-completion/repo-completion.bash` somewhere. Or not.
1. Create a [config file](#configuration) in the same directory. Or not.
2. Source `repo-completion.bash` from your `.bashrc` with a line like:

```bash
source /home/efried/bin/repo-completion.bash
```

3. Re-source your `.bashrc`, or re-log in, or open a new terminal, or
   whatever to load it up.

## Configuration
`repo-completion.bash` will look for a file called
`repo-completion.conf` in the same directory. This file should contain a
list of starting directories under which `repo` should search for git
repositories. For efficiency, `repo` only searches to a maximum depth of
four subdirectories, so you probably can't just say, like, `/home`. For
example, my `repo-completion.conf` looks like this:

```
# Golang stuff
/home/efried/go/src

# Other stuff
/home/efried/Work
```

## Usage
Once `repo-completion.bash` is sourced, it defines a new bash function
called `repo`. It accepts a single argument: the `${name}` of a
repository, optionally qualified with its `${org}`, and `cd`s to the
appropriate directory. For example, if I have a repository at
`/home/efried/go/src/github.com/kubernetes-sigs/aws-efs-csi-driver`, and
I have `/home/efried/go/src` in my [config](#configuration), then the
following all do the same thing:

```
$ repo aws-efs-csi-driver

$ repo kubernetes-sigs/aws-efs-csi-driver

$ cd /home/efried/go/src/github.com/kubernetes-sigs/aws-efs-csi-driver
```

The handy thing is that, using the first form, I can type any initial
substring of `aws-efs-csi-driver` and use tab completion to get the
rest.

With the second form, I actually have to type in the full `${org}/`
prefix (e.g. `kubernetes-sigs/a<Tab>` before completion will start to
work, but that's a limitation I hope to fix soon.

## Contributing
PRs welcome.
