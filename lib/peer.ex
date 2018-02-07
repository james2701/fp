
# distributed algorithms, n.dulay, 9 jan 18
# simple client-server, v1

defmodule Peer do

def start do
  IO.puts ["      Peer at ", DNS.my_ip_addr()]
  pl = spawn(Pl, :start, [])
  beb = spawn(Beb, :start, [])
  app = spawn(App, :start, [])
  send pl, { :bind, beb}
  send app, { :bind, beb}
  send beb, { :bind, pl, app}
  receive do
    { :sys, system2 } -> 
      send system2, {DAC.self_string(), pl}
  end
end





end # module -----------------------

