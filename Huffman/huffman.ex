defmodule Huffman do
  def sample do
    'the quick brown fox jumps over the lazy dog
    this is a sample text that we will use when we build
    up a table we will only handle lower case letters and
    no punctuation symbols the frequency will of course not
    represent english but it is probably not that far off'
  end

  def text() do
    'this is something that we should encode'
  end

  def test do
    sample = read("./data.txt")
    tree = tree(sample)
    encode = encode_table(tree)
    decode = decode_table(tree)
    text = read("./data.txt")
    seq = encode(text, encode)
    data = decode(seq, decode)
    to_string(data)
  end

  def localTest do
    sample = read("data.txt")
    tree(sample)
  end

  def tree(sample) do
    freq = freq(sample)
    huffman(freq)
  end

  def freq(sample) do
    freq(sample, [])
  end

  def freq([], freq) do
    freq
  end

  def freq([char | rest], freq) do
    freq(rest, getValue(char, freq))
  end

  def getValue(char, []) do
    [{char, 1}]
  end

  def getValue(char, [{char, count} | tail]) do
    [{char, count + 1} | tail]
  end

  def getValue(char, [head | tail]) do
    [head | getValue(char, tail)]
  end

  # sorts data
  def huffman(freq) do
    sort = Enum.sort(freq, fn {_, count1}, {_, count2} -> count1 < count2 end)
    huffmanTree(sort)
  end

  def huffmanTree([{tree, _}]) do
    tree
  end

  def huffmanTree([{ch1, cou1}, {ch2, cou2} | rest]) do
    huffmanTree(addNode({{ch1, ch2}, cou1 + cou2}, rest))
  end

  def addNode({ch1, cou1}, []) do
    [{ch1, cou1}]
  end

  def addNode({ch1, cou1}, [{ch2, cou2} | rest]) do
    case ch1 < ch2 do
      true ->
        [{ch1, cou1}, {ch2, cou2} | rest]

      false ->
        [{ch2, cou2} | addNode({ch1, cou1}, rest)]
    end
  end

  def encode_table(tree) do
    getCodes(tree, [])
  end

  def getCodes({left, right}, codes) do
    left = getCodes(left, [0 | codes])
    right = getCodes(right, [1 | codes])
    left ++ right
  end

  def getCodes(char, codes) do
    [{char, Enum.reverse(codes)}]
  end

  def decode_table(tree) do
    encode_table(tree)
  end

  def encode(data, table) do
    add(Enum.map(data, fn x -> table_find(table, x) end))
  end

  def table_find([], _) do
    []
  end

  def table_find([{x, list} | _], x) do
    list
  end

  def table_find([{_, _} | tail], x) do
    table_find(tail, x)
  end

  def table_find(_, _) do
    nil
  end

  def add([]) do
    []
  end

  def add([h | t]) do
    h ++ add(t)
  end

  def decode([], _) do
    []
  end

  def decode(seq, table) do
    {char, rest} = decode_char(seq, 1, table)
    [char | decode(rest, table)]
  end

  def decode_char(seq, n, table) do
    {code, rest} = Enum.split(seq, n)

    case List.keyfind(table, code, 1) do
      {char, _} ->
        {char, rest}




  end

  def read(file) do
    {:ok, file} = File.open(file, [:read, :utf8])
    binary = IO.read(file, :all)
    File.close(file)

    case :unicode.characters_to_list(binary, :utf8) do
      {:incomplete, list, _} ->
        list

      list ->
        list
    end
  end
end
