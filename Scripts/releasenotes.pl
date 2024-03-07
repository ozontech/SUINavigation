#!/usr/bin/perl

open my $fh, '<', 'CHANGELOG.md' or die "Can't open file $!";
my $CHANGELOG = do { local $/; <$fh> };

if ($CHANGELOG =~ m/## *\[([.0-9]*)\]/) {
	$CURRENT_VERSION="$1"
}

if ($CHANGELOG =~ m/## *\[$CURRENT_VERSION\].*\s+((.|\s)*?)\s+## *\[[.0-9]*\]/) { 
	print "$1"
}