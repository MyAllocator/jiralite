#!/usr/bin/perl -w

#
# Comment
#
# Create a new comment on a JIRA issue.
#
# Author: Nathan Helenihi
#

package JiraLite::Command::Comment;
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
    my $comment = $ARGV[1];

    # Instantiate JIRA client with credentials
    my $creds = new JiraLite::Lib::Credentials();
    my ($user, $password) = $creds->getCredentials();
    my $jira = JIRA::Client::Automated->new($JiraLite::Config::Jira::URL, $user, $password);

    # Create comment
    my $result;
    eval {
        $result = $jira->create_comment($issue_id, $comment);
    }; warn $@ if $@;

    print "\n";
    if ($result) {
        print "Successfully created comment.";
    } else {
        print "Failed to create comment.";
    }
    print "\n\n";
}

sub usage_text { qq{
    Usage:
      $0 <com|comment> <TID> <comment>
      $0 comment $JiraLite::Config::Jira::PROJECT-000 "This is a comment"

} }

1;
