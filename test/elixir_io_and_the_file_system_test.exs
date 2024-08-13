defmodule IoAndFileSystemTest do
  use ExUnit.Case
  import ExUnit.CaptureIO

  describe "IO module" do
    test "writes to standard output" do
      assert capture_io(fn -> IO.puts("hello world") end) == "hello world\n"
    end

    test "reads from standard input" do
      assert capture_io("yes\n", fn ->
               assert IO.gets("yes or no? ") == "yes\n"
             end)
    end

    test "writes to standard error" do
      assert capture_io(:stderr, fn -> IO.puts(:stderr, "error message") end) == "error message\n"
    end
  end

  describe "File module" do
    setup do
      path = "test_file.txt"
      on_exit(fn -> File.rm(path) end)
      {:ok, path: path}
    end

    test "writes and reads a file in binary mode", %{path: path} do
      {:ok, file} = File.open(path, [:write])
      assert IO.binwrite(file, "world") == :ok
      assert File.close(file) == :ok

      assert File.read(path) == {:ok, "world"}
    end

    test "reads a file with the bang function", %{path: path} do
      File.write!(path, "hello")
      assert File.read!(path) == "hello"
    end

    test "handles error with File.read" do
      assert File.read("non_existent_file.txt") == {:error, :enoent}
    end

    test "raises error with File.read!" do
      assert_raise File.Error, fn -> File.read!("non_existent_file.txt") end
    end
  end

  describe "Path module" do
    test "joins paths correctly" do
      assert Path.join("foo", "bar") == "foo/bar"
    end

    test "expands paths correctly" do
      assert Path.expand("~/hello") == Path.join(System.user_home!(), "hello")
    end
  end

  describe "iodata and chardata" do
    test "writes iodata" do
      name = "Mary"
      assert capture_io(fn -> IO.puts(["Hello ", name, "!"]) end) == "Hello Mary!\n"
    end

    test "writes chardata with integers" do
      assert capture_io(fn -> IO.puts([?O, ?l, ?á, ?\s, "Mary", ?!]) end) == "Olá Mary!\n"
    end

    test "handles nested iodata" do
      assert capture_io(fn -> IO.puts(["apple", [",", "banana", [",", "lemon"]]]) end) ==
               "apple,banana,lemon\n"
    end
  end
end
