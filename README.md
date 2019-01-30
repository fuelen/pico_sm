
# PicoSM - Pico State Management

## About
Very small Elixir library for state transitions validation.
Motivation: a library that allows having many initial states (unlike many other FSM realizations) using implicit `nil` as an initial state.

## Usage
Define a module
```elixir
defmodule MyFlow do
  use PicoSM,
    rules: [
      nil: :a,
      nil: :b,
      nil: :c,
      nil: :d,
      nil: :e,
      a: :e,
      a: :f,
      a: :g,
      b: :d,
      b: :f,
      b: :g,
      c: :d,
      c: :f,
      c: :e,
      c: :g,
      k: :l,
      d: :c,
      d: :e,
      d: :g,
      x: :k,
      x: :g,
      e: :x,
      e: :g
    ]
end
```
```
> MyFlow.permit(nil, :a)
:ok

> MyFlow.permit(:b, :e)
{:error, :transition_impossible}

> PicoSM.save_visualization(MyFlow, "./visualization.png")
:ok
```
Blue states are initial, red states are final.
![Visualization](./visualization.png)

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `pico_sm` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:pico_sm, "~> 0.1.0"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/pico_sm](https://hexdocs.pm/pico_sm).

