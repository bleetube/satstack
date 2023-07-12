# Architectural Decision Record

Architectural Decision Records (ADRs): [docs](https://adr.github.io/), [repo](https://github.com/joelparkerhenderson/architecture-decision-record)

> Automate my own opinionated practices for orchestrating software, especially anything that I will continue to use for the forseeable future.

Why servers are named after Pokemon:

- [Names should be cute, not descriptive](https://news.ycombinator.com/item?id=34320517)
- Work servers also get cute names because the naming standard includes dashes (`-`) and that breaks the environment variable naming scheme which exports variables using hostnames.


I've spent a lot of time obsessing over details of how to run my self-hosted infrastructure. By publishing it as code, I'm opening myself to the possibility that there are other sysadmins out there who might share similar opinions. Those other sysadmins could express their own ideas, allowing me to adopt their ideas in return. Thus, the ultimate goal is to spend fewer mental cycles worrying over system administration details, which could free me up to do other things. Also, it's the one of the best things I can imagine working on.

## DNS

DNS provider is Namecheap because they provide the following reasons:

* DNS can be managed via dnscontrol
* Invoices can be paid to Namecheap directly without any intermediaries via their btcpayserver

I had also tried EasyDNS, but while their DNS could be managed via OctoDNS, I found it poorly supported. Their invoices could be paid in Bitcoin, but only through a third party.

## ACME

* Certbot role doesn't support configuring cerbot for dns-01 challenges, yet.

## Container deployments

Few of the container deployments are zero-touch, requiring configuration of variables or manual handling of sensitive secrets. The upshot is that after deployment, long-term maintenance becomes effortless with (typically) single-command upgrades.