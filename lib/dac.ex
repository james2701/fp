
# distributed algorithms, n.dulay, 22 jan 18
# some helper functions 

defmodule DAC do

def lookup name do
  addresses = :inet_res.lookup name, :in, :a 
  {a, b, c, d} = hd addresses   # get octets for 1st ipv4 address
  :"#{a}.#{b}.#{c}.#{d}"
end

def node_ip_addr do
  {:ok, interfaces} = :inet.getif()		# get interfaces
  {address, _gateway, _mask}  = hd interfaces	# get data for 1st interface
  {a, b, c, d} = address   			# get octets for address
  "#{a}.#{b}.#{c}.#{d}"
end

def elixir_node "", _ do   # return local elixir node
  node()
end

def elixir_node name, n do
  :'#{name}#{n}@#{name}#{n}.localdomain'
end

def node_spawn where, k, module, function, args do
  Node.spawn elixir_node(where, k), module, function, args
end

# ----

def pid_string(pid) when is_pid(pid), do: inspect(pid)

def self_string, do: inspect self()

# ----

def args, do: System.argv

def int_args do
  for arg <- System.argv, do: String.to_integer(arg)
end

# ----

def random(n), do: Enum.random 1..n

def sqrt(x), do: :math.sqrt x


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


 
