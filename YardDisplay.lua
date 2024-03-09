-- Yard Management System
-- Made by Atlasim
-- Made to work with Display: (4x3)u (128x96)px
-- This code is awful
-- !! Documentation should be in the workshop Item Description (Link to github)

-- Debug Flags
DEBUG_CLICK_ECHO = false

-- Color Constants And Other Flags
BACKGROUND_COLOR = "111111"
TRACK_COLOR = "ffffff"
SWITCH_ENABLE_COLOR = "ff0000"
SWITCH_REGULAR_COLOR = "aaaaaa"
TITLE_COLOR = "ffffff"
SIGNAL_SCALE = 1
SIGNAL_COLOR_GREEN = "47ba3a"
SIGNAL_COLOR_RED = "e63232"

-- Display Initialisation
local display = getDisplays()[1] -- Get the main display
if display == nil then return end
display.clear(BACKGROUND_COLOR)
display.setClicksAllowed(true)

----------------------------
-- SECTION 1 : YARD DRAWING
----------------------------
-- c# = coordinate number #
-- Default switch state is always pos1
-- default signal state is always state1
-- YARD Definition as a table
local currentYard = {  -- Drawing Data
    title = "Demo Yard 1",
    tracks = {
        maintrack = {c1 = {0,48}, c2 = {128,48}},
        secondarytrack = {c1 = {25,53}, c2 = {103,53}},
    },
    switches = {
        switch1 = {pos1 = {c1={25,48},c2={20,48}}, pos2 = {c1={25,53},c2={20,48}}},
        switch2 = {pos1 = {c1={103,48},c2={108,48}}, pos2 = {c1={103,53},c2={108,48}}},
    },
    signals = {
        signal1 = {pos = {17,50}, states = {
            state1 = SIGNAL_COLOR_GREEN,
            state2 = SIGNAL_COLOR_RED,
        }},
        signal2 = {pos = {111,46}, states = {
            state1 = SIGNAL_COLOR_GREEN,
            state2 = SIGNAL_COLOR_RED,
        }},
        signal3 = {pos = {101,55}, states = {
            state1 = SIGNAL_COLOR_GREEN,
            state2 = SIGNAL_COLOR_RED,
        }},
        signal4 = {pos = {27,51}, states = {
            state1 = SIGNAL_COLOR_GREEN,
            state2 = SIGNAL_COLOR_RED,
        }},
        lightsignal1 = {pos = {5,48}, states = {
            state1 = SWITCH_REGULAR_COLOR,
            state2 = SWITCH_ENABLE_COLOR
        }}
    },
    textelements = {
        creditsL1 = {
            pos = {5,75},
            text = "Yard Manager Built by",
            color = TITLE_COLOR
        },
        creditsL2 = {
            pos = {5,83},
            text = "Atlasim",
            color = "34b4eb"
        }
    }
}

local function updateswitch(switch,position) -- Function that lets us change the *displayed* state of a switch
    for _,pos in pairs(currentYard.switches[switch]) do -- draw all positions as disabled
        display.drawLine(pos.c1[1],pos.c1[2],pos.c2[1],pos.c2[2],SWITCH_REGULAR_COLOR)
    end

    local selswt = currentYard.switches[switch]
    local selpos = selswt[position]
    display.drawLine(selpos.c1[1],selpos.c1[2],selpos.c2[1],selpos.c2[2],SWITCH_ENABLE_COLOR) -- draw enabled position over the disabled positions
end

local function updatesignal(signal, state)
    local selectedSignal = currentYard.signals[signal]
    display.fillRect(selectedSignal.pos[1], selectedSignal.pos[2], SIGNAL_SCALE, SIGNAL_SCALE, selectedSignal.states[state])
end

local function drawYard() -- Initialisation function to draw the yard
    -- Draw title
    display.drawText(5,5,currentYard.title,TITLE_COLOR)

    -- Draw Text Elements
    if currentYard.textelements then
        for _,textel in pairs(currentYard.textelements) do
            display.drawText(textel.pos[1], textel.pos[2], textel.text, textel.color)
        end
    end

    -- Draw Tracks
    for _,track in pairs(currentYard.tracks) do
        display.drawLine(track.c1[1],track.c1[2],track.c2[1],track.c2[2],TRACK_COLOR)
    end

    -- Draw Switches
    for _,switch in pairs(currentYard.switches) do
        for _,pos in pairs(switch) do -- Draw all switches, All states appear Disabled
            display.drawLine(pos.c1[1],pos.c1[2],pos.c2[1],pos.c2[2],SWITCH_REGULAR_COLOR)
        end
        display.drawLine(switch.pos1.c1[1],switch.pos1.c1[2],switch.pos1.c2[1],switch.pos1.c2[2],SWITCH_ENABLE_COLOR) -- Enable the default states
    end

    -- Draw Signals
    for _,signals in pairs (currentYard.signals) do
        display.fillRect(signals.pos[1], signals.pos[2], SIGNAL_SCALE, SIGNAL_SCALE, signals.states["state1"])
    end
end

----------------------------
-- SECTION 2 : INTERACTIONS
----------------------------

local yardInteractions = {   -- Interactions Data
    interactions = {
        switch1I = {
            hitbox = {c1 = {20,48}, c2 = {25,53}}, -- c1 : Corner1, c2 : Corner2 (of a rectangle hitbox)
            state = 1,
            execute = function(self)
                if self.state == 1 then  -- For toggle switch
                    self.state = 2  -- Change internal state
                    updateswitch("switch1","pos2")  -- change displayed state
                    setreg("pnt1",1)   -- change logic output for the real switch
                else
                    self.state = 1
                    updateswitch("switch1","pos1")
                    setreg("pnt1",0)
                end
            end,
        },
        switch2I = {
            hitbox = {c1 = {103,48}, c2 = {108,53}},
            state = 1,
            execute = function(self)
                if self.state == 1 then
                    self.state = 2
                    updateswitch("switch2","pos2")
                    setreg("pnt2",1)
                else
                    self.state = 1
                    updateswitch("switch2","pos1")
                    setreg("pnt2",0)
                end
            end,
        },
        signal1I = {
            hitbox = {c1 = {16,49}, c2 = {18,51}},
            state = 1,
            execute = function(self)
                if self.state == 1 then
                    self.state = 2
                    updatesignal("signal1","state2")
                    setreg("sig1",0)
                else
                    self.state = 1
                    updatesignal("signal1","state1")
                    setreg("sig1",1)
                end
            end
        },
        signal2I = {
            hitbox = {c1 = {110,45}, c2 = {112,47}},
            state = 1,
            execute = function (self)
                if self.state == 1 then
                    self.state = 2
                    updatesignal("signal2","state2")
                    setreg("sig2",0)
                else
                    self.state = 1
                    updatesignal("signal2","state1")
                    setreg("sig2",1)
                end
            end
        },
        signal3I = {
            hitbox = {c1 = {100,54}, c2 = {102,56}},
            state = 1,
            execute = function (self)
                if self.state == 1 then
                    self.state = 2
                    updatesignal("signal3","state2")
                    setreg("sig3",0)
                else
                    self.state = 1
                    updatesignal("signal3","state1")
                    setreg("sig3",1)
                end
            end
        },
        signal4I = {
            hitbox = {c1 = {26,50}, c2 = {28,52}},
            state = 1,
            execute = function (self)
                if self.state == 1 then
                    self.state = 2
                    updatesignal("signal4","state2")
                    setreg("sig4",0)
                else
                    self.state = 1
                    updatesignal("signal4","state1")
                    setreg("sig4",1)
                end
            end
        }
    }
}
-- FUNCTION TO GET INTERACTIONS
local function getinteraction(clickx,clicky)
    for _,interaction in pairs(yardInteractions.interactions) do
        if interaction.hitbox.c1[1] <= clickx and interaction.hitbox.c2[1] >= clickx and interaction.hitbox.c1[2] <= clicky and interaction.hitbox.c2[2] >= clicky then
            interaction.execute(interaction)
        end
    end
end

------------------
-- 3 : INTERRUPTS / Checks
------------------
-- !! NOT SUPPORTED !! 
local yardInterrupts = {
    traincoming1 = {
        execute = function ()
            if getreg("1") == 1 then
                updatesignal("lightsignal1","state2")
            else
                updatesignal("lightsignal1","state1")
            end
        end
    }
}


local function handleInterrupts()
    for _,interrupt in pairs(yardInterrupts) do
        interrupt.execute()
    end
end

---@diagnostic disable-next-line: lowercase-global -- Ignore this, it for my IDE
function callback_loop() -- Click interaction detection function and main loop
    handleInterrupts()
    local click = display.getClick()
    if click then
        if click[3] == "pressed" then
            if DEBUG_CLICK_ECHO == true then
                print("yesclick")
                print(click[1])
                print(click[2])
            end
            getinteraction(click[1],click[2])
            display.flush()
        end
    end
    display.clearClicks()
    if _endtick then
        display.clearClicks()
        display.clear()
        display.flush()
    end
end

-- CLick Interact Loop
local function clickInteract()
    callback_loop()
end

--------------------
-- TERMINAL INTERACTION CODE (UNUSED)
--------------------
-- The thing i used to get away from my problems has its own problems
Terminal = getComponents("terminal")[1]

local function terminalInteract() -- Unused
    local isRunning = true
    while isRunning do
        local inputcommand = Terminal.read()
        if inputcommand then
            print("it do")
            if inputcommand == "list" then
                Terminal.write("no i wont")
            end
            for _,interaction in pairs(yardInteractions.interactions) do
                if inputcommand == interaction then
                    interaction.execute()
                end
            end

        end
    end
end
---------------

-- Main Code
drawYard()
clickInteract()

display.flush() -- Send Data to Display
 