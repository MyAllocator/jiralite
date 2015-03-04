#!/usr/bin/perl -w

#
# Config
#
# Constants for use withing the app.
#
# Author: Nathan Helenihi
#

use strict;
use warnings;
package JiraLite::Config::Jira;

our $PROJECT = $ENV{'JIRALITE_PROJECT'} || 'XXX'; # Ex. MYAL for MYAL-123 tickets
our $URL = $ENV{'JIRALITE_URL'} || 'https://your_domain.atlassian.net/';

our $CURRENT_SPRINT = $ENV{'JIRALITE_SPRINT'} || 'XXX'; #ex. Sprint 2015March
our $CURRENT_SPRINT_ID = $ENV{'JIRALITE_SPRINT_ID'} || '##'; #ex. 23

1;
