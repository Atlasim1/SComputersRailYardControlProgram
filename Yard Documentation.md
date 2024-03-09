# YardDisplay Documentation

This file explains the structure of the data tables in YardDisplay.lua
## Flags

At the top of the `YardDisplay.lua` file, you will find many different flags that can modify the behavior of the program. Here is a list of flags with an explanation for each one and their default value:

| Flag                 | Behavior                                                                                                                                                                         | Default    |
| -------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---------- |
| DEBUG_CLICK_ECHO     | Debug Flag, outputs the location of display click in chat, useful when creating yard. Please note: Program **will crash** if debug messages are disabled in SComputers settings. | `false`    |
| BACKGROUND_COLOR     | Color of the screen background. string containing an HTML color code (Without the #)                                                                                             | `"111111"` |
| TRACK_COLOR          | Color of the yard's tracks.                                                                                                                                                      | `"ffffff"` |
| SWITCH_ENABLE_COLOR  | Color of the activated path of a switch                                                                                                                                          | `"ff0000"` |
| SWITCH_REGULAR_COLOR | Color of the disabled paths of a switch                                                                                                                                          | `"aaaaaa"` |
| TITLE_COLOR          | Color for the title text of the yard                                                                                                                                             | `"ffffff"` |
| SIGNAL_SCALE         | **==Do not use==** Changes the height and width of the signal's square                                                                                                           | `1`        |
| SIGNAL_COLOR_GREEN   | Technically not nessesary, is only used in the yard defenition, but is useful for modification : Color of the signal's green light                                               | `"47ba3a"` |
| SIGNAL_COLOR_RED     | Technically not nessesary, is only used in the yard defenition, but is useful for modification : Color of the signal's red light                                                 |            |
# Yard Appearance
Here are instructions on how to make a new yard
## Data Structure
Here is the data structure for the `currentYard` table. 
```lua
currentYard = {
	title = "string",
	tracks = {
		track = {c1 = {1,2}, c2 = {3,4}},
	},
	switches = {
		switch = {pos1 = {c1 = {1,2}, c2 = {3,4}}, pos2 = {c1 = {5,6}, c2 = {7,8}}}
	},
	signals = {
		signal = {pos = {1,2}, states = {
			state = "COLOR1"
		}}
	},
	textelements = {
		textelement = {
			pos = {1,2}
			text = "This is text"
			color = "COLOR1"
		}
	}
}
```
This table can be separated in 4 (5 if you count title) main sections : Tracks, Switches, Signals and Text Elements. 
### Tracks
the `tracks` table contains data for all of the tracks it contains other tables in the `track` data structure. : `track = {c1 = {1,2}, c2 = {3,4}}`
In this data structure, the `c#` tables stand for `Coordinate #` each of these coordinate tables contain 2 numbers : an X coordinate and a Y coordinate. The tracks are drawn as lines from the coordinates of `c1` to the coordinates of `c2`.
In this example : 
```lua
track = {c1 = {25,53}, c2 = {103,53}}
```
This would make a track going from x25, y53 to x103,y53.
The tracks are always colored based on the color set by the `TRACK_COLOR` flag.

You can put multiple `track` tables in the `tracks` table, however, they must be named diffrently. eg:
```lua
tracks = {
	track1 = {c1 = {1,2}, c2 = {3,4}},
	track2 = {c1 = {25,53}, c2 = {103,53}}
	},
```
you can see in this example that `track1` and `track2` are named diffrently
### Switches
The `switches` table contains data relating to switches' position in their different states it contains tables in this specific data structure : 
```lua
switch = {pos1 = {c1 = {1,2}, c2 = {3,4}}, pos2 = {c1 = {5,6}, c2 = {7,8}}}
```
each `switch` table contains a number of `pos` tables they do not have to be numbered, however there always needs to be a `pos1` table to act as a default.
each `pos` is a position (or state) that the switch can be in. The 2 `c#` coordinate tables inside the `pos` are the coordinates for the line of that specific state (refer to tracks section)
Example : 
```lua
switch1 = {pos1 = {c1={25,48},c2={20,48}}, pos2 = {c1={25,53},c2={20,48}}},
```
In the example above, we have a switch : `switch1` with 2 diffrent positions : `pos1` and `pos2` 
The first position `pos1` is a line going between coordinates `25,48` and `20,48`. `pos1` is always the default state, so it will be highlighted in red (or the color set by `SWITCH_ENABLE_COLOR`) during initialisation. The second position `pos2` is a line going between coordinates `25,53` and `20,48`. Just like in the `tracks` table, you can put multiple `switch` elements in the `switches` table, however they must be named diffrently
### Signals
The `signals` table contains data for all of the signals' positions and states. it contains `signal` tables following this data structure : 
```lua
signal = {pos = {1,2}, states = {
	state = "color",
```
the `pos` table contains the positon of the top-left corner of the signal, by default, the signals are 1 pixel only which means that the `pos` is the same as the position of the signal's single pixel, the signal's size can be changed using the `SIGNAL_SCALE` flag. the `signal` tables contain multiple `state` strings. a signal can have an infinite amount of states and they can be named completely randomly. however, there must always be a state named : `state1` for the machine to initialize. `state1` will be the default state of the signal. each state is a color (HTML Hex Color without the #) which corresponds to the color of the signal for that state.
Example : 
```lua
signal1 = {pos = {27,51}, states = {
	state1 = "47ba3a",
	state2 = "e63232",
}},
```
This signal is at the position 27,51 and has 2 states, in the default state (`state1`), the signal is colored green (#47ba3a) and in the second state, the signal is colored red (#e63232).

### Text Elements (and Title)
Title is a special element in the `currentYard` Table that defines the text shown in the top-left corner as a title. the title's color is defined by flag : `TITLE_COLOR` and is white by default
the `textelements` table contains a list of `text` tables, Here is their data structure : 
```lua
text1 = {
	pos = {1,2},
	text = "this is some text",
	color = "ffffff"
},
```
- `pos` is a table containing the coordinates of the text
- `text` defines the content of the text
- `color` defines the color of the text
In this example, this would put the text `this is some text` at coordinates: `1,2` in a white (`ffffff`) color

# Yard Interactions
Here are some instructions on how to make your yard actually work
## Data structure
Here is the data structure for the `yardInteractions` table:
```lua
yardInteractions = {
	interactions = { -- "accidental" extra boilerplate
		interaction1 = {
			hitbox = {c1 = {1,2}, c2 = {3,4}},
			execute = function(self)
				print("some code to run")
			end
		}
	}
}
```
Each `interaction` in `interactions` contains 2 required variables, `hitbox` and `execute`
- `hitbox` is a rectangle made by the coordinates `c1` and `c2`. if a click is detected inside this rectangle it will run the function in : `execute`
- `execute` is a function that will run when a click is detected inside the rectangle created by `hitbox`
 By default, the yard interaction script does not handle any state changing or behavior, it only runs the `execute()` function. Please keep in mind that it runs it like this : `interaction.execute(interaction)`. 
### `execute`
In the default yard, this is the code that is in the `execute` functions: (this example is for `signal4I`, Signal4 Interactions)
```lua
signal4I = {
	hitbox = {c1 = {26,50}, c2 = {28,52}},
	state = 1
	execute = function (self) -- when someone triggers the switch
		if self.state == 1 then -- if the switch is in state 1
			self.state = 2 -- change it to state 2 (internally only)
			updatesignal("signal4","state2") -- display the change on the monitor
			setreg("sig4",0) -- update the logic output too
		else -- if the switch is not in state 1 (is in state 2)
			self.state = 1 -- change it back to state 1
			updatesignal("signal4","state1") -- change monitor
			setreg("sig4",1) -- change logic output
		end
	end
}
```
The above code has been commented for better understanding.