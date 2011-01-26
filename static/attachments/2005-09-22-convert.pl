#!/usr/bin/perl -w
use Date::Parse;
use Date::Format;

my @points;

while ($_ = <>) {
    @points = split /,/;
    my $lat = $points[1] / 60 + $points[0];
    my $lon = $points[3] / -60 + $points[2];
    my $when = time2str("%Y-%m-%dT%H:%M:%S", str2time($points[5] . " " . $points[6]));
    print "<trkpt lat=\"$lat\" lon=\"$lon\" time=\"$when\"/>\n";
}
