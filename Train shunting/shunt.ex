defmodule Shunt do
  # basecase
  def find(_, []) do
    []
  end

  def find(xs, [y | ys]) do
    {hs, ts} = Train.split(xs, y)

    moves = [
      {:one, Train.list_length(ts) + 1},
      {:two, Train.list_length(hs)},
      {:one, -(Train.list_length(ts) + 1)},
      {:two, -Train.list_length(hs)}
    ]

    Train.append(moves, find(Train.append(ts, hs), ys))
  end

  def few(_, []) do
    []
  end

  def few([h | t], [y | ys]) do
    ## checks if we already have wagon1 in right position
    if(h == y) do
      few(t, ys)
    else
      {hs, ts} = Train.split([h | t], y)

      moves = [
        {:one, Train.list_length(ts) + 1},
        {:two, Train.list_length(hs)},
        {:one, -(Train.list_length(ts) + 1)},
        {:two, -Train.list_length(hs)}
      ]

      Train.append(moves, few(Train.append(ts, hs), ys))
    end
  end

  def rules([]) do
    []
  end

  def rules([{:one, n} | [{:one, m} | t2]]) do
    rules([{:one, n + m} | rules(t2)])
  end

  def rules([{:two, n} | [{:two, m} | t2]]) do
    rules([{:two, n + m} | rules(t2)])
  end

  def rules([{:one, 0} | t]) do
    rules(t)
  end

  def rules([{:two, 0} | t]) do
    rules(t)
  end

  def rules([h | []]) do
    [h]
  end

  def rules(list) do
    list
  end

  def compress(ms) do
    ns = rules(ms)

    if ns == ms do
      ms
    else
      compress(ns)
    end
  end
end
