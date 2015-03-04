#!/usr/bin/perl -w

#
# Delete
#
# Delete a JIRA issue.
#
# Author: Nathan Helenihi
#

package JiraLite::Command::Delete;
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
    if ($num_args != 1) {
        print usage_text();
        exit;
    }
    my $issue_id = $ARGV[0];

    # Instantiate JIRA client with credentials
    my $creds = new JiraLite::Lib::Credentials();
    my ($user, $password) = $creds->getCredentials();
    my $jira = JIRA::Client::Automated->new($JiraLite::Config::Jira::URL, $user, $password);

    # Create issue
    my $result;
    eval {
        $result = $jira->delete_issue($issue_id);
    }; warn $@ if $@;

    print "\n";
    if ($result) {
        print "Successfully deleted ticket.";
    } else {
        print "Failed to delete ticket.";
    }
    print "\n\n";
}

sub usage_text { qq{
    Usage:
        $0 <d|delete> <TID>
        $0 delete $JiraLite::Config::Jira::PROJECT-000

} }

1;
