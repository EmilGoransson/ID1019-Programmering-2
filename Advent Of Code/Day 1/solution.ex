defmodule Solution do
  def day1 do
    {:ok, data} = File.read("input.txt")
    # Import file,read data

    # reformat data
    foo = String.split(data, "\r\n")

    foo2 =
      Enum.map(foo, fn x ->
        case Integer.parse(x) do
          :error -> ""
          {val, _} -> val
        end
      end)

    sortedList = Enum.sort(sumList(foo2), &(&1 >= &2))
    solution1 = Enum.at(sortedList, 0)
    solution2 = Enum.at(sortedList, 0) + Enum.at(sortedList, 1) + Enum.at(sortedList, 2)
    IO.puts(solution1)
    IO.puts(solution2)
  end

  def sumList([]) do
    IO.puts(:STOP)
  end

  def sumList([h | ["" | t2]]) do
    [h | sumList(t2)]
  end

  def sumList([h | [h2 | t2]]) do
    test([h + h2 | t2])
  end

  def sumList([h | nil]) do
    [h]
  end

  def sumList(h) do
    h
  end
end
