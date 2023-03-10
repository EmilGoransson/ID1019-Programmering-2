defmodule Deriv do
  # TODO: implement SQRT, LN, 1/X, sinx

  @type literal() :: {:num, number()} | {:var, atom()}

  @type expr() ::
          literal()
          | {:add, expr(), expr()}
          | {:mul, expr(), expr()}
          # x^2
          | {:exp, expr(), literal()}
          | {:sqrt, expr()}
          | {:div, expr(), expr()}
          | {:ln, expr()}
          | {:sin, expr()}
          | {:cos, expr()}
          | {:sub, expr(), expr()}

  def test1() do
    e = {:add, {:mul, {:num, 2}, {:var, :x}}, {:num, 4}}
    d = deriv(e, :x)
    c = calc(d, :x, 5)
    pprint(d)
    IO.write("expression: #{pprint(e)}\n")
    IO.write("derivative: #{pprint(d)}\n")
    IO.write("simplified: #{pprint(simplify(d))}\n")
    IO.write("calculated: #{pprint(simplify(c))}\n")
    :ok
  end

  def test2() do
    e = {:add, {:exp, {:var, :x}, {:num, 3}}, {:num, 4}}
    d = deriv(e, :x)
    c = calc(d, :x, 4)
    pprint(d)
    IO.write("expression: #{pprint(e)}\n")
    IO.write("derivative: #{pprint(d)}\n")
    IO.write("simplified: #{pprint(simplify(d))}\n")
    IO.write("calculated: #{pprint(simplify(c))}\n")

    :ok
  end

  def testLn() do
    e = {:ln, {:var, :x}}
    d = deriv(e, :x)
    IO.write("expression: #{pprint(e)}\n")
    IO.write("derivative: #{pprint(d)}\n")
    IO.write("simplified: #{pprint(simplify(d))}\n")
  end

  def testDiv() do
    e = {:div, {:num, 1}, {:var, :x}}
    d = deriv(e, :x)
    IO.write("expression: #{pprint(e)}\n")
    IO.write("derivative: #{pprint(d)}\n")
    IO.write("simplified: #{pprint(simplify(d))}\n")
  end

  def testSin() do
    e = {:sin, {:mul, {:num, 5}, {:var, :x}}}
    d = deriv(e, :x)
    IO.write("expression: #{pprint(e)}\n")
    IO.write("derivative: #{pprint(d)}\n")
    IO.write("simplified: #{pprint(simplify(d))}\n")
  end

  def testSqrt() do
    e = {:sqrt, {:var, :x}}
    d = deriv(e, :x)
    IO.write("expression: #{pprint(e)}\n")
    IO.write("derivative: #{pprint(d)}\n")
    IO.write("simplified: #{pprint(simplify(d))}\n")
  end

  # Derives the function
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

  def deriv({:sub, e1, e2}, v) do
    {:sub, deriv(e1, v), deriv(e2, v)}
  end

  def deriv({:mul, e1, e2}, v) do
    {:add, {:mul, deriv(e1, v), e2}, {:mul, e1, deriv(e2, v)}}
  end

  def deriv({:exp, e, {:num, n}}, v) do
    {:mul, {:mul, {:num, n}, {:exp, e, {:num, n - 1}}}, deriv(e, v)}
  end

  # ln(x), works, no corner cases
  def deriv({:ln, e}, v) do
    {:div, deriv(e, v), e}
  end

  # Works! Uses  "kvotregeln" to divide
  def deriv({:div, e1, e2}, v) do
    {:div, {:sub, {:mul, deriv(e1, v), e2}, {:mul, e1, deriv(e2, v)}}, {:exp, e2, {:num, 2}}}
  end

  # sqrt works
  def deriv({:sqrt, e}, v) do
    {:div, deriv(e, v), {:mul, {:num, 2}, {:sqrt, e}}}
  end

  # sinx works
  def deriv({:sin, e}, v) do
    {:mul, deriv(e, v), {:cos, e}}
  end

  def calc({:num, n}, _, _) do
    {:num, n}
  end

  def calc({:var, v}, v, n) do
    {:num, n}
  end

  def calc({:var, v}, _, _) do
    {:var, v}
  end

  def calc({:add, e1, e2}, v, n) do
    {:add, calc(e1, v, n), calc(e2, v, n)}
  end

  ## sub
  def calc({:sub, e1, e2}, v, n) do
    {:add, calc(e1, v, n), calc(e2, v, n)}
  end

  def calc({:mul, e1, e2}, v, n) do
    {:mul, calc(e1, v, n), calc(e2, v, n)}
  end

  def calc({:exp, e1, e2}, v, n) do
    {:exp, calc(e1, v, n), calc(e2, v, n)}
  end

  def calc({:ln, e1}, v, n) do
    {:ln, calc(e1, v, n)}
  end

  def calc({:div, e1, e2}, v, n) do
    {:div, calc(e1, v, n), calc(e2, v, n)}
  end

  def calc({:sqrt, e}, v, n) do
    {:sqrt, calc(e, v, n)}
  end

  def calc({:sin, e}, v, n) do
    {:sin, calc(e, v, n)}
  end

  def calc({:cos, e}, v, n) do
    {:cos, calc(e, v, n)}
  end

  def simplify({:add, e1, e2}) do
    simplify_add(simplify(e1), simplify(e2))
  end

  # sub
  def simplify({:sub, e1, e2}) do
    simplify_sub(simplify(e1), simplify(e2))
  end

  def simplify({:mul, e1, e2}) do
    simplify_mul(simplify(e1), simplify(e2))
  end

  def simplify({:exp, e1, e2}) do
    simplify_exp(simplify(e1), simplify(e2))
  end

  def simplify({:div, e1, e2}) do
    simplify_div(simplify(e1), simplify(e2))
  end

  def simplify({:sin, e}) do
    simplify_sin(simplify(e))
  end

  def simplify({:cos, e}) do
    simplify_cos(simplify(e))
  end

  def simplify({:sqrt, e1}) do
    simplify_sqrt(simplify(e1))
  end

  def simplify({:ln, e1}) do
    simplify_ln(simplify(e1))
  end

  # catch all
  def simplify(e) do
    e
  end

  # Addition
  def simplify_add({:num, 0}, e2) do
    e2
  end

  def simplify_add(e1, {:num, 0}) do
    e1
  end

  def simplify_add({:num, n1}, {:num, n2}) do
    {:num, n1 + n2}
  end

  # Sub
  def simplify_sub({:num, a}, {:num, b}) do
    {:num, a - b}
  end

  def simplify_sub(a, {:num, b}) do
    {:num, elem(a, 1) - b}
  end

  def simplify_sub({:num, a}, b) do
    {:num, a - elem(b, 1)}
  end

  # Multiplication
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
    {:num, n1 * n2}
  end

  def simplify_mul(e1, e2) do
    {:mul, e1, e2}
  end

  # Exp
  def simplify_exp(_, {:num, 0}) do
    {:num, 1}
  end

  def simplify_exp(e1, {:num, 1}) do
    e1
  end

  def simplify_exp({:num, n1}, {:num, n2}) do
    {:num, :math.pow(n1, n2)}
  end

  def simplify_exp(e1, e2) do
    {:exp, e1, e2}
  end

  def simplify_div(e1, {:num, 1}) do
    e1
  end

  def simplify_div({:num, n1}, {:num, n2}) do
    {:num, n1 / n2}
  end

  def simplify_div(e1, e2) do
    {:div, e1, e2}
  end

  def simplify_ln({:num, 1}) do
    {:num, 0}
  end

  def simplify_ln({:num, 0}) do
    {:num, 0}
  end

  def simplify_ln(e) do
    {:ln, e}
  end

  def simplify_sin(e) do
    {:sin, e}
  end

  def simplify_cos(e) do
    {:cos, e}
  end

  def simplify_sqrt({:num, n}) do
    {:num, :math.sqrt(n)}
  end

  def simplify_sqrt(e) do
    {:sqrt, e}
  end

  def pprint({:num, n}) do
    "#{n}"
  end

  def pprint({:ln, e}) do
    "ln(#{pprint(e)})"
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

  def pprint({:exp, e1, e2}) do
    "(#{pprint(e1)})^(#{pprint(e2)})"
  end

  def pprint({:sub, e1, e2}) do
    "#{pprint(e1)} - #{pprint(e2)}"
  end

  def pprint({:div, e1, e2}) do
    "(#{pprint(e1)})/(#{pprint(e2)})"
  end

  def pprint({:sin, e}) do
    "sin(#{pprint(e)})"
  end

  def pprint({:cos, e}) do
    "cos(#{pprint(e)})"
  end

  def pprint({:sqrt, e1}) do
    "(#{pprint(e1)})^(1/2)"
  end
end
