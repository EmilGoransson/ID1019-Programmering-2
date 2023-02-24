defmodule Train do
  # returns the list containing the first n elements of the train.
  def list_length([]) do
    0
  end

  def list_length([_ | t]) do
    list_length(t) + 1
  end

  def take(_, 0) do
    []
  end

  ## case for negative n (bc of how i prev implemented single/2 i need this)
  def take(trains, n) when n < 0 do
    drop(trains, list_length(trains) + n)
  end

  def take([h | t], n) do
    [h | take(t, n - 1)]
  end

  # returns the list xs without its first n elements

  def drop([], 0) do
    []
  end

  # case for negative n (needed bc of how implemented single/2 prev)
  def drop(list, n) when n < 0 do
    take(list, list_length(list) + n)
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

  # basecase,if the input list is empty, return a tuple with the original value of and empty lists.
  def main([], n) do
    {n, [], []}
  end

  # basecase 2, if n == 0 we return list.
  def main([h | t], 0) do
    {0, [h | t], []}
  end

  # uses pattern matching.
  def main([h | t], n) do
    {k, remain, take} = main(t, n)
    # check if k is 0 though pattern matching.
    if(k == 0) do
      {k, [h | remain], take}
    else
      {k - 1, remain, [h | take]}
    end
  end
end
