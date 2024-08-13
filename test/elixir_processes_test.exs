defmodule ProcessTest do
  use ExUnit.Case

  defmodule KV do
    def start_link do
      Task.start_link(fn -> loop(%{}) end)
    end

    defp loop(map) do
      receive do
        {:get, key, caller} ->
          send(caller, Map.get(map, key))
          loop(map)

        {:put, key, value} ->
          loop(Map.put(map, key, value))
      end
    end
  end

  test "spawning a process" do
    {pid, ref} = spawn_monitor(fn -> 1 + 2 end)
    assert_receive {:DOWN, ^ref, :process, ^pid, _reason}
    assert Process.alive?(pid) == false
  end

  test "retrieving current process PID" do
    pid = self()
    assert Process.alive?(pid)
  end

  test "sending and receiving messages" do
    send(self(), {:hello, "world"})

    received_message =
      receive do
        {:hello, msg} -> msg
        {:world, _msg} -> "won't match"
      end

    assert received_message == "world"
  end

  test "receiving message with timeout" do
    result =
      receive do
        {:hello, msg} -> msg
      after
        1_000 -> "nothing after 1s"
      end

    assert result == "nothing after 1s"
  end

  test "sending messages between processes" do
    parent = self()
    spawn(fn -> send(parent, {:hello, self()}) end)

    received_message =
      receive do
        {:hello, pid} -> "Got hello from #{inspect(pid)}"
      end

    assert String.starts_with?(received_message, "Got hello from #PID<")
  end

  test "process spawned with spawn/1 fails without affecting the parent process" do
    Process.flag(:trap_exit, true)

    spawn(fn ->
      try do
        raise "oops"
      catch
        _, _ -> exit(1)
      end
    end)

    refute_receive {:EXIT, _pid, _reason}, 500
  end

  test "spawning a linked process and handling failure" do
    Process.flag(:trap_exit, true)

    spawn_link(fn ->
      try do
        raise "oops"
      catch
        _, _ -> exit(1)
      end
    end)

    assert_receive {:EXIT, _pid, _reason}
  end

  test "task raises an exception" do
    {pid, ref} =
      spawn_monitor(fn ->
        Task.start(fn ->
          try do
            raise "oops"
          catch
            _, _ -> :ok
          end
        end)
      end)

    assert_receive {:DOWN, ^ref, :process, ^pid, reason}
    assert reason == :normal
    refute_receive {:EXIT, _pid, _reason}, 500
  end

  # test "task start_link process and handling failure" do
  #   Process.flag(:trap_exit, true)

  #   Task.start_link(fn ->
  #     try do
  #       raise "oops"
  #     catch
  #       _, _ -> exit(1)
  #     end
  #   end)

  #   assert_receive {:EXIT, _pid, _reason}
  # end

  test "creating a simple key-value store with processes" do
    {:ok, pid} = KV.start_link()

    send(pid, {:put, :hello, :world})
    send(pid, {:get, :hello, self()})

    received_value =
      receive do
        :world -> :world
      end

    assert received_value == :world
  end

  test "registering a process and interacting with it by name" do
    {:ok, pid} = KV.start_link()
    Process.register(pid, :kv)

    send(:kv, {:put, :hello, :world})
    send(:kv, {:get, :hello, self()})

    received_value =
      receive do
        :world -> :world
      end

    assert received_value == :world
  end
end
