
# distributed algorithms, n.dulay, 9 jan 18
# simple client-server, v1

defmodule Beb do

def start do
  IO.puts ["      Beb at ", DNS.my_ip_addr()]
  receive do
    { :bind, pl, app} -> 
      receive do
        { :pl_deliver, neighbours, max_broadcasts, timeout } ->
          send app, { :beb_deliver, neighbours, max_broadcasts, timeout }
          next(neighbours, pl, app)
      end
  end
end


defp next(neighbours, pl, app) do
  receive do 
    { :beb_broadcast } -> 
      for dest <- neighbours do
        send pl, { :pl_send, dest }
      end
    { :pl_deliver, pid, } -> send app, { :beb_deliver, pid }
  end
  next(neighbours, pl, app)
end

end # module -----------------------

