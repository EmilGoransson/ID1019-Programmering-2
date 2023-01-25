defmodule EnvList do
  # Returns an empty map

  def bench(i, n) do
    seq = Enum.map(1..i, fn _ -> :rand.uniform(i) end)

    list =
      Enum.reduce(seq, EnvList.new(), fn e, list ->
        EnvList.add(list, e, :foo)
      end)

    seq = Enum.map(1..n, fn _ -> :rand.uniform(i) end)

    {add, _} =
      :timer.tc(fn ->
        Enum.each(seq, fn e ->
          EnvList.add(list, e, :foo)
        end)
      end)

    {lookup, _} =
      :timer.tc(fn ->
        Enum.each(seq, fn e ->
          EnvList.lookup(list, e)
        end)
      end)

    {remove, _} =
      :timer.tc(fn ->
        Enum.each(seq, fn e ->
          EnvList.remove(list, e)
        end)
      end)

    {i, add, lookup, remove}
  end

  def bench(n) do
    ls = [16, 32, 64, 128, 256, 512, 1024, 2 * 1024, 4 * 1024, 8 * 1024]
    :io.format("# benchmark with ~w operations, time per operation in us\n", [n])
    :io.format("~6.s~12.s~12.s~12.s\n", ["n", "add", "lookup", "remove"])

    Enum.each(ls, fn i ->
      {i, tla, tll, tlr} = bench(i, n)
      :io.format("~6.w~12.2f~12.2f~12.2f\n", [i, tla / n, tll / n, tlr / n])
    end)
  end

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
  def remove([], _) do
    []
  end

  def remove([{key, _} | t], key) do
    t
  end

  def remove([h | t], key) do
    [h | remove(t, key)]
  end
end

defmodule EnvTree do
  def bench(i, n) do
    seq = Enum.map(1..i, fn _ -> :rand.uniform(i) end)

    list =
      Enum.reduce(seq, EnvList.new(), fn e, list ->
        EnvList.add(list, e, :foo)
      end)

    seq = Enum.map(1..n, fn _ -> :rand.uniform(i) end)

    {add, _} =
      :timer.tc(fn ->
        Enum.each(seq, fn e ->
          EnvList.add(list, e, :foo)
        end)
      end)

    {lookup, _} =
      :timer.tc(fn ->
        Enum.each(seq, fn e ->
          EnvList.lookup(list, e)
        end)
      end)

    {remove, _} =
      :timer.tc(fn ->
        Enum.each(seq, fn e ->
          EnvList.remove(list, e)
        end)
      end)

    {i, add, lookup, remove}
  end

  def bench(n) do
    ls = [16, 32, 64, 128, 256, 512, 1024, 2 * 1024, 4 * 1024, 8 * 1024]
    :io.format("# benchmark with ~w operations, time per operation in us\n", [n])
    :io.format("~6.s~12.s~12.s~12.s\n", ["n", "add", "lookup", "remove"])

    Enum.each(ls, fn i ->
      {i, tla, tll, tlr} = bench(i, n)
      :io.format("~6.w~12.2f~12.2f~12.2f\n", [i, tla / n, tll / n, tlr / n])
    end)
  end

  def add(nil, key, value) do
    {:node, key, value, nil, nil}
  end

  def add({:node, key, _, left, right}, key, value) do
    {:node, key, value, left, right}
  end

  def add({:node, k, v, left, right}, key, value) when key < k do
    {:node, k, v, add(left, key, value), right}
  end

  def add({:node, k, v, left, right}, key, value) do
    {:node, k, v, left, add(right, key, value)}
  end

  def lookup(nil, _) do
    nil
  end

  def lookup({:node, key, value, _, _}, key) do
    {key, value}
  end

  def lookup({:node, k, _, left, _}, key) when key < k do
    lookup(left, key)
  end

  def lookup({:node, _, _, _, right}, key) do
    lookup(right, key)
  end

  def remove(nil, _) do
    nil
  end

  def remove({:node, key, _, nil, right}, key) do
    right
  end

  def remove({:node, key, _, left, nil}, key) do
    left
  end

  def remove({:node, key, _, left, right}, key) do
    {key, value, newRight} = leftmost(right)
    {:node, key, value, left, newRight}
  end

  def remove({:node, k, v, left, right}, key) when key < k do
    {:node, k, v, remove(left, key), right}
  end

  def remove({:node, k, v, left, right}, key) do
    {:node, k, v, left, remove(right, key)}
  end

  def leftmost({:node, key, value, nil, rest}) do
    {key, value, rest}
  end

  def leftmost({:node, k, v, left, right}) do
    {key, value, newLeft} = leftmost(left)
    {key, value, {:node, k, v, newLeft, right}}
  end
end
