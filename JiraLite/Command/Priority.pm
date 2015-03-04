#!/usr/bin/perl -w

#
# Priority
#
# Update the priority for a JIRA issue.
#
# Author: Nathan Helenihi
#

package JiraLite::Command::Priority;
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
    my $priority = $ARGV[1];

    # Instantiate JIRA client with credentials
    my $creds = new JiraLite::Lib::Credentials();
    my ($user, $password) = $creds->getCredentials();
    my $jira = JIRA::Client::Automated->new($JiraLite::Config::Jira::URL, $user, $password);

    # Update issue
    my $result;
    eval {
        my %data = (priority => {name => $priority});
        $result = $jira->update_issue($issue_id, \%data);
    }; warn $@ if $@;

    print "\n";
    if ($result) {
        print "Successfully updated issue to priority '$priority'.";
    } else {
        print "Failed to update issue to priority '$priority'.";
    }
    print "\n\n";
}

sub usage_text { qq{
    Usage:
        $0 <p|priority> <TID> <Blocker|Critical|Major|Minor|Trivial>
        $0 priority $JiraLite::Config::Jira::PROJECT-000 Blocker

} }

1;
