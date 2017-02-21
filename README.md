### start:
`carton exec 'starman --l 127.0.0.1:3001 <abs_path_to>/bin/app.pl --daemonize --pid /tmp/barcode.pid --workers 10'`

### kill:
`cat /tmp/barcode.pid | xargs kill`

### graceful:
`cat /tmp/barcode.pid | xargs kill -HUP`
