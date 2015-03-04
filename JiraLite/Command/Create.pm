#!/usr/bin/perl -w

#
# Create
#
# Create a new JIRA issue (interactive).
#
# Author: Nathan Helenihi
#

package JiraLite::Command::Create;
use strict;
use warnings;
use base qw( CLI::Framework::Command );
use JiraLite::Lib::Credentials;
use JiraLite::Config::Jira;
use JIRA::Client::Automated;
use Data::Dumper;
use Term::Prompt;
use JSON;

sub run {
    print "\n";
    print "Provide information for new JIRA issue below.\n\n";

    # User input (Let JIRA api perform validation)
    my %issue;
    $issue{"project"}{key} = $JiraLite::Config::Jira::PROJECT;
    $issue{summary} = prompt('x', 'Title:', '', '');
    $issue{description} = prompt('x', 'Description:', '', '');
    $issue{"issuetype"}{name} = prompt('x', 'Type:', '(Bug, Improvement, New Feature, Hot Potato, Task)', 'Hot Potato');
    $issue{"priority"}{name} = prompt('x', 'Priority:', '(Blocker, Critical, Major, Minor, Trivial)', 'Blocker');
    $issue{"assignee"}{name} = prompt('x', 'Assign To:', '(brianh, lukasz, nate, mo)', 'Unassigned');

    # JIRA treats assignee Unassigned = undef
    if ($issue{"assignee"}{name} eq 'Unassigned') {
        $issue{"assignee"}{name} = undef;
    }

    # The sprint name and id will need to be updated every new cycle.
    my $sprint = prompt('y', 'Assign to Current Sprint:', $JiraLite::Config::Jira::CURRENT_SPRINT, 'y');
    if ($sprint) {
        $issue{customfield_10105} = $JiraLite::Config::Jira::CURRENT_SPRINT_ID;
    }

    # Instantiate JIRA client with credentials
    my $creds = new JiraLite::Lib::Credentials();
    my ($user, $password) = $creds->getCredentials();
    my $jira = JIRA::Client::Automated->new($JiraLite::Config::Jira::URL, $user, $password);

    # Create issue
    my $result;
    eval {
        $result = $jira->create(\%issue);
    }; warn $@ if $@;

    print "\n";
    if ($result) {
        print "Successfully created ticket:\n\n";
        print "Ticket : $result->{key} \n";
        print "Url    : ${JiraLite::Config::Jira::URL}browse/$result->{key} \n";
        print "\n";
    } else {
        print "Failed to create ticket.\n\n";
    }
}

sub usage_text { qq{
    Usage: 
        $0 <c|create>

} }

1;
