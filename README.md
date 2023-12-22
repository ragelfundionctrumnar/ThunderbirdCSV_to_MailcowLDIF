# ThunderbirdCSV_to_MailcowLDIF
Need to export Zimbra contacts to Mailcow?  This does the basics...

# Limitations
It only maps the following fields (the only ones I needed... feel free to add more, I guess)

```
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
```

# Install
You need a couple of CPAN modules.  Maybe do something like this:

```
sudo cpan Text::CSV Net::LDAP::LDIF
```
