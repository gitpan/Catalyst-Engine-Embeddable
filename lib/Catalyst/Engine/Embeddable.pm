{   package Catalyst::Engine::Embeddable;

    our $VERSION = '0.0.1';
    use base qw(Catalyst::Engine);
    use strict;
    use warnings;
    use URI;
    use HTTP::Body;
    use HTTP::Response;

    sub prepare_request {
        my ($self, $c, $req, $res_ref) = @_;
        $c->req->{_engine_embeddable}{req} = $req;
        $c->req->{_engine_embeddable}{res} = $res_ref;
        $c->req->method($req->method);
    }

    sub prepare_headers {
        my ($self, $c) = @_;
        $c->req->{_engine_embeddable}{req}->scan
          (sub {
               my ($name, $value) = @_;
               $c->req->header($name, $value);
           });
    }

    sub prepare_path {
        my ($self, $c) = @_;

        my $uri = $c->req->{_engine_embeddable}{req}->uri();
        my $base = $uri->clone; $base->path('/');

        $c->req->uri($uri);
        $c->req->base($base);
    }

    sub prepare_query_parameters {
        my ($self, $c) = @_;
        my %params = $c->req->{_engine_embeddable}{req}->uri->query_form;
        $c->req->query_parameters(\%params);
    }

    sub prepare_body {
        my ($self, $c) = @_;
        my $req = $c->req->{_engine_embeddable}{req};
        $req->content_length(0) unless $req->content_length;

        $c->req->content_encoding($req->content_encoding);
        $c->req->content_type($req->content_type);
        $c->req->content_length($req->content_length);

        my $http_body = HTTP::Body->new($c->req->content_type, $c->req->content_length);
        $http_body->add($req->content());
        $c->req->{_body} = $http_body;
    }

    sub finalize_headers {
        my ($self, $c) = @_;

        my $response = HTTP::Response->new($c->res->status,
                                           'Catalyst-Engine-Embeddable',
                                           $c->res->headers);

        ${$c->req->{_engine_embeddable}{res}} = $response;
    }

    sub finalize_body {
        my ($self, $c) = @_;
        ${$c->req->{_engine_embeddable}{res}}->content($c->res->body());
    }

};
1;

__END__

=head1 NAME

Catalyst::Engine::Embeddable - Use a Catalyst application as an object

=head1 SYNOPSIS

  # after creating the application using this engine, you can just
  my $http_response;
  my $response_code $app->handle_request(
           $http_request, \$http_response);

=head1 ABSTRACT

Enables a Catalyst application to be used as a standard Perl object.

=head1 SUMMARY

This module provides a way to embed a Catalyst application in any
other program using standard Perl Object Orientation to do a request
and get the response.

It works by using the arguments that are passed from the
handle_request method in the Catalyst module to the prepare_request
method in the engine, which will then handle the request as coming
from the HTTP::Request object passed, instead of trying to fetch the
elements from the ENV, like the CGI engine does.

As the handle_request method only returns the response code and not
the response object at all, in the case you want the complete response
you need to pass a second argument which is a scalar ref where the
HTTP::Response object will be stored in the "finalize" phase of the
processing.

This engine provides complete compatibility with any plugin the
application may use, in a way that different embedded applications may
use different plugins and still be used side-by-side.

There's one important consideration regarding the URI in the
request. For the means of the Catalyst processing, the base path for
the script is always constructed as the "/" path of the same URI as
the request.

=head1 METHODS

The following methods were overriden from Catalyst::Engine.

=over

=item $engine->prepare_request($c, $http_request, $http_response_ret_ref)

This method is overrided in order to store the request and the
response in $c as to continue the processing later. The scalar ref
here will be used to set the response object, as there is no other way
to obtain the response.

This information will be stored as $c->req->{_engine_embeddable}{req} and
$c->req->{_engine_embeddable}{res} for future usage.

=item $engine->prepare_headers($c)

This is where the headers are fetched from the HTTP::Request object
and set into $c->req.

=item $engine->prepare_path($c)

Get the path info from the HTTP::Request object.

=item $engine->prepare_query_parameters($c)

Set the query params from the HTTP::Request to the catalyst request.

=item $engine->prepare_body($c)

Gets the body of the HTTP::Request, creates an HTTP::Body object, and
set it in $c->req->{_body}, then being compatible with
Catalyst::Engine from now on.

=item $engine->finalize_headers($c)

Set the "Status" header in the response and store the headers from the
catalyst response object to the HTTP::Response object.

=item $engine->finalize_body($c)

Copies the body from the catalyst response to the HTTP::Response
object.

=back

=head1 SEE ALSO

L<Catalyst::Engine>, L<Catalyst::Engine::CGI>, L<HTTP::Request>,
L<HTTP::Reponse>, L<Catalyst>

=head1 AUTHORS

Daniel Ruoso C<daniel.ruoso@verticalone.pt>

=head1 BUG REPORTS

Please submit all bugs regarding C<Catalyst::Engine::Embeddable> to
C<bug-catalyst-engine-embeddable@rt.cpan.org>

=head1 LICENSE

This library is free software, you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

