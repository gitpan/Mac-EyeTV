package Mac::EyeTV::Programme;
use strict;
use warnings;
use DateTime;
use DateTime::Format::Strptime;
use base qw(Class::Accessor::Fast);

__PACKAGE__->mk_accessors(qw(programme start stop title
description channel_number station_name input_source repeats quality
enabled));

sub duration {
  my $self = shift;
  return $self->stop - $self->start;
}

sub record {
  my $self = shift;

  my $start = $self->start;
  my $stop = $self->stop;
  my $title = $self->title;
  my $description = $self->description || "";
  my $channel_number = $self->channel_number;
  my $duration = ($stop->epoch - $start->epoch);

  my $eyetv = Mac::Glue->new('EyeTV');
  $eyetv->make(
    new => 'program',
    with_properties => {
      'start time' => $start->epoch,
      duration => $duration,
      title => $title,
      description => $description,
      'channel number' => $channel_number,
    },
  );
}

1;

__END__

=head1 NAME

Mac::EyeTV::Programme - An EyeTV programme

=head1 SYNOPSIS

  use Mac::EyeTV;
  my $eyetv = Mac::EyeTV->new();

  # Examine existing programmes
  foreach my $programme ($eyetv->programs) {
    my $start       = $programme->start;
    my $stop        = $programme->stop;
    my $title       = $programme->title;
    my $description = $programme->description;

    print "$title $start - $stop ($description)\n";
  }

  # Record a new program
  my $programme = Mac::EyeTV::Programme->new;
  $programme->start($start_dt);
  $programme->stop($stop_dt);
  $programme->title($title);
  $programme->description($description);
  $programme->channel_number($channel_number);
  $programme->record;

=head1 DESCRIPTION

This module represents an EyeTV program. The programs() method in
Mac::EyeTV returns a list of Mac::EyeTV::Programme objects which
represent the existing and future programs.

=head1 METHODS

=head2 new

This is the constructor, which takes no arguments:

  my $eyetv = Mac::EyeTV->new();

=head2 description

The description() method returns the description of the program:

  my $description = $programme->description;

=head2 duration

The duration() method returns the duration of the program (as a
DateTime::Duration object):

  my $duration = $programme->duration;

=head2 record

The record method schedules a new recording:

  # Record a new program
  my $programme = Mac::EyeTV::Programme->new;
  $programme->start($start_dt);
  $programme->stop($stop_dt);
  $programme->title($title);
  $programme->description($description);
  $programme->channel_number($channel_number);
  $programme->record;

=head2 start

The start method returns when the program starts (as a DateTime
object):

  my $start = $programme->start;

=head2 stop

The stop method returns when the program stops (as a DateTime
object):

  my $stop = $programme->stop;

=head2 title

The title() method returns the title of the program:

  my $title = $programme->title;

=head1 AUTHOR

Leon Brocard <acme@astray.com>.

=head1 COPYRIGHT

Copyright (C) 2004, Leon Brocard

This module is free software; you can redistribute it or modify it
under the same terms as Perl itself.
