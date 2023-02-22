defmodule Train do
  # returns the list containing the first n elements of xs.
  def take(xs, n) do
    Enum.take(xs, n)
  end

  # returns the list xs without its first n elements
  def drop(xs, n) do
    Enum.drop(xs, n)
  end

  # returns the list where the elements of xs have been added to the list ys.
  def append(xs, ys) do
    xs ++ ys
  end

  # tests whether y is an element of xs
  def member(xs, y) do
    Enum.member?(xs, y)
  end

  # returns the first position (1 indexed) of y in the list xs. You can assume that y is an element of xs.
  def position(xs, y) do
    Enum.find_index(xs, fn x -> x == y end) + 1
  end

  # return a tuple with two lists, all the elemenst before y and all elements after y (i.e. y is not part in either).
  def split(xs, y) do
    Enum.split(xs, position(xs, y))
  end
end
