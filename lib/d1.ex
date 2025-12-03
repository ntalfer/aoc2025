defmodule D1 do
  def p1(file) do
    file
    |> parse_file
    |> Enum.reduce({0, 50}, fn val, {count, curr} ->
      curr2 = rem(curr + val + 100, 100)

      count2 =
        case curr2 do
          0 -> count + 1
          _ -> count
        end

      {count2, curr2}
    end)
    |> elem(0)
  end

  def p2(file) do
    file
    |> parse_file
    |> Enum.reduce({0, 50}, fn val, {count, curr} ->
      curr2 = Integer.mod(curr + val, 100)
      count2 = count + count_zero_crossings(curr, val)
      {count2, curr2}
    end)
    |> elem(0)
  end

  defp count_zero_crossings(start, delta) do
    if delta == 0 do
      0
    else
      end_pos = Integer.mod(start + delta, 100)
      abs_delta = abs(delta)

      complete_rotations = div(abs_delta, 100)

      # Check if partial rotation crosses 0
      # We cross 0 if we wrap around, but not if we start at 0 (unless we end at 0)
      partial_cross =
        cond do
          end_pos == 0 -> 1
          start == 0 -> 0
          delta > 0 -> if start + rem(delta, 100) >= 100, do: 1, else: 0
          delta < 0 -> if start - rem(abs_delta, 100) < 0, do: 1, else: 0
        end

      complete_rotations + partial_cross
    end
  end

  defp parse_file(file) do
     file
    |> File.read!()
    |> String.split()
    |> Enum.map(&parse_line/1)
  end

  defp parse_line(line) do
    <<dir, count::binary>> = line
    factor =
     case dir do
        ?L -> -1
        ?R -> 1
     end
     factor * String.to_integer(count)
  end
end
