#!/usr/bin/perl -w

#
# Status
#
# Transition a JIRA issue to a new status. The source status to
# destination status transition must be valid as defined in JIRA.
#
# Author: Nathan Helenihi
#

package JiraLite::Command::Status;
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
    my $status = $ARGV[1];

    # Instantiate JIRA client with credentials
    my $creds = new JiraLite::Lib::Credentials();
    my ($user, $password) = $creds->getCredentials();
    my $jira = JIRA::Client::Automated->new($JiraLite::Config::Jira::URL, $user, $password);

    # Transition issue
    my $result;
    eval {
        $result = $jira->transition_issue($issue_id, $status);
    }; warn $@ if $@;

    print "\n";
    if ($result) {
        print "Successfully transitioned issue to '$status'.";
    } else {
        print "Failed to transition issue to '$status'.";
    }
    print "\n\n";
}

sub usage_text { qq{
    Usage:
        $0 <s|status> <TID> <"To Do"|Design|Development|Review|Stage|Done>
        $0 status $JiraLite::Config::Jira::PROJECT-000 Review

} }

1;
