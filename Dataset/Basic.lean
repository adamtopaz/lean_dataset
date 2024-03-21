import Lean

open Lean

structure Dataset (P : Type) (M : Type → Type) [Monad M] where
  len : M Nat
  getItem : Nat → M Json
  runWith : P → M α → IO α

def Dataset.run {P : Type} {M : Type → Type} [Monad M] [MonadLift IO M] (param : P) (D : Dataset P M) :
    IO UInt32 :=
    D.runWith param do
  let stdin ← IO.getStdin
  let stdout ← IO.getStdout
  let initialMetadata : Json := .mkObj [
    ("len", ← D.len)
  ]
  stdout.putStrLn initialMetadata.compress
  stdout.flush
  let mut line := ""
  while true do
    line ← stdin.getLine
    if line.trim == "QUIT" then break
    let .ok req := Json.parse line |
      (throw <| IO.userError "ERROR" : IO _)
    let .ok idx := req.getObjValAs? Nat "index" |
      (throw <| IO.userError "Index error" : IO _)
    let res : Json := toJson <| ← D.getItem idx
    stdout.putStrLn res.compress
    stdout.flush
  return 0
