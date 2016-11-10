#!/usr/bin/env perl
use strict;
use warnings;

use Dancer;
use Template;
use Barcode::Code128;
use GD;

set 'template'     => 'template_toolkit';
set 'logger'       => 'console';
set 'log'          => 'debug';
set 'show_errors'  => 1;
set 'startup_info' => 1;
set 'warnings'     => 1;

get '/' => sub {
	return template 'index.html';
};

post '/' => sub {
	my @codes = map { $_ =~ s/\D//gr } grep { $_ } split ',', param('codes');
	return template 'codes.html', { codes => \@codes };
};

my $bc = new Barcode::Code128;
$bc->option('border', 0);
$bc->option('height', 50);
$bc->option('font_align', 'center');

get '/code/:code' => sub {
	content_type 'image/png';
	return $bc->png(param('code'));
};
 
dance;
