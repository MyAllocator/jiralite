#!/usr/bin/perl -w

#
# Assign
#
# Assign a JIRA issue to a user.
#
# Author: Nathan Helenihi
#

package JiraLite::Command::Assign;
use strict;
use warnings;
use base qw( CLI::Framework::Command );
use JiraLite::Config::Jira;
use JiraLite::Lib::Credentials;
use JIRA::Client::Automated;
use Data::Dumper;

sub run {
    # Validate and configure arguments
    my $num_args = $#ARGV + 1;
    if ($num_args != 2) {
        print usage_text();
        exit;
    }
    my $issue_id = $ARGV[0];
    my $assignee = $ARGV[1];

    # Jira uses undef for Unassigned state
    if ($assignee eq 'none') {
        $assignee = undef;
    }

    # Instantiate JIRA client with credentials
    my $creds = new JiraLite::Lib::Credentials();
    my ($user, $password) = $creds->getCredentials();
    my $jira = JIRA::Client::Automated->new($JiraLite::Config::Jira::URL, $user, $password);

    # Assign issue
    my $result;
    eval {
        $result = $jira->assign_issue($issue_id, $assignee);
    }; warn $@ if $@;

    print "\n";
    if ($result) {
        print "Successfully assigned issue.";
    } else {
        print "Failed to assign issue.";
    }
    print "\n\n";
}

sub usage_text { qq{
    Usage:
        $0 <a|assign> <TID> <none|brianh|mo|lukasz|nate>
        $0 assign $JiraLite::Config::Jira::PROJECT-000 nate

} }

1;
