{-- TodoList is a simple todolist editor cli app 
 - first compile the code :  ghc --make todo.hs
 - usage:
 - ./todo view todo.txt  ( shows the todo.txt)
 - ./todo add todo.txt "Programmer some haskell"  (adds an todo item)
 - ./todo remove todo.txt 2 			  ( removes line 2 of todo.txt)
--}

import System.Environment
import System.Directory
import System.IO
import Data.List

dispatch :: [(String, [String] -> IO ())]
dispatch =  [ ("add", add)
            , ("view", view)
            , ("remove", remove)
	    , ("search",search)
            ]
 
main = do
    (command:args) <- getArgs
    let (Just action) = lookup command dispatch
    action args

add :: [String] -> IO ()
add [fileName, todoItem] = appendFile fileName (todoItem ++ "\n")

view :: [String] -> IO ()
view [fileName] = do
    contents <- readFile fileName
    let todoTasks = lines contents
        numberedTasks = zipWith (\n line -> show n ++ " - " ++ line) [0..] todoTasks
    putStr $ unlines numberedTasks


remove :: [String] -> IO ()
remove [fileName, numberString] = do
    handle <- openFile fileName ReadMode
    (tempName, tempHandle) <- openTempFile "." "temp"
    contents <- hGetContents handle
    let number = read numberString
        todoTasks = lines contents
        newTodoItems = delete (todoTasks !! number) todoTasks
    hPutStr tempHandle $ unlines newTodoItems
    hClose handle
    hClose tempHandle
    removeFile fileName
    renameFile tempName fileName

search :: [String] -> IO ()
search [fileName,keyword] = do
	contents <- readFile fileName
	let todoTasks = filter (keyword `isInfixOf`) (lines contents)
	putStr $ unlines todoTasks 

replace :: [String] -> IO ()
replace [fileName,numberString,newLine] = do
	remove [fileName,numberString]
	add [fileName,newLine]
