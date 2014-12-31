vcl 4.0;

backend default {
  .host = "127.0.0.1";
  .port = "9292";
}


sub vcl_recv {
  return (pass);
}

sub vcl_backend_response {
  set beresp.do_esi = true;
}
