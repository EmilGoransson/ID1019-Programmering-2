defmodule Train do
  # returns the list containing the first n elements of the train.

  def take(_, 0) do
    []
  end

  def take([h | t], n) do
    [h | take(t, n - 1)]
  end

  # returns the list xs without its first n elements
  def drop([], 0) do
    []
  end

  def drop([h | t], 0) do
    [h | t]
  end

  def drop([_ | t], n) do
    drop(t, n - 1)
  end

  # returns the list where the elements of xs have been added to the list ys.
  def append(xs, ys) do
    xs ++ ys
  end

  # tests whether y is an element of xs
  def member([], _) do
    false
  end

  def member([h | t], y) do
    if(h == y) do
      true
    else
      member(t, y)
    end
  end

  # returns the first position (1 indexed) of y in the list xs. You can assume that y is an element of xs.

  def position([], _) do
    0
  end

  def position([h | t], y) do
    if(h == y) do
      1
    else
      position(t, y) + 1
    end
  end

  # return a tuple with two lists, all the elemenst before y and all elements after y (i.e. y is not part in either).

  def split(train, y) do
    {take(train, position(train, y) - 1), drop(train, position(train, y))}
  end

  # Explain this one in the report!
  def main([], n) do
    {n, [], []}
  end

  def main([h | t], 0) do
    {0, [h | t], []}
  end

  def main([h | t], n) do
    {k, remain, take} = main(t, n)

    if(k == 0) do
      {k, [h | remain], take}
    else
      {k - 1, remain, [h | take]}
    end
  end
end
