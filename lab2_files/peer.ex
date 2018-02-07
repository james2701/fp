
# distributed algorithms, n.dulay, 9 jan 18
# simple client-server, v1

defmodule Peer do

def start do
  IO.puts ["      Peer at ", DNS.my_ip_addr()]
  receive do
    { :bind, neighbours } -> 
    receive do
      { :broadcast, max_broadcasts, timeout } ->
      timeout1 = add(Time.utc_now(), timeout, :millisecond)
      next(neighbours, max_broadcasts, timeout1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, false)
    end
  end
end



defp next([_peer0, _peer1, _peer2, _peer3, _peer4], _broadcasts, _timeout, r0, r1, r2, r3, r4, s0, s1, s2, s3, s4, time_out) when time_out == true do
  IO.puts "#{DAC.self_string} is {#{s0}, #{r0}} {#{s1}, #{r1}} {#{s2}, #{r2}} {#{s3}, #{r3}} {#{s4}, #{r4}}"
end




defp next([peer0, peer1, peer2, peer3, peer4], broadcasts, timeout, r0, r1, r2, r3, r4, s0, s1, s2, s3, s4, _time_out) when broadcasts >= 1 do
  {p0, p1, p2, p3, p4} = {DAC.pid_string(peer0), DAC.pid_string(peer1), DAC.pid_string(peer2), DAC.pid_string(peer3), DAC.pid_string(peer4)}
  {ns0, ns1, ns2, ns3, ns4} = {s0+1, s1+1, s2+1, s3+1, s4+1}
    for n <- [peer0, peer1, peer2, peer3, peer4] do
      send n, { :broadcast, DAC.self_string() }
    end
  {nr0, nr1, nr2, nr3, nr4} =
    receive do
      { :broadcast, pid } -> 
        case pid do
          ^p0 -> {r0+1, r1, r2, r3, r4}
          ^p1 -> {r0, r1+1, r2, r3, r4}
          ^p2 -> {r0, r1, r2+1, r3, r4}
          ^p3 -> {r0, r1, r2, r3+1, r4}
          ^p4 -> {r0, r1, r2, r3, r4+1}
        end
    after 1_000 -> {r0, r1, r2, r3, r4}
    end
    time = Time.utc_now();
    ntime_out = 
      case Time.compare(timeout, time) do
        :lt -> true
        _ -> false
      end
  next([peer0, peer1, peer2, peer3, peer4], broadcasts - 1, timeout, nr0, nr1, nr2, nr3, nr4, ns0, ns1, ns2, ns3, ns4, ntime_out)


end

defp next([peer0, peer1, peer2, peer3, peer4], broadcasts, timeout, r0, r1, r2, r3, r4, s0, s1, s2, s3, s4, _time_out) when broadcasts < 1 do
  {p0, p1, p2, p3, p4} = {DAC.pid_string(peer0),DAC.pid_string(peer1),DAC.pid_string(peer2),DAC.pid_string(peer3),DAC.pid_string(peer4)}
  {ns0, ns1, ns2, ns3, ns4} = {s0, s1, s2, s3, s4}
  {nr0, nr1, nr2, nr3, nr4} =
    receive do
      { :broadcast, pid } -> 
        case pid do
          ^p0 -> {r0+1, r1, r2, r3, r4}
          ^p1 -> {r0, r1+1, r2, r3, r4}
          ^p2 -> {r0, r1, r2+1, r3, r4}
          ^p3 -> {r0, r1, r2, r3+1, r4}
          ^p4 -> {r0, r1, r2, r3, r4+1}
        end
      after 1_000 -> {r0, r1, r2, r3, r4}
    end
    time = Time.utc_now();
    ntime_out = 
      case Time.compare(timeout, time) do
        :lt -> true
        _ -> false
      end
  next([peer0, peer1, peer2, peer3, peer4], broadcasts, timeout, nr0, nr1, nr2, nr3, nr4, ns0, ns1, ns2, ns3, ns4, ntime_out)
end

  def add(%{calendar: calendar} = time, number, unit \\ :second) when is_integer(number) do
    number = System.convert_time_unit(number, unit, :microsecond)
    iso_days = {0, to_day_fraction(time)}
    total = Calendar.ISO.iso_days_to_unit(iso_days, :microsecond) + number
    iso_ppd = 86_400_000_000
    parts = Integer.mod(total, iso_ppd)

    {hour, minute, second, microsecond} = calendar.time_from_day_fraction({parts, iso_ppd})

    %Time{
      hour: hour,
      minute: minute,
      second: second,
      microsecond: microsecond,
      calendar: calendar
    }
  end
  defp to_day_fraction(%{
         hour: hour,
         minute: minute,
         second: second,
         microsecond: {_, _} = microsecond,
         calendar: calendar
       }) do
    calendar.time_to_day_fraction(hour, minute, second, microsecond)
  end



end # module -----------------------

