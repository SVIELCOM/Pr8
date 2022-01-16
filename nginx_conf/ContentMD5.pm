# nginx Embedded Perl module for adding a Content-MD5 HTTP header
#
# THIS VERSION GENERATES A HEX ENCODED VALUE BUT RFC1864 REQUIRES BASE64
#
# This perl module, will output an MD5 of a requested file using the
# Content-MD5 HTTP header, calculating the MD5 hex hash on the fly.
#
# Author: Matt Martz <matt@sivel.net>
# Link to the original version: https://gist.github.com/sivel/1870822
# This version, with modifications:
# https://gist.github.com/kwmiebach/2f03baaae7e4f86f9573f1f30818d36f
# License: http://www.nginx.org/LICENSE

package ContentMD5;
use nginx;
use Digest::MD5;

sub handler {
	my $r = shift;
	my $filename = $r->filename;

	return DECLINED unless -f $filename;

	my $content_length = -s $filename;
	my $md5;

	open( FILE, $filename ) or return DECLINED;
	my $ctx = Digest::MD5->new;
	$ctx->addfile( *FILE );
	$md5 = $ctx->hexdigest;
	close( FILE );

	$r->header_out( "Content-MD5-Hex", $md5 ) unless ! $md5;

	return DECLINED;
}

1;
__END__