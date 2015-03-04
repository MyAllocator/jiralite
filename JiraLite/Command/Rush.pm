#!/usr/bin/perl -w

#
# Rush
#
# Rush a JIRA issue to Done status.
#
# Author: Nathan Helenihi
#

package JiraLite::Command::Rush;
use strict;
use warnings;
use base qw( CLI::Framework::Command );
use JiraLite::Config::Jira;
use JiraLite::Lib::Credentials;
use JIRA::Client::Automated;
use Data::Dumper;

# Rush a ticket to Done status
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

    # Transition issue
    my $result;
    eval {
        $result = $jira->transition_issue($issue_id, 'Done');
    }; warn $@ if $@;

    print "\n";
    if ($result) {
        print "Successfully rushed issue to 'Done'.";
    } else {
        print "Failed to rush issue to 'Done'.";
    }
    print "\n\n";
}

sub usage_text { qq{
    Usage:
        $0 <r|rush> <TID>
        $0 rush $JiraLite::Config::Jira::PROJECT-000

} }

1;
