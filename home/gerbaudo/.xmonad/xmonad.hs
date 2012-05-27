import XMonad
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import XMonad.Layout.Spiral
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
myWorkspaces = ["1:main","2:chat","3","whatever","5:media","6","7","8:web"]

main = do
xmproc <- spawnPipe "/usr/bin/xmobar /home/gerbaudo/.xmonad/xmobar.config"
xmproc <- spawnPipe "/usr/bin/trayer --edge top --align right --SetDockType true --SetPartialStrut true --expand true --width 6 --transparent true --alpha 0 --tint 0x000000 --height 16"
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
	   , logHook = dynamicLogWithPP xmobarPP
	   	 { ppOutput = hPutStrLn xmproc
		 , ppTitle = xmobarColor "blue" "" . shorten 50
		 , ppLayout = const "" -- to disable the layout info on xmobar
		 }
       }
       `additionalKeys`  [ ((mod1Mask .|. controlMask, xK_l), spawn "slock") ]
