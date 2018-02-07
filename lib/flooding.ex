# distributed algorithms, n.dulay, 4 jan 18
# simple client-server, v1

defmodule Flooding do

def main do 
  IO.puts ["Flooding at ", DNS.my_ip_addr()]
  peer0 = spawn(Peer, :start, [])
  peer1 = spawn(Peer, :start, [])
  peer2 = spawn(Peer, :start, [])
  peer3 = spawn(Peer, :start, [])
  peer4 = spawn(Peer, :start, [])

  send peer0, { :sys, self() }
  send peer1, { :sys, self() }
  send peer2, { :sys, self() }
  send peer3, { :sys, self() }
  send peer4, { :sys, self() }

  {p0, p1, p2, p3, p4} = {DAC.pid_string(peer0), DAC.pid_string(peer1), DAC.pid_string(peer2), DAC.pid_string(peer3), DAC.pid_string(peer4)}
  pl0 = 
    receive do
      {^p0, pl} -> pl
    end
  pl1 = 
    receive do
      {^p1, pl} -> pl
    end
  pl2 = 
    receive do
      {^p2, pl} -> pl
    end
  pl3 = 
    receive do
      {^p3, pl} -> pl
    end
  pl4 = 
    receive do
      {^p4, pl} -> pl
    end


  send pl0, { :binding, [pl0, pl1, pl2, pl3, pl4]}
  send pl1, { :binding, [pl0, pl1, pl2, pl3, pl4]}
  send pl2, { :binding, [pl0, pl1, pl2, pl3, pl4]}
  send pl3, { :binding, [pl0, pl1, pl2, pl3, pl4]}
  send pl4, { :binding, [pl0, pl1, pl2, pl3, pl4]}

  send pl0, { :broadcast, 1000, 3000}
  send pl1, { :broadcast, 1000, 3000}
  send pl2, { :broadcast, 1000, 3000}
  send pl3, { :broadcast, 1000, 3000}
  send pl4, { :broadcast, 1000, 3000}

  receive do
    { :aaa, :bbb } -> Process.exit(peer3, :kill1)
    after 5 -> Process.exit(peer3, :kill)
  end



end


def main_net do 
  IO.puts ["Flooding at ", DNS.my_ip_addr()]
  peer0 = Node.spawn(:'peer0@peer0.localdomain', Peer, :start, [])
  peer1 = Node.spawn(:'peer1@peer1.localdomain', Peer, :start, [])
  peer2 = Node.spawn(:'peer2@peer2.localdomain', Peer, :start, [])
  peer3 = Node.spawn(:'peer3@peer3.localdomain', Peer, :start, [])
  peer4 = Node.spawn(:'peer4@peer4.localdomain', Peer, :start, [])

  send peer0, { :sys, self() }
  send peer1, { :sys, self() }
  send peer2, { :sys, self() }
  send peer3, { :sys, self() }
  send peer4, { :sys, self() }

  {p0, p1, p2, p3, p4} = {DAC.pid_string(peer0), DAC.pid_string(peer1), DAC.pid_string(peer2), DAC.pid_string(peer3), DAC.pid_string(peer4)}
  pl0 = 
    receive do
      {^p0, pl} -> pl
    end
  pl1 = 
    receive do
      {^p1, pl} -> pl
    end
  pl2 = 
    receive do
      {^p2, pl} -> pl
    end
  pl3 = 
    receive do
      {^p3, pl} -> pl
    end
  pl4 = 
    receive do
      {^p4, pl} -> pl
    end


  send pl0, { :binding, [pl0, pl1, pl2, pl3, pl4]}
  send pl1, { :binding, [pl0, pl1, pl2, pl3, pl4]}
  send pl2, { :binding, [pl0, pl1, pl2, pl3, pl4]}
  send pl3, { :binding, [pl0, pl1, pl2, pl3, pl4]}
  send pl4, { :binding, [pl0, pl1, pl2, pl3, pl4]}

  send pl0, { :broadcast, 1000, 3000}
  send pl1, { :broadcast, 1000, 3000}
  send pl2, { :broadcast, 1000, 3000}
  send pl3, { :broadcast, 1000, 3000}
  send pl4, { :broadcast, 1000, 3000}
  
end

end # module -----------------------