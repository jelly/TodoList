{-- An simple todolist manager: 
 - Planned features : replace , prioritise
 --}

module Main( main ) where

import System.Environment
import System.Directory
import System.Console.GetOpt
import System.IO
import Data.Maybe( fromMaybe )
import Data.List
import System.Exit

fileName="/home/jelle/todo"

main = do
  args <- getArgs
  let ( actions, nonOpts, msgs ) = getOpt RequireOrder options args
  opts <- foldl (>>=) (return defaultOptions) actions
  let Options { optInput = input,
                optOutput = output } = opts
  input >>= output

data Options = Options  {
    optInput  :: IO String,
    optOutput :: String -> IO ()
  }

defaultOptions :: Options
defaultOptions = Options {
    optInput  = getContents,
    optOutput = putStr
  }

--cli options 
options :: [OptDescr (Options -> IO Options)]
options = [
    Option ['h'] ["help"]    (NoArg showHelp) "show help",
    Option ['v'] ["view"]     (NoArg view ) "view todoList",
    Option ['a'] ["add"]     (ReqArg add "todo" ) "add item to todolist",
    Option ['r'] ["remove"]  (ReqArg remove "lineNumber" ) "remove item from list",
    Option ['s'] ["search"]  (ReqArg search "keyword") "search you todo items",
    Option ['V'] ["version"] (NoArg showVersion)         "show version number"
  	  ]

--show the version of the porgram
showVersion _ = do
  putStrLn "TodoListEditor version 0.1"
  exitWith ExitSuccess

--show usage
showHelp _ = do
  putStrLn "Usage: [-vio] Args"
  exitWith ExitSuccess

--View the todo list
view _ =  do
    contents <- readFile fileName
    let todoTasks = lines contents
        numberedTasks = zipWith (\n line -> show n ++ " - " ++ line) [0..] todoTasks
    putStr $ unlines numberedTasks 
    exitWith ExitSuccess

--Add an todo item
add args opt = do 
	appendFile fileName (args ++ "\n")
	exitWith ExitSuccess	

--Remove an todo item
remove args opt = do
	handle <- openFile fileName ReadMode
	(tempName, tempHandle) <- openTempFile "." "temp"
	contents <- hGetContents handle
	let number = read args :: Int
            todoTasks = lines contents
            newTodoItems = delete (todoTasks !! number) todoTasks
	hPutStr tempHandle ( unlines newTodoItems )
	hClose handle
	hClose tempHandle
	removeFile fileName
	renameFile tempName fileName
	exitWith ExitSuccess	

--Search an todo item
search args opt = do
	contents <- readFile fileName
	let todoTasks = filter (args `isInfixOf`) (lines contents)
	putStr ( unlines todoTasks )
	exitWith ExitSuccess	
