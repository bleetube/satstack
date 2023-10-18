// https://docs.dnscontrol.org/
var REG_NAMECHEAP = NewRegistrar('namecheap');
var DSP_NAMECHEAP = NewDnsProvider("namecheap");

// Default TTL is 5m
var modestTTL = TTL('1h');

D('bitcoiner.social', REG_NAMECHEAP, DnsProvider(DSP_NAMECHEAP),
    A('@', '216.127.184.44'),
    A('nostr', '216.127.184.44'),
    A('rhyperior', '107.173.15.183'),
    A('metagross', '173.82.197.238'),
    A('garchomp', '216.127.184.44'),
    A('gabite', '205.234.146.111'),
    AAAA('gabite', '2402:d0c0:18:e258::1'),
    A('mail', '216.127.184.44'),
    CNAME('www', 'bitcoiner.social.'),
    CNAME('cast', 'garchomp.bitcoiner.social.'),
    CNAME('snort', 'garchomp.bitcoiner.social.'),
    CNAME('news', 'garchomp.bitcoiner.social.'),
//  CNAME('meetup', 'rhyperior.bitcoiner.social.'),
//  CNAME('ntfy', 'rhyperior.bitcoiner.social.'),
//  CNAME('matrix', 'rhyperior.bitcoiner.social.'),
    MX('@', 10, 'mail.bitcoiner.social.'),
    TXT('@', 'v=spf1 mx ~all'),
    TXT('mail._domainkey', 'v=DKIM1; h=sha256; k=rsa; s=email; p=MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAoYynQ/ytpvm/JpR5G2Dr4Z8pE25x42tzwHflXgIHBwWT25tQQER9C/IKRa78fNQ1kkkhyzM1kT18m62rYJH1l1OGfKmC8gmfw8feIFggo4h6F2pUw8/6+4v5ZCs+heT7HNHonnOpSjvAAHv27W1PjMn+aoY9c49qQuxkSo9xBW4MA4wODUkWA2S4gmfDZwKmxZcgQBqvo+vSiY0Pv4eRe9yNKH4ADY13dYR6dJVRmWjX7yvvkOdQ3t/jChjYiu6dYkz3B/hj2Z5M/A0DGcgXuIo5m5QzI539kp878um2bB1gHICGVSB2zn+LvCzBm/Xp/jqEs3O/08HQls2BSbGHgwIDAQAB'),
    TXT('_dmarc', 'v=DMARC1; p=reject; rua=mailto:dmarc@bitcoiner.social')
);

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
    A('@', '141.11.94.21'), // sableye
    A('mail', '141.11.94.21'), // sableye
    A('sableye', '141.11.94.21'),
    A('rhyperior', '107.173.15.183'),
    A('farfetchd', '141.11.95.49'),
    CNAME('matrix', 'sableye.satstack.cloud.'),
    CNAME('ntfy', 'sableye.satstack.cloud.'),
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
    CNAME('satellite', 'offchain.pub.'),
    MX('@', 10, 'mail.offchain.pub.'),
    TXT('@', 'v=spf1 mx ~all'),
    TXT('mail._domainkey', 'v=DKIM1; h=sha256; k=rsa; s=email; p=MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEA2yrYMCe9WzhHr+3D7Z6HK/6ODZ45nZrGKj25w+J6n83aaRrpTA2fZLc5FRR2P1kW20p+R/iNrY8KpxXYuxtHVFAvIcQ1ArTVUW9v68O6kh5nZ//f/z8QYgo5Za3YEyokfHpppUNNzwQFnn4+yMKqlbj/aF761aSxug4jpUKfsf8qX0hCUlmF4eob81aMtUDkPM/w0LhWpEnagZwQCqZh1yecYfpTrpdo8q1I3jvi6HIdnQWyvO2KQZjdQlg9JwjdPMZq7rPsCsBBZd2OZf56PktUW8NmVO0mnrAIFXR3t7Ry3TzJYB4arQ1WZi25qpE54/9HMryPE0H9oXQBPYhKhwIDAQAB'),
    TXT('_dmarc', 'v=DMARC1; p=reject; rua=mailto:dmarc@offchain.pub; fo=1')
);

D('blee.tube', REG_NAMECHEAP, DnsProvider(DSP_NAMECHEAP),
    A('@', '141.11.93.30', modestTTL),
    A('mail', '141.11.93.30', modestTTL),
    CNAME('www', 'blee.tube.', modestTTL),
    TXT('@', 'v=spf1 mx ~all', modestTTL),
    TXT('mail._domainkey', 'v=DKIM1; h=sha256; k=rsa; s=email; p=MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAuACTPeiidL/lBoGPj87k2eJO0aMjOWH/uM69u1jVECuub21Rc7AwedjWjcxF0LNes3Vn5ajw+C2xOeXPK2+bmMAPqxdb5Kc+IiyDjZiowzNx0O8/UB/Sw6q9sL3/Ve5+PNPL07kX3DS5j+ijYj6E90Rsw8h8UlsOi90vDmcuYK3jyhLm8SYgUzlSv7uVO8HA3sx03NdtQ4dl4nbcZFfeDQlhUTn9lRvWx5EElx5ccaace7+Dt07uymUQKnbGIaogvkCPVEHiIHL8/sfiv7JaA/rMte3wCndqlyQG/UjsRkVwiIUfmwaUzkVoglGJK5OOIeKOwDCQa7DmFdfbUSokDwIDAQAB', modestTTL),
    TXT('_dmarc', 'v=DMARC1; p=reject; rua=mailto:dmarc@blee.tube; fo=1', modestTTL),
    MX('@', 10, 'mail.blee.tube.', modestTTL)
);