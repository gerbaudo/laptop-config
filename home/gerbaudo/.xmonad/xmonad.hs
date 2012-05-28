import XMonad
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.ManageHelpers
import XMonad.Layout.NoBorders
import XMonad.Layout.Gaps
import XMonad.Layout.Spiral
import qualified XMonad.StackSet as W
import XMonad.Util.EZConfig
import XMonad.Util.Run
import System.IO

mylayoutHook = spiral (6/7) ||| Mirror tiled ||| Full
               where tiled = Tall 1 0.03 0.5 
-- mylayoutHook = Mirror tiled ||| Full
--                where tiled = Tall 1 0.03 0.5 

mymanageHook :: ManageHook
mymanageHook = composeAll
                [ className =? "Kruler" --> doFloat
				, manageDocks]
myWorkspaces = ["1:main","2:trig","3:hist","4:asym","5:media","6","7","8:irc"]

--xmproc <- spawnPipe "/usr/bin/trayer --edge top --align right --SetDockType true --SetPartialStrut true --expand true --width 6 --transparent true --alpha 0 --tint 0x000000 --height 16"
main = do
xmproc <- spawnPipe "/usr/bin/xmobar /home/gerbaudo/.xmonad/xmobar.config"
xmonad $ defaultConfig
       { terminal = "konsole"
       , modMask = mod4Mask
       , borderWidth = 0
       , workspaces = myWorkspaces
       -- , layoutHook = mylayoutHook
       -- , manageHook = mymanageHook
       , manageHook = manageDocks <+> manageHook defaultConfig
       , layoutHook = avoidStruts $ layoutHook defaultConfig
       , startupHook = do spawn ". ~/.xmodmap"
                       >> spawn "/usr/bin/trayer --edge top --align right --SetDockType true --SetPartialStrut true --expand true --width 6 --transparent true --alpha 0 --tint 0x000000 --height 16"
       , logHook = dynamicLogWithPP xmobarPP
                 { ppOutput = hPutStrLn xmproc
                 , ppTitle = xmobarColor "blue" "" . shorten 50
                 , ppLayout = const "" -- to disable the layout info on xmobar
                 }
       }
       `additionalKeys` -- myKeys
        [((mod1Mask .|. controlMask, xK_l), spawn "slock")] --
--        ++
--        [ (otherModMasks ++ "M-" ++ [key], action tag)
--          | (tag, key)  <- zip myWorkspaces "12345678"
--        , (otherModMasks, action) <- [ ("", windows . W.view) -- was W.greedyView
--                                       , ("S-", windows . W.shift)]
--        ]
