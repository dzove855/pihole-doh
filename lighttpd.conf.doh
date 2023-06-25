# lighttpd config for dns-over-http to be just a path instead of a different port

$HTTP["url"] =~ "^/dns-query" {
     proxy.server  = ( "" => 
        (( "host" => "127.0.0.1", "port" => 8053 ))
    )
}

server.modules += ("mod_proxy")
