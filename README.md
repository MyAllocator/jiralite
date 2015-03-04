# jiralite
Light command line tool implemented in perl to interact with JIRA tickets.

This package is not publicly maintained. You are free to use it but don't expect any support :)

## Installation

```
cd ~/Downloads
git clone https://github.com/MyAllocator/jiralite.git
ln -s ~/Downloads/jiralite/jiralite.pl /usr/bin/js
js -h
```

If code resides outside of @INC:

```
export PERL5LIB=$PERL5LIB:/dir/to/jiralite
```

## Dependencies

The following perl packages are required:

1. JIRA::Client::Automated (https://metacpan.org/pod/JIRA::Client::Automated)
2. CLI::Framework (https://metacpan.org/pod/CLI::Framework)
3. Term::Prompt (https://metacpan.org/pod/Term::Prompt)

```
cpanm JIRA::Client::Automated
cpanm CLI::Framework
cpanm Term::Prompt
```

## Configuration

Setup environment variables
(you might even consider adding them to your ~/.bashrc)

```
export JIRALITE_PROJECT="" ##  Ex. MYAL for MYAL-123 tickets
export JIRALITE_URL="https://your_domain.atlassian.net/"  ## 
export JIRALITE_SPRINT="201503A"
export JIRALITE_SPRINT_ID="23"
```

Jira credentials are read from ~/.jira_credentials (username:password).


```
echo "your_username:your_password" > ~/.jira_credentials
chmod 600 ~/.jira_credentials
```

Modify url, project, sprint, etc in JiraLite/Config/Jira.pm to fit your environment.

## Usage

```
batman@thecave:~# jl -h

    Usage: /usr/bin/jl <verb> <args> ...

      # Help (this)
      <h|help>

      # View issue information
      <v|view> <TID>
      view XXX-000

      # Create new issue (interactive)
      <c|create>

      # Delete an issue
      <d|delete> <TID>
      delete XXX-000

      # Create a comment on an issue
      <com|comment> <TID> <comment>
      comment XXX-000 "This is a comment"

      # Assign issue to a user
      <a|assign> <TID> <none|brianh|mo|lukasz|nate>
      assign XXX-000 nate

      # Transition an issue to a new status
      <s|status> <TID> <"To Do"|Design|Development|Review|Stage|Done>
      status XXX-000 Review

      # Rush issue to Done status
      <r|rush> <TID>
      rush XXX-000

      # Update an issue type
      <t|type> <TID> <Improvement|"New Feature"|"Hot Potato"|Task>
      type XXX-000 "Hot Potato"

      # Update an issue priority
      <p|priority> <TID> <Blocker|Critical|Major|Minor|Trivial>
      priority XXX-000 Blocker

      # Update an issue sprint (View an issue in sprint and look for [#] by sprint. Ex: Sprint 201502-A [23> has id 23.)
      <spr|sprint> <TID> <SID|none>
      sprint XXX-000 23

    Options:
      -h, --help      How to use this application
```
