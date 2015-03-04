#!/usr/bin/perl -w

#
# View
#
# View information for a JIRA issue.
#
# Author: Nathan Helenihi
#

package JiraLite::Command::View;
use strict;
use warnings;
use base qw( CLI::Framework::Command );
use JIRA::Client::Automated;
use Data::Dumper;
use JiraLite::Config::Jira;
use JiraLite::Lib::Credentials;

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

    # Get issue
    my $issue = $jira->get_issue($issue_id);
    #print Dumper(\$issue);

    # Parse sprint data
    my $sprint_name = 'None';
    my $sprint_id = 0;
    if (defined ($issue->{fields}->{customfield_10105}) && $issue->{fields}->{customfield_10105} ne '') {
        my $sprint_data = $issue->{fields}->{customfield_10105}[0];
        my @sprint_data_pairs = split /,/, $sprint_data;
        my @sprint_data_name = split /=/, $sprint_data_pairs[2];
        my @sprint_data_id = split /=/, $sprint_data_pairs[7];
        $sprint_name = $sprint_data_name[1];
        $sprint_id = $sprint_data_id[1];
        $sprint_id =~ s/]//g;
    }

    my $assignee = 'Unassigned';
    if (defined($issue->{fields}->{assignee})) {
        $assignee = $issue->{fields}->{assignee}->{displayName};
    }

    # Print issue data
    print "\n";
    print "Ticket   : $issue->{key} \n";
    print "Title    : $issue->{fields}->{summary} \n";
    print "Url      : ${JiraLite::Config::Jira::URL}browse/$issue->{key} \n";
    print "Sprint   : $sprint_name [$sprint_id] \n";
    print "Type     : $issue->{fields}->{issuetype}->{name} \n";
    print "Priority : $issue->{fields}->{priority}->{name} \n";
    print "Status   : $issue->{fields}->{status}->{name} \n";
    print "Creator  : $issue->{fields}->{creator}->{displayName} \n";
    print "Assignee : $assignee \n";
    print "Created  : $issue->{fields}->{created} \n";
    print "Updated  : $issue->{fields}->{updated} \n";
    if ($issue->{fields}->{comment}->{total} == 0) {
        print "Comments : None \n";
    } else {
        print "Comments : \n";
        for (my $i=0; $i < $issue->{fields}->{comment}->{total}; $i++) {
            my $c = $issue->{fields}->{comment}->{comments}[$i];
            print "  $c->{author}->{name} ($c->{updated}): $c->{body} \n"
        }
    }
    print "\n";
}

sub usage_text { qq{
    Usage:
        $0 <v|view> <TID>
        $0 view $JiraLite::Config::Jira::PROJECT-469

} }

1;
