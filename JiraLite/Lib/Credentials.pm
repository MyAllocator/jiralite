#!/usr/bin/perl -w

#
# Credentials
#
# Library for reading Jira credentials from home directory.
#
# Author: Nathan Helenihi
#

package JiraLite::Lib::Credentials;
use strict;
use warnings;

sub new {
    my $class = shift;

    # Get credentials from ~/.jira_credentials (should be 600)
    my $file = $ENV{HOME} . '/.jira_credentials';
    open my $fh, "<", $file or die qq(
Could not open JIRA credentials file '$file'.
$!

Make sure you have your credentials file configured:
echo "username:password" > ~/.jira_credentials
chmod 600 ~/.jira_credentials

);
    my $line = <$fh>;
    chomp($line);
    my ($user, $pass) = split /:/, $line;

    my $self = {
        _username => $user,
        _password => $pass
    };

    bless $self, $class;
    return $self;
}

sub getCredentials {
    my($self) = @_;
    return ($self->{_username}, $self->{_password});
}

1;
