defmodule Wex.Web.Rest.ProcessInfo do

  use Wex.Web.Rest.Restful
  import Util.Type.AddTypes, only: [add_types: 1]

  with_param(:pid) do
    pid
    |> strip_elixir_inspect_prefix
    |> String.to_char_list
    |> :erlang.list_to_pid
    |> Process.info
    |> translate_initial_call
    |> add_types
  end

  defp strip_elixir_inspect_prefix("#PID" <> pid), do: pid
  defp strip_elixir_inspect_prefix(pid),           do: pid

  defp translate_initial_call(info) do
    Keyword.update!(info, :initial_call,
      fn({:proc_lib, :init_p, _}) -> :proc_lib.translate_initial_call(info)
        (mfa)                     -> mfa
      end)
  end

end
