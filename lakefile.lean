import Lake
open Lake DSL

package «lean_dataset» where
  -- add package configuration options here

lean_lib «LeanDataset» where
  -- add library configuration options here

@[default_target]
lean_exe «lean_dataset» where
  root := `Main
