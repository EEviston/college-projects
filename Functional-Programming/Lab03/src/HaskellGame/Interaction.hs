module HaskellGame.Interaction where

import Prelude (
                Num(..), Eq(..), Show(..),
                Bool(..), Char(), Int(),
                (||), (.), otherwise, not, fst, snd
               )

import qualified System.Console.ANSI as Console
import qualified Data.List as List
import Data.List ((++), (!!), elem, any, filter, delete, null)

import HaskellGame.Datatypes
import HaskellGame.Graphics
import HaskellGame.Battle

{-
  Check if the player's new position would collide with something.
  Return True if there would be a collision.
  Return False if there would be no collision.
-}

detectCollision :: Scene -> Point -> Bool
detectCollision theScene (x, y) =
  let tile = ((contents (map theScene)) !! y) !! x
      objectPositions = List.map position (objects theScene)
      monsterPositions = List.map position (monsters theScene)
  in notWalkable tile || (any (== (x, y)) (objectPositions ++ monsterPositions))
  where
    notWalkable Grass = False
    notWalkable _     = True

{- Handle a key press from the player -}

handleInput :: Char -> Scene -> Scene
handleInput c theScene
  | c `elem` ['i', 'j', 'k', 'l'] = movePlayer c theScene
  | c == 'a'                      = doAttack theScene
  | otherwise                     = theScene
  where
    movePlayer :: Char -> Scene -> Scene
    movePlayer keyPressed oldScene =
      let (x, y) = position (player oldScene)
          newPosition = case keyPressed of
                          'i' -> (x, (y-1))
                          'j' -> ((x-1), y)
                          'k' -> (x, (y+1))
                          'l' -> ((x+1), y)
                          _   -> (x, y)
          newPlayer = (player oldScene) { pos = newPosition }
          isCollision = detectCollision oldScene newPosition
      in if isCollision then oldScene
         else oldScene {player = newPlayer}

missedMessage :: [Message]
missedMessage = [(Console.Red, "You flail wildly at empty space! Your attack connects with nothing.")]

hitMessage :: Monster -> Int -> Player -> Int -> [Message]
hitMessage monster monsterDamage player playerDamage =
  [(Console.Red, show monster ++ " hits " ++ show player  ++ " for " ++ show playerDamage  ++ " damage!"),
   (Console.Red, show player  ++ " hits " ++ show monster ++ " for " ++ show monsterDamage ++ " damage!")]

-- Calls 'fight' recursively for each monster
combat :: Int -> Player -> [Monster] -> [(Player, Monster)]
combat 0 _ [] = []
combat n p (x:xs) =
  let postFight = fight (p,x)  
  in postFight:(combat (n-1) (fst postFight) xs)


-- Compare player state to player in tuple and then use result as the start of comparison for rest of the tuples.
-- Compare old monster list to new monsters in the player, monster tuple.
-- After each comparison, add message describing damage taken and given by both player and monster.

--            combatList   woundedPlayer  woundedMons
getMessages :: [Monster] -> [Player] -> [Monster] -> [Message]
getMessages [] (q:[]) [] = []
getMessages (m:ms) (p:q:ps) (x:xs) =
  let 
    mDamage = (health m - health x)

    pDamage = (health p - health q)
    messageList = hitMessage m mDamage p pDamage
    in messageList ++ (getMessages ms (q:ps) xs)
    --in messageList:(getMessages (m-1:ms) (p-1:ps) (x-1:xs))

getMonsterDamage :: Monster -> Player -> Int
getMonsterDamage m p = 
  let
    mDamage = (health m - health p)
    in mDamage



doAttack :: Scene -> Scene
doAttack (Scene map p obj mons msgs) =
  let
    distanceList = List.map (distance p) mons -- list of distances between player and all mons

    monIndex = List.findIndices (==1) distanceList -- find which monsters are nearby
    in
    if (monIndex == []) then 
      let missMsgList = msgs ++ missedMessage
      in (Scene map p obj mons missMsgList)

    else
      let
        combatList = List.map (mons!!) monIndex   -- give a list of these nearby mons

        combatListLength = List.length combatList

        fightList = combat combatListLength p combatList -- make these nearby mons fight with the player

        lastElem = List.last(fightList)                -- get last element of results so we can get latest player state
        finalP = fst(lastElem)
        finalM = snd(lastElem)

        woundedMons = List.map (snd) fightList        -- list of updated monster states
        woundedPlayer = List.map (fst) fightList  -- list of updated player states
        farawayMons = mons List.\\ combatList     -- list of monsters who never engaged in battle

        finalMons = farawayMons ++ woundedMons    -- adding the two lists to get the new final updated list of monsters.
        finalPlist = [p] ++ woundedPlayer

        pDamage = (health p - health finalP)
        mDamage = (health (List.last combatList) - health finalM)


        firstElem = List.head(fightList)
        firstM = snd(firstElem)


        firstMdamage = getMonsterDamage firstM p

        firstPdamage = health p - health (woundedPlayer!!0)
        firstPmessage = hitMessage firstM firstPdamage p firstMdamage

        hitMsgResult = getMessages combatList finalPlist woundedMons 

        --hitMsgResult = hitMessage finalM mDamage finalP pDamage
      in (Scene map finalP obj finalMons (msgs ++ hitMsgResult))