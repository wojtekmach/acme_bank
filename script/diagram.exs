deps = Mix.Dep.loaded([]) |> Enum.filter(& &1.top_level)

fun = fn dep, deps ->
  dep = Enum.find(deps, & &1.app == dep.app)
  children = Enum.filter(dep.deps, & Keyword.get(&1.opts, :in_umbrella))
  {{dep.app, nil}, children}
end

dep = Enum.at(deps, -1)

Mix.Utils.print_tree([dep], fn dep -> fun.(dep, deps) end)
Mix.Utils.write_dot_graph!("tmp/diagram.dot", "deps", [dep], fn dep -> fun.(dep, deps) end)

System.cmd("dot", ["-Tpng", "tmp/diagram.dot", "-odocs/diagram.png"])
