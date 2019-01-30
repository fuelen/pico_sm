defmodule PicoSM do
  @moduledoc """
  Documentation for PicoSM.
  """

  defmacro __using__(opts) do
    rules_list = Keyword.get(opts, :rules, [])

    quote do
      unquote do
        for {from_state, to_state} <- rules_list do
          quote do
            def permit(unquote(from_state), unquote(to_state)), do: :ok
          end
        end
      end

      def permit(_, _), do: {:error, :transition_impossible}

      def rules do
        unquote(rules_list)
      end
    end
  end

  def save_visualization(
        module,
        output_filename
      ) do
    dot_filename = System.tmp_dir!() |> Path.join("visualization.dot")

    output_filename = output_filename |> Path.expand()
    dot = convert_to_dot_notation(module.rules())
    File.write!(dot_filename, dot)
    IO.puts("Saving to #{output_filename}...")

    System.cmd("dot", [
      "-Tpng",
      dot_filename,
      "-o",
      output_filename,
      "-Gsize=9,15\!",
      "-Gdpi=400"
    ])

    File.rm(dot_filename)
  end

  def convert_to_dot_notation(rules) do
    {initializations, transitions} = rules |> Enum.split_with(fn {from, _to} -> is_nil(from) end)

    oriented_edges =
      transitions
      |> Enum.map(fn {from_state, to_state} -> "#{from_state} -> #{to_state}" end)

    initial_nodes =
      initializations |> Enum.map(fn {nil, to} -> "#{to} [style=filled, fillcolor=azure2]" end)

    statuses_to =
      rules
      |> Enum.map(fn {_from, to} -> to end)
      |> Enum.uniq()

    statuses_from =
      rules
      |> Enum.map(fn {from, _to} -> from end)
      |> Enum.uniq()

    final_statuses = statuses_to -- statuses_from

    final_nodes =
      final_statuses
      |> Enum.map(fn status -> "#{status} [style=filled, fillcolor=indianred1]" end)

    """
    digraph graphname {
      node [shape=record];
      rankdir="LR";
      #{oriented_edges |> Enum.join(";\n  ")}
      #{initial_nodes |> Enum.join(";\n  ")}
      #{final_nodes |> Enum.join(";\n  ")}
    }
    """
  end
end