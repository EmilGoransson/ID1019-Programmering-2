defmodule Deriv do

  @type literal() :: {:num, number()} | {:var, atom()}

  @type expr() :: literal()
  | {:add, expr(), expr()}
  | {:mul, expr(), expr()}
  | {:num, expr(), literal()}

  def test1() do
    e = {:add,
          {:mul, {:num, 2}, {:var, :x}},
          {:num, 4}}
    d = deriv(e, :x)
    pprint(d)
    IO.write("expression: #{pprint(e)}\n")
    IO.write("derivative: #{pprint(d)}\n")
    IO.write("simplified: #{pprint(simplify(d))}\n")
    :ok
  end

  def test2() do
    e = {:add,
          {:exp, {:var, :x}, {:num, 3}},
          {:num, 4}}
    d = deriv(e, :x)
    pprint(d)
    IO.write("expression: #{pprint(e)}\n")
    IO.write("derivative: #{pprint(d)}\n")
    IO.write("simplified: #{pprint(simplify(d))}\n")
    :ok
  end


  def deriv({:num, _}, _) do
    {:num, 0}
  end

  def deriv({:var, v}, v) do
    {:num, 1}
  end

  def deriv({:var, _}, _) do
    {:num, 0}
  end

  def deriv({:add, e1, e2}, v) do
    {:add, deriv(e1, v), deriv(e2, v)}
  end

  def deriv({:mul, e1, e2}, v) do
    {:add,
      {:mul, deriv(e1,v), e2},
      {:mul, e1, deriv(e2,v)}}
  end

  def deriv({:exp, e, {:num, n}}, v) do
    {:mul,
      {:mul, {:num, n}, {:exp, e, {:num, n-1}}},
      deriv(e,v)}
  end




  def simplify({:add, e1, e2}) do
    simplify_add(simplify(e1), simplify(e2))
  end
  def simplify({:mul, e1, e2}) do
    simplify_mul(simplify(e1), simplify(e2))
  end

  #catch all
  def simplify(e) do
    e
  end

  #Addition
  def simplify_add({:num, 0}, e2) do
    e2
  end
  def simplify_add(e1, {:num, 0}) do
    e1
  end
  def simplify_add({:num, n1}, {:num, n2}) do
    {:num, n1+n2}
  end

  #Multiplication
  def simplify_mul({:num, 0}, _) do
    {:num, 0}
  end
  def simplify_mul(_, {:num, 0}) do
    {:num, 0}
  end
  def simplify_mul({:num, 1}, e2) do
    e2
  end
  def simplify_mul(e1, {:num, 1}) do
    e1
  end
  def simplify_mul({:num, n1}, {:num, n2}) do
    {:num, n1*n2}
  end




  def pprint({:num, n}) do
    "#{n}"
  end

  def pprint({:var, v}) do
    "#{v}"
  end

  def pprint({:add, e1, e2}) do
    "(#{pprint(e1)} + #{pprint(e2)})"
  end

  def pprint({:mul, e1, e2}) do
    "#{pprint(e1)} * #{pprint(e2)}"
  end

  #add print for exp here:

end
