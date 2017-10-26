## start

### Starman:
`starman --l 127.0.0.1:3001 <abs_path_to>/bin/app.pl --daemonize --pid /tmp/barcode.pid --workers 10`

### Twiggy:
`plackup -s Twiggy -p 3000 -a bin/app.pl`

or this: (needs Server::Starter)

`start_server --port=3000 --pid-file=/tmp/barcode.pid --daemonize --log-file=var/app.log -- plackup -s Twiggy -a bin/app.pl`

## kill:
`cat /tmp/barcode.pid | xargs kill`

## graceful:
`cat /tmp/barcode.pid | xargs kill -HUP`
