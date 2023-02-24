defmodule Shunt do
  # basecase
  def find(_, []) do
    []
  end

  def find(xs, [y | ys]) do
    {hs, ts} = Train.split(xs, y)
    tn = length(ts)
    hn = length(hs)

    [
      {:one, Enum.count(ts) + 1},
      {:two, Enum.count(hs)},
      {:one, -(Enum.count(ts) + 1)},
      {:two, -Enum.count(hs)} | find(Train.append(hs, ts), ys)
    ]
  end

  def few(_, []) do
    []
  end

  ## NOT DONE DOESNT WORK!
  def few(xs, [y | ys]) do
    {hs, ts} = Train.split(xs, y)
    tn = length(ts)
    hn = length(hs)

    [
      {:one, Enum.count(ts) + 1},
      {:two, Enum.count(hs)},
      {:one, -(Enum.count(ts) + 1)},
      {:two, -Enum.count(hs)} | find(Train.append(hs, ts), ys)
    ]
  end
end
