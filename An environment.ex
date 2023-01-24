defmodule EnvList do
  # Returns an empty map
  def new() do
    []
  end

  ## add, works
  def add([], key, value) do
    [{key, value}]
  end

  def add([{key, _} | t], key, value) do
    [{key, value} | t]
  end

  def add([h | t], key, value) do
    [h | add(t, key, value)]
  end

  ## Lookup, works
  def lookup([], _) do
    nil
  end

  def lookup([{cKey, value} | t], key) do
    if cKey == key do
      {cKey, value}
    else
      lookup(t, key)
    end
  end

  # Lookup, works but if the item you want to remove doesnt exist the return value is weird. e.g EnvList.remove(:c, [{:a, 200}, {:b, 500}])  ->  [{:a, 200}, [b: 500]])
  def remove(_, []) do
    []
  end

  def remove(key, [{key, _} | t]) do
    t
  end

  def remove(key, [h | t]) do
    a = remove(key, t)

    if(a != []) do
      [h, a]
    else
      [h]
    end
  end
end
