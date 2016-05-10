# Zimbra Wall
A server for blocking users to access Zimbra CS.

This software is used to intercept and apply modifications to the traffic between a Zimbra Proxy and Zimbra Mailboxes.
If you don't know what a Zimbra Proxy is, You can read about it here: [https://wiki.zimbra.com/wiki/Zimbra_Proxy_Guide](https://wiki.zimbra.com/wiki/Zimbra_Proxy_Guide)

This work for all kind of client access:

* POP3
* IMAP
* Webmail
* ActiveSync
* Zimbra Outlook Connector

## Use cases
You need to deny access to some users from Internet.


### How it works
Zimbra Wall reads a map file, a `YAML` file, in which you indicate the pair `email:zimbraID` of the users you want to block

Based on this information, `Zimbra Wall` tell the Zimbra Proxy to deny access to the user.

## Instalation and configuration

### Requirements
This has been tested with:

* Zimbra >= 8.5
* Ruby >= 1.93
* Bundler >= 1.3
* Zimbra Proxy

**You need to have direct access to the `7072` port of both Mailboxes**.

### Installation
It's recommended to install it on the same Zimbra Proxy server. All you need to do is run:

```bash
$ gem install bundler
$ gem install zimbra_wall
```

### Zimbra Proxy Modification

**Important Note**
You are going to modify Zimbra template files, used to build the configuration files of Nginx. **Take some backups!!**

* All the files are located in `/opt/zimbra/conf/nginx/templates`.
* `<`, config being replaced
* `>`, new config

You have to make this modifications

```diff
 # nginx.conf.web.template
<     ${web.login.upstream.disable} ${web.upstream.loginserver.:servers}
<     ${web.login.upstream.disable} ${web.ssl.upstream.loginserver.:servers}
---
>
>     ${web.login.upstream.disable} server localhost:9292 fail_timeout=60s version=8.6.0_GA_1153;
>     ${web.login.upstream.disable} server localhost:9292 fail_timeout=60s version=8.6.0_GA_1153;
```

```diff
 # nginx.conf.zmlookup.template
<         zm_lookup_handlers  ${zmlookup.:handlers};
---
>         zm_lookup_handlers localhost:9292/service/extension/nginx-lookup;
```

Next restart. You should restart memcached and nginx, but just to be sure:

```bash
$ zmcontrol restart
```

### Starting Zimbra Wall

```bash
$ bundle exec bin/zimbra_wall -d zboxapp.dev -f /tmp/users.yml -m 192.168.50.10 -a 0.0.0.0 -p 9292 --mailbox-port 8080
```

#### Options

* `-d`, the domain, in case the user only enters the username,
* `-m`, One of the mailboxes,
* `-f`, the `YAML` map file, with the list of users on the `--newmailbox`,
* `-p`, the bind port
* `-a`, the bind address
* `--mailbox-port`, the mailbox port

#### The Map File

It's a simple YAML file with a `email:zimbraId` pair, like

```yaml
max@example.com: "7b562c60-be97-0132-9a66-482a1423458f"
moliery@example.com: "7b562ce0-be97-0132-9a66-482a1423458f"
watson@example.com: "251b1902-2250-4477-bdd1-8a101f7e7e4e"
sherlock@example.com: "7b562dd0-be97-0132-9a66-482a1423458f"
```

Updating the file does **not require** a restart.

You can get the `zimbraId` with:

```
$ zmprov ga watson@example.com zimbraId
```

##### Error in Map File
If you have an error in your file, `Zimbra Wall` will return the on memory Map, this way we can keep the service up. In this event you should see this on `STDOUT`:

```shel
ERROR Yaml File: (./test/fixtures/users.yml): could not find expected ':' while scanning a simple key at line 7
```

## Init scripts

In the `examples` directory you have the following files:

* `zimbra_wall`, to start the server on port 9292

Copy the file to the `/etc/init.d/` directory and then enable the services like this:

```bash
$ chkconfig --add zimbra_wall
```

### Monit
It may be posible that this crash for some reason, it's a new software after all. To reduce the down time we recomend to use [Monit](http://mmonit.com/monit/) to monitor and restart `Zimbra Wall` in case of trouble.

Check the examples directory for config files.

## Thanks

* To the Zimbra folks for a great product, and
* [@igrigorik](http://twitter.com/igrigorik) for [em-proxy](https://github.com/igrigorik/em-proxy)

## Contributing

1. Fork it ( https://github.com/pbruna/zimbra_intercepting_proxy/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
