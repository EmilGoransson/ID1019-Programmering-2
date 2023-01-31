defmodule Expression do
  @type literal() ::
          {:num, number()}
          | {:var, atom()}
          | {:q, number(), number()}

  @type expr() ::
          {:add, expr(), expr()}
          | {:sub, expr(), expr()}
          | {:mul, expr(), expr()}
          | {:div, expr(), expr()}
          | literal()

  def test do
    exprFinal = {:add, {:add, {:mul, {:num, 2}, {:var, :x}}, {:q, 3, 4}}, {:q, 1, 2}}
    env = %{x: 5, y: 2}
    eval(exprFinal, env)
  end

  def eval({:num, n}, _) do
    n
  end

  def eval({:var, v}, env) do
    Map.get(env, v)
  end

  def eval({:add, e1, e2}, env) do
    add(eval(e1, env), eval(e2, env))
  end

  def eval({:sub, e1, e2}, env) do
    sub(eval(e1, env), eval(e2, env))
  end

  def eval({:mul, e1, e2}, env) do
    mul(eval(e1, env), eval(e2, env))
  end

  def eval({:div, e1, e2}, env) do
    divi(eval(e1, env), eval(e2, env))
  end

  def eval({:q, e1, e2}, _) do
    quo(e1, e2)
  end

  def add({:q, e1, e2}, {:q, e3, e4}) do
    {:q, e1 * e4 + e3 * e2, e2 * e4}
  end

  def add({:q, e1, e2}, e3) do
    add({:q, e1, e2}, {:q, e3 * e2, e2})
  end

  def add(e1, {:q, e2, e3}) do
    add({:q, e1 * e3, e3}, {:q, e2, e3})
  end

  def add(e1, e2) do
    e1 + e2
  end

  def sub({:q, e1, e2}, {:q, e3, e4}) do
    {:q, e1 * e4 - e3 * e2, e2 * e4}
  end

  def sub({:q, e1, e2}, e3) do
    sub({:q, e1, e2}, {:q, e3 * e2, e2})
  end

  def sub(e1, {:q, e2, e3}) do
    add({:q, e1 * e3, e3}, {:q, e2, e3})
  end

  def sub(e1, e2) do
    e1 - e2
  end

  def mul({:q, e1, e2}, {:q, e3, e4}) do
    {:q, e1 * e3, e2 * e4}
  end

  def mul({:q, e1, e2}, e3) do
    {:q, e1 * e3, e2}
  end

  def mul(e1, {:q, e2, e3}) do
    {:q, e1 * e2, e3}
  end

  def mul(e1, e2) do
    e1 * e2
  end

  def divi({:q, e1, e2}, {:q, e3, e4}) do
    {:q, e1 * e4, e2 * e3}
  end

  def divi({:q, e1, e2}, e3) do
    {:q, e1, e2 * e3}
  end

  def divi(e1, {:q, e2, e3}) do
    {:q, e1 * e3, e2}
  end

  def divi(e1, e2) do
    e1 / e2
  end

  def quo(e1, e2) do
    e1 / e2
  end
end
