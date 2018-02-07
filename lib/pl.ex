
# distributed algorithms, n.dulay, 9 jan 18
# simple client-server, v1

defmodule Pl do

def start do
  IO.puts ["      Pl at ", DNS.my_ip_addr()]
  receive do
    { :bind, beb } -> 
    receive do
      { :binding, neighbours } ->
        receive do
          { :broadcast, max_broadcasts, timeout } ->
            send beb, { :pl_deliver, neighbours, max_broadcasts, timeout }
            next (beb)
        end
    end
  end
end


defp next(beb) do

  receive do 
    { :pl_send, dest, } -> 
      cond do
        DAC.random(100) > 0 -> send dest, {:broadcast, DAC.self_string()}
        true -> send dest, {:b, DAC.self_string()}
      end
    { :broadcast, pid} -> send beb, { :pl_deliver, pid,}
  end
  next(beb)
end

end # module -----------------------

