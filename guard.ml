open Unix
open Sys

let run_prog (prog : string) : bool =
    match system prog with
    | WEXITED n when n = sigint || n = sigkill -> false
    | WEXITED 127 -> false
    | _ -> true

let delay = ref 0.

let loop_prog (prog : string) =
    while run_prog prog do
        (* restarting *)
        match !delay with
        | 0. -> ()
        | n ->
            sleepf n
    done; exit 0

let daemonize () =
    match fork () with
    | 0 ->
        begin
            let out = openfile "guard.out" [O_CREAT; O_WRONLY] 0o755 in
            let _ = dup2 out stdout in
            let _ = dup2 out stderr in
            let _ = close stdin in
            let _pid = setsid() in
            let _ = print_endline (string_of_int _pid) in
            Sys.set_signal Sys.sighup Sys.Signal_ignore;
            Sys.set_signal Sys.sigpipe Sys.Signal_ignore;
        end
    | _ -> exit 0

let args = [
    "-delay", Arg.Set_float delay, "Delay between restarts";
    "-detach", Arg.Unit daemonize, "Detach process from current shell";
    "-watch", Arg.String loop_prog, "Run shell command"
]

let _ =
let main () =
    let rest = ref [] in
    let _ = Arg.parse args (fun s ->
        rest := !rest @ [s]
    ) "guard" in
    loop_prog (String.concat " " !rest)
in main ()
