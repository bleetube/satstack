// https://docs.dnscontrol.org/
var REG_NAMECHEAP = NewRegistrar('namecheap');
var DSP_NAMECHEAP = NewDnsProvider("namecheap");

D('satstack.net', REG_NAMECHEAP, DnsProvider(DSP_NAMECHEAP),
    A('squirtle', '192.168.0.42'),
    A('wartortle', '192.168.0.43'),
    A('chesnaught', '192.168.0.44'),
    A('omastar', '192.168.0.46'),
    A('charmander', '192.168.1.39'),
    A('chespin', '192.168.1.219'),
    TXT('_dmarc', 'v=DMARC1; p=none'),
    TXT('@', 'v=spf1 mx ~all')
);

/*
D('satstack.cloud', REG_NAMECHEAP, DnsProvider(DSP_NAMECHEAP),
    A('sableye', '47.87.130.89'),
    A('rhyperior', '107.173.15.183'),
    A('mail', '47.87.130.89'),
    TXT('@', 'v=spf1 mx ~all'),
    TXT('mail._domainkey', 'v=DKIM1; h=sha256; k=rsa; s=email; p=MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAyCNccp7qz7bgdM4AH3aorev9SZ0UgvDrxR+xNHMcpVYSO4HnVLT9kk+VGAgbrcB/CahQ8012q97K2ElwG4TKrZqTyVkYaFhmOPk+92DsjT5QnaTJ3GNUHHO7ZCREQ8wrFenrgvEa0zSTH+1d6V2skZ4btI+qAsuO9Bf3qK+/9qgQVvQWhZKY95yiLjx0jSVE4ME/XXDqravNsIsJnAaLHXrPyZeb/SePw6+Jg93DMOEmeDuT3JKf2wumN5IyP0rgbrfa3CVe3FesFCTnnDPSwve6dO+ink6/dDh+KijuShAqgDLDHgRt0ANs6PILufbEnK42KEEr1N5RAXTjMno3hQIDAQAB'),
    TXT('_dmarc', 'v=DMARC1; p=reject; rua=mailto:dmarc@satstack.cloud; fo=1'),
    MX('@', 10, 'mail.satstack.cloud.')
);
*/
