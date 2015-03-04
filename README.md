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

## Dependencies

The following perl packages are required:

JIRA::Client::Automated (https://metacpan.org/pod/JIRA::Client::Automated)
CLI::Framework (https://metacpan.org/pod/CLI::Framework)
Term::Prompt (https://metacpan.org/pod/Term::Prompt)

```
cpanm JIRA::Client::Automated
cpanm CLI::Framework
cpanm Term::Prompt
```

## Configuration

Jira credentials are read from ~/.jira_credentials (username:password).

```
echo "your_username:your_password" > ~/.jira_credentials
chmod 600 ~/.jira_credentials
```

Modify url, project, sprint, etc in JiraLite/Config/Jira.pm to fit your environment.

##
