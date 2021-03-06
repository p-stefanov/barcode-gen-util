#!/usr/bin/env perl
use strict;
use warnings;

use Dancer;
use Template;
use Barcode::Code128;
use GD;
use Imager::QRCode;
use URI::Escape qw/uri_escape/;
use Data::Dumper qw/Dumper/;

set 'port'          => 3001;
set 'template'      => 'template_toolkit';
set 'logger'        => 'console';
set 'log'           => 'debug';
set 'show_errors'   => 1;
set 'startup_info'  => 1;
set 'warnings'      => 1;
set 'server_tokens' => 0;

get '/' => sub {
	return template 'index.html';
};

post '/' => sub {
	my $type = param('type') || 'code128';
	my $codes = [];
	foreach (grep { $_ } split /[,\s]/, param('codes')) {
		my ($k, $v) = map { s/[^\\a-zA-Z0-9_\-;:]//gr } split '/', $_;
		#debug Dumper([$k, $v]);
		#my $show = $v ? "$k ($v)" : $k;
		my $show = ( $v || $k );#=~ s/\\(r|t|n)//gr;
		#my $show = $v || '';
		push @$codes, { key => $k, val => $show };
	}

	return template 'codes.html', { codes => $codes, type => $type };
};


my $bc = new Barcode::Code128;
$bc->option('border', 0);
$bc->option('show_text', 0);
#$bc->option('show_text', 1);
$bc->option('height', 50);
$bc->option('font_align', 'center');

my $qrcode = Imager::QRCode->new(
	#size          => 5,
	#margin        => 5,
	#version       => 1,
	#level         => 'M',
	casesensitive => 1,
	lightcolor    => Imager::Color->new(255, 255, 255),
	darkcolor     => Imager::Color->new(0, 0, 0),
);

get '/code128/:code' => sub {
	content_type 'image/png';
	# s/\\(r|t|n)/qq{"\\$1"}/geer
	my $code = ( param('code') =~ s/\\r/\r/gr ) =~ s/\\//gr;
	#debug $code;
	#debug $AnyEvent::MODEL; # debugging Twiggy
	return $bc->png($code);
};

get '/qr/:code' => sub {
	my $code = ( param('code') =~ s/\\r/\r/gr ) =~ s/\\//gr;
	my $buf;
	open my $fh, '>', \$buf or die $!;
	my $img = $qrcode->plot($code);
	content_type 'image/gif';
	$img->write(fh => $fh, type => 'gif') or die $img->errstr;
	return $buf;
};

dance;
