use strict;
use warnings;
use Text::CSV;
use Net::LDAP::LDIF;
use Net::LDAP::Entry;


# Input and output file paths
my $csv_file = 'zimbra-export-as-thunderbird.csv';
my $ldif_file = 'mailcowimport.ldif';

my %mapping = ( 'First Name'     => 'givenName',
                'Last Name'      => 'sn',
                'Display Name'   => 'displayName',
                'Mobile Number'  => 'mobile',
                'Home Address'   => 'street',
                'Home City'      => 'l',
                'Home State'     => 'st',
                'Home Country'   => 'c',
                'Home Phone'     => 'homePhone',
                'Home ZipCode'   => 'postalCode',
                'Primary Email'  => 'mail',
                'Secondary Email'   => 'mozillasecondemail',
                'Notes'       => 'description',
                'Organization'   => 'o',
            );

# Create CSV parser and LDIF writer
my $csv = Text::CSV->new({ binary => 1, auto_diag => 1, eol => $/ });
my $ldif = Net::LDAP::LDIF->new($ldif_file, "w");

# Open CSV file for reading
open my $fh, '<', $csv_file or die "Could not open CSV file: $!";

# Read CSV header
my $header = $csv->getline($fh);

# Process each CSV row and convert to LDIF
while (my $row = $csv->getline($fh)) {
  my $entry = Net::LDAP::Entry->new;
  # TBH, not sure if we need this.  It's in an export from mailcow, so...
  $entry->add(objectClass => ['top', 'inetOrgPerson', 'mozillaAbPersonAlpha']);


  # Create LDIF entry from CSV data
  for my $i (0 .. $#{$header}) {
   my $field_name = $header->[$i];
   my $field_value = $row->[$i];

   # Skip empty fields
   next unless defined $field_value && $field_value ne '';

   # Map Thunderbird header to LDIF field using the mapping hash
   my $ldif_field = $mapping{$field_name} || $field_name;

   # Add to LDIF entry
   $entry->add($ldif_field => $field_value);
  }

  # Write LDIF entry
  $ldif->write_entry($entry);
}

# Close files
close $fh;
$ldif->done();

print "Conversion completed. LDIF file: $ldif_file\n";
