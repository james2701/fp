
# distributed algorithms, n.dulay, 9 jan 18
# simple client-server, v1

defmodule App do

def start do
  IO.puts ["      App at ", DNS.my_ip_addr()]
  receive do
    { :bind, beb } -> 
    receive do
      { :beb_deliver, neighbours, max_broadcasts, timeout } ->
        timeout1 = DAC.add(Time.utc_now(), timeout, :millisecond)
        next(beb, neighbours, max_broadcasts, timeout1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, false)
    end
  end
end



defp next(_beb, [_peer0, _peer1, _peer2, _peer3, _peer4], _broadcasts, _timeout, r0, r1, r2, r3, r4, s0, s1, s2, s3, s4, time_out) when time_out == true do
  IO.puts "#{DAC.self_string} is {#{s0}, #{r0}} {#{s1}, #{r1}} {#{s2}, #{r2}} {#{s3}, #{r3}} {#{s4}, #{r4}}"
end




defp next(beb, [peer0, peer1, peer2, peer3, peer4], broadcasts, timeout, r0, r1, r2, r3, r4, s0, s1, s2, s3, s4, _time_out) when broadcasts >= 1 do
  {p0, p1, p2, p3, p4} = {DAC.pid_string(peer0), DAC.pid_string(peer1), DAC.pid_string(peer2), DAC.pid_string(peer3), DAC.pid_string(peer4)}
  send beb, { :beb_broadcast }
  {ns0, ns1, ns2, ns3, ns4} = {s0+1, s1+1, s2+1, s3+1, s4+1}
  {nr0, nr1, nr2, nr3, nr4} =
    receive do
      { :beb_deliver, pid } -> 
        case pid do
          ^p0 -> {r0+1, r1, r2, r3, r4}
          ^p1 -> {r0, r1+1, r2, r3, r4}
          ^p2 -> {r0, r1, r2+1, r3, r4}
          ^p3 -> {r0, r1, r2, r3+1, r4}
          ^p4 -> {r0, r1, r2, r3, r4+1}
        end
    after 10 -> {r0, r1, r2, r3, r4}
    end
    time = Time.utc_now();
    ntime_out = 
      case Time.compare(timeout, time) do
        :lt -> true
        _ -> false
      end
  next(beb, [peer0, peer1, peer2, peer3, peer4], broadcasts - 1, timeout, nr0, nr1, nr2, nr3, nr4, ns0, ns1, ns2, ns3, ns4, ntime_out)


end

defp next(beb, [peer0, peer1, peer2, peer3, peer4], broadcasts, timeout, r0, r1, r2, r3, r4, s0, s1, s2, s3, s4, _time_out) when broadcasts < 1 do
  {p0, p1, p2, p3, p4} = {DAC.pid_string(peer0),DAC.pid_string(peer1),DAC.pid_string(peer2),DAC.pid_string(peer3),DAC.pid_string(peer4)}
  {ns0, ns1, ns2, ns3, ns4} = {s0, s1, s2, s3, s4}
  {nr0, nr1, nr2, nr3, nr4} =
  receive do
    { :beb_deliver, pid } -> 
      case pid do
        ^p0 -> {r0+1, r1, r2, r3, r4}
        ^p1 -> {r0, r1+1, r2, r3, r4}
        ^p2 -> {r0, r1, r2+1, r3, r4}
        ^p3 -> {r0, r1, r2, r3+1, r4}
        ^p4 -> {r0, r1, r2, r3, r4+1}
      end
  after 10 -> {r0, r1, r2, r3, r4}
  end
    time = Time.utc_now();
    ntime_out = 
      case Time.compare(timeout, time) do
        :lt -> true
        _ -> false
      end
  next(beb, [peer0, peer1, peer2, peer3, peer4], broadcasts, timeout, nr0, nr1, nr2, nr3, nr4, ns0, ns1, ns2, ns3, ns4, ntime_out)
end




end # module -----------------------

