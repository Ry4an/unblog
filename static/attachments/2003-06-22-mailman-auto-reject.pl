#!/usr/bin/perl -w

# This little script takes on input an automated email from mailman alerting
# you of a non-subscribers attempt to post to a subscriber-only-posting email
# list.  It then contacts the mailman instance and automatically handles any
# messages pending approval due to reasons of non-subscriber authorship.  It
# has been tested against mailman versions 2.0.10, 2.0.2, and 2.0.9-sf.net.
#
# I invoke this script from procmail using the following recipe:
#
# :0w
# * ^Subject.* post from .* requires approval
# | /home/ry4an/bin/mailman-auto-reject.pl
#
# Which deletes the pending post requiring approval message if it can handle
# the message, but passes it through to my inbox if any error occurs.
#
# This script was written by Ry4an Brase, http://ry4an.org, and is placed in
# the public domain.
#
# Below is a brief configuration area.  The options have comments explaining
# their usage.

# Here you need to put the admin passwords for all the lists you want this
# script to be able to handle.  I know it sucks having these in plaintext,
# but I'm just too lazy to care.
my %passwords = ('listOne' => 'paswordOne', 'anotherList' => 'anotherPass');

# Set this to whatever you want the list to to each message from a
# non-subscribed poster.  Legal values: 'discard', 'reject', or 'approve'
my $autoAction = 'reject';

my $debug = 0;  # set to zero to silence, one for status messages

################################################################
# end configuration area
################################################################

use strict;
use HTTP::Request::Common qw(POST);
use HTTP::Cookies;
use HTML::Form;
use LWP::UserAgent;

my %actionCodes = ('discard' => 3, 'approve' => 1, 'reject' => 2, 'defer' => 0);
die "Unrecognized autoAction '$autoAction'\n" unless (grep /^$autoAction$/,
    keys %actionCodes);

# get list name
my ($url, $listName, $reason);
while (<>) {
    if (/^\s*Reason:\s+(.*?)\s*$/) {
        $reason = $1;
        print "Reason: '$reason'\n";
        next;
    }
    if (/^\s*(http[s]?:\/\/\S+\/admindb(?:\.cgi)?\/(\S+?))\s*$/) {
        $url = $1;
        $listName = $2;
        $url =~ s/^https/http/; # Most LWPs don't have SSL setup
        print "URL: '$url'\n" if $debug;
        print "Listname: '$listName'\n" if $debug;
        unless (defined $passwords{$listName}) {
            die "No password known for list '$listName'\n";
        }
        next;
    }
}
die "No reason found.\n" unless (defined $reason);
die "No url found.\n" unless (defined $url);
die "No list name found.\n" unless (defined $listName);

my $ua = LWP::UserAgent->new;
$ua->agent("mailman-auto-reject ");
my $cookie_jar = HTTP::Cookies->new;

my $req = POST $url,
    [ request_login => 'Let me in...', adminpw => $passwords{$listName}];

my $res = $ua->request($req);

# check for error
die "Error authenticating\n" unless $res->is_success();

$cookie_jar->extract_cookies($res);

my @forms = HTML::Form->parse($res->as_string, $res->base());
die "No pending requests found\n" unless (@forms);
my $form = shift @forms;

my @inputs = $form->inputs;

my $handled = 0;
foreach my $input (@inputs) {
    unless ($input->type eq 'radio') {
        print "Skipping input ", $input->name, " due to type: ", $input->type,
            "\n" if $debug;
        next;
    }
    unless ($input->possible_values == 4) { # try to find only pending messages
        print "Skipping input ", $input->name, " due to value count:",
            scalar($input->possible_values), "\n" if $debug;
        next;
    }
    my $reasonInput = $form->find_input('comment-' . $input->name, 'textarea');
    unless (defined $reasonInput && ($reasonInput->value
            eq 'Non-members are not allowed to post messages to this list.')) {
        print "Skipping input ", $input->name,
            " because reason wasn't non-subscriber posting.\n" if $debug;
        next;
    }
    print "Setting ", $input->name, " to $autoAction\n" if $debug;
    $handled++;
    $input->value($actionCodes{$autoAction});
}

if ($handled == 0) {
    die "No pending messages from non-subscribers found.\n";
}

$req = $form->click();
$cookie_jar->add_cookie_header($req); # add auth info
$res = $ua->request($req);

# check for error
die "Error handling requests\n" unless $res->is_success();

# print $res->as_string;
print $handled, " messages handled (action = $autoAction)\n" if $debug;
