
# distributed algorithms, n.dulay, 9 jan 18
# simple client-server, v1

defmodule Peer3 do

def start do
  IO.puts ["      Peer at ", DNS.my_ip_addr()]
  pl = spawn(Pl, :start, [])
  beb = spawn(Beb, :start, [])
  app = spawn(App, :start, [])
  send pl, { :bind, beb}
  send app, { :bind, beb}
  send beb, { :bind, pl, app}
  receive do
    { :sys, system } -> 
      send system, {DAC.self_string(), pl}
      process.sleep(5)
      process.kill()
  end
end





end # module -----------------------

