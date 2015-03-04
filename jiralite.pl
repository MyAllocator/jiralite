#!/usr/bin/perl -w

#
# JiraLite
#
# This is the primary JiraLite executable script. It routes incoming
# commands to their individual command scripts.
#
# Do something like: ln -s ~/Downloads/jiralite/jiralite.pl /usr/bin/jl
#
# Author: Nathan Helenihi
#

use strict;
use warnings;

# ---- EXECUTION ----
# Here, we set the default command to the only command in our simple
# application.  If this is not done, 'help' will be the default.
my $app = JiraLite->new();
$app->set_default_command('help');
$app->run();

###################################

# ---- APPLICATION ----
package JiraLite;
use base qw( CLI::Framework );
use JiraLite::Command::View;
use JiraLite::Command::Create;
use JiraLite::Config::Jira;

sub command_map {
    (
        help => 'CLI::Framework::Command::Help',
        view => 'JiraLite::Command::View',
        create => 'JiraLite::Command::Create',
        delete => 'JiraLite::Command::Delete',
        comment => 'JiraLite::Command::Comment',
        assign => 'JiraLite::Command::Assign',
        status => 'JiraLite::Command::Status',
        rush => 'JiraLite::Command::Rush',
        type => 'JiraLite::Command::Type',
        priority => 'JiraLite::Command::Priority',
        sprint => 'JiraLite::Command::Sprint',
    )
}

sub command_alias {
    'h' => 'help',
    'v' => 'view',
    'c' => 'create',
    'd' => 'delete',
    'a' => 'assign',
    'com' => 'comment',
    'spr' => 'sprint',
    's' => 'status',
    'r' => 'rush',
    't' => 'type',
    'p' => 'priority',
}

sub usage_text { qq{
    Usage: $0 <verb> <args> ...

      # Help (this)
      <h|help>

      # View issue information
      <v|view> <TID>
      view $JiraLite::Config::Jira::PROJECT-000

      # Create new issue (interactive)
      <c|create>

      # Delete an issue
      <d|delete> <TID>
      delete $JiraLite::Config::Jira::PROJECT-000

      # Create a comment on an issue
      <com|comment> <TID> <comment>
      comment $JiraLite::Config::Jira::PROJECT-000 "This is a comment"

      # Assign issue to a user
      <a|assign> <TID> <none|brianh|mo|lukasz|nate>
      assign $JiraLite::Config::Jira::PROJECT-000 nate

      # Transition an issue to a new status
      <s|status> <TID> <"To Do"|Design|Development|Review|Stage|Done>
      status $JiraLite::Config::Jira::PROJECT-000 Review

      # Rush issue to Done status
      <r|rush> <TID>
      rush $JiraLite::Config::Jira::PROJECT-000

      # Update an issue type
      <t|type> <TID> <Improvement|"New Feature"|"Hot Potato"|Task>
      type $JiraLite::Config::Jira::PROJECT-000 "Hot Potato"

      # Update an issue priority
      <p|priority> <TID> <Blocker|Critical|Major|Minor|Trivial>
      priority $JiraLite::Config::Jira::PROJECT-000 Blocker

      # Update an issue sprint (View an issue in sprint and look for [#] by sprint. Ex: Sprint 201502-A [23> has id 23.)
      <spr|sprint> <TID> <SID|none>
      sprint $JiraLite::Config::Jira::PROJECT-000 23

    Options:
      -h, --help      How to use this application

} }

sub option_spec {
    ['help|h'    => 'show help']
}
