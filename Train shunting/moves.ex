defmodule Moves do
  ## antag n>0

  # uses fact that -n arg in .drop reverses order
  def single({:one, n}, {main, one, two}) when n >= 0 do
    {Train.drop(main, -n), Train.append(Train.take(main, -n), one), two}
  end

  # uses fact that -n arg in .drop reverses order
  def single({:one, n}, {main, one, two}) when n < 0 do
    {Train.append(main, Train.take(one, -n)), Train.drop(one, -n), two}
  end

  # uses fact that -n arg in .drop reverses order
  def single({:two, n}, {main, one, two}) when n >= 0 do
    {Train.drop(main, -n), one, Train.append(Train.take(main, -n), two)}
  end

  # uses fact that -n arg in .drop reverses order
  def single({:two, n}, {main, one, two}) when n < 0 do
    {Train.append(main, Train.take(two, -n)), one, Train.drop(two, -n)}
  end

  def single(_, {main, one, two}) do
    {main, one, two}
  end

  def sequence([], state) do
    [state]
  end

  def sequence([h | t], state) do
    [state | sequence(t, single(h, state))]
  end
end
