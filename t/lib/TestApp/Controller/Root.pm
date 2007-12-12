package TestApp::Controller::Root;

use strict;
use warnings;
use base 'Catalyst::Controller';
__PACKAGE__->config->{namespace} = '';

sub default : Private {
    my ( $self, $c ) = @_;
    $c->response->body( 'Hello' );
}

sub foo : Local {
    my ( $self, $c ) = @_;
    $c->res->body('Hello World!');
}

sub bar : Local {
    my ( $self, $c ) = @_;
    $c->res->body('Hello '.$c->req->param('who').'!');
}

1;
