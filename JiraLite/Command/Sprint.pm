#!/usr/bin/perl -w

#
# Sprint
#
# Assign a JIRA issue to a sprint. Note, trying to remove an issue from
# a sprint is making their API 500 :P. Come back to it later.
#
# Author: Nathan Helenihi
#

package JiraLite::Command::Sprint;
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
    my $sprint_id = $ARGV[1];

    # Jira uses undef for no sprint
    if ($sprint_id eq 0 || $sprint_id eq 'none') {
        $sprint_id = undef;
    }

    # Instantiate JIRA client with credentials
    my $creds = new JiraLite::Lib::Credentials();
    my ($user, $password) = $creds->getCredentials();
    my $jira = JIRA::Client::Automated->new($JiraLite::Config::Jira::URL, $user, $password);

    # Update issue
    my $result;
    eval {
        my %data = (customfield_10105 => $sprint_id);
        $result = $jira->update_issue($issue_id, \%data);
    }; warn $@ if $@;

    print "\n";
    if ($result) {
        print "Successfully updated issue sprint.";
    } else {
        print "Failed to update issue sprint.";
    }
    print "\n\n";
}

sub usage_text { qq{
    Usage:
        $0 <spr|sprint> <TID> <SID>
        $0 sprint $JiraLite::Config::Jira::PROJECT-000 23

} }

1;
