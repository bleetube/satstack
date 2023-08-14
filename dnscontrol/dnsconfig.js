// https://docs.dnscontrol.org/
var REG_NAMECHEAP = NewRegistrar('namecheap');
var DSP_NAMECHEAP = NewDnsProvider("namecheap");

// Default TTL is 5m
var modestTTL = TTL('1h');

D('satstack.net', REG_NAMECHEAP, DnsProvider(DSP_NAMECHEAP),
    A('squirtle', '192.168.0.42'),
    A('wartortle', '192.168.0.43'),
    A('chesnaught', '192.168.0.44'),
    A('omastar', '192.168.0.46'),
    A('charmander', '192.168.1.39'),
    A('chespin', '192.168.1.219'),
    TXT('_dmarc', 'v=DMARC1; p=none'),
    TXT('@', 'v=spf1 -all')
);

D('satstack.cloud', REG_NAMECHEAP, DnsProvider(DSP_NAMECHEAP),
    A('@', '47.87.130.89'), // sableye
    A('mail', '47.87.130.89'), // sableye
    A('sableye', '47.87.130.89'),
    A('rhyperior', '107.173.15.183'),
    A('farfetchd', '47.87.132.53'),
    MX('@', 10, 'mail.satstack.cloud.'),
    TXT('@', 'v=spf1 mx ~all'),
    TXT('mail._domainkey', 'v=DKIM1; h=sha256; k=rsa; s=email; p=MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAyCNccp7qz7bgdM4AH3aorev9SZ0UgvDrxR+xNHMcpVYSO4HnVLT9kk+VGAgbrcB/CahQ8012q97K2ElwG4TKrZqTyVkYaFhmOPk+92DsjT5QnaTJ3GNUHHO7ZCREQ8wrFenrgvEa0zSTH+1d6V2skZ4btI+qAsuO9Bf3qK+/9qgQVvQWhZKY95yiLjx0jSVE4ME/XXDqravNsIsJnAaLHXrPyZeb/SePw6+Jg93DMOEmeDuT3JKf2wumN5IyP0rgbrfa3CVe3FesFCTnnDPSwve6dO+ink6/dDh+KijuShAqgDLDHgRt0ANs6PILufbEnK42KEEr1N5RAXTjMno3hQIDAQAB'),
    TXT('_dmarc', 'v=DMARC1; p=reject; rua=mailto:dmarc@satstack.cloud; fo=1')
);

D('offchain.pub', REG_NAMECHEAP, DnsProvider(DSP_NAMECHEAP),
    A('@', '173.82.197.238'),
    A('metagross', '173.82.197.238'),
    A('mail', '173.82.197.238'),
    CNAME('www', 'offchain.pub.'),
    CNAME('snort', 'offchain.pub.'),
    MX('@', 10, 'mail.offchain.pub.'),
    TXT('@', 'v=spf1 mx ~all'),
    TXT('_dmarc', 'v=DMARC1; p=reject; rua=mailto:dmarc@offchain.pub; fo=1')
);

D('blee.tube', REG_NAMECHEAP, DnsProvider(DSP_NAMECHEAP),
    A('@', '47.87.129.99', modestTTL),
    A('mail', '47.87.129.99', modestTTL),
    CNAME('www', 'blee.tube.', modestTTL),
    TXT('@', 'v=spf1 mx ~all', modestTTL),
    TXT('mail._domainkey', 'v=DKIM1; h=sha256; k=rsa; s=email; p=MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAuACTPeiidL/lBoGPj87k2eJO0aMjOWH/uM69u1jVECuub21Rc7AwedjWjcxF0LNes3Vn5ajw+C2xOeXPK2+bmMAPqxdb5Kc+   IiyDjZiowzNx0O8/UB/Sw6q9sL3/Ve5+PNPL07kX3DS5j+ijYj6E90Rsw8h8UlsOi90vDmcuYK3jyhLm8SYgUzlSv7uVO8HA3sx03NdtQ4dl4nbcZFfeDQlhUTn9lRvWx5EElx5ccaace7+Dt07uymUQKnbGIaogvkCPVEHiIHL8/sfiv7JaA/rMte3wCndqlyQG/           UjsRkVwiIUfmwaUzkVoglGJK5OOIeKOwDCQa7DmFdfbUSokDwIDAQAB', modestTTL),
    TXT('_dmarc', 'v=DMARC1; p=reject; rua=mailto:dmarc@blee.tube; fo=1', modestTTL),
    MX('@', 10, 'mail.blee.tube.', modestTTL)
);