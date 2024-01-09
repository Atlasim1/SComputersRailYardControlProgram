-- Yard Management System
-- Made to work with Display: (4x3)u (128x96)px



-- color constants
BACKGROUND_COLOR = "111111"
TRACK_COLOR = "ffffff"
SWITCH_ENABLE_COLOR = "ff0000"
SWITCH_REGULAR_COLOR = "aaaaaa"
TITLE_COLOR = "ffffff"
SIGNAL_SCALE = 1

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
-- YARD Definition as a table (Kinda like JSON)
local currentYard = {
    title = "YARD1",
    tracks = {
        maintrack = {c1 = {0,48,}, c2 = {128,48}},
        secondarytrack = {c1 = {25,53}, c2 = {103,53}},
    },
    switches = {
        switch1 = {pos1 = {c1={25,48},c2={20,48}}, pos2 = {c1={25,53},c2={20,48}}},
        switch2 = {pos1 = {c1={103,48},c2={108,48}}, pos2 = {c1={103,53},c2={108,48}}},
    },
    signals = {
        signal1 = {pos = {17,50}, states = {
            state1 = "47ba3a",
            state2 = "e63232",
        }},
        signal2 = {pos = {111,46}, states = {
            state1 = "47ba3a",
            state2 = "e63232",
        }},
        signal3 = {pos = {101,55}, states = {
            state1 = "47ba3a",
            state2 = "e63232",
        }},
        signal4 = {pos = {27,51}, states = {
            state1 = "47ba3a",
            state2 = "e63232",
        }}
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
    -- write title
    display.drawText(5,5,currentYard.title,TITLE_COLOR)

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


local yardInteractions = {
    interactions = {
        switch1I = {
            hitbox = {c1 = {20,48}, c2 = {25,53}},
            state = 1,
            execute = function(self)
                if self.state == 1 then
                    self.state = 2
                    updateswitch("switch1","pos2")
                else
                    self.state = 1
                    updateswitch("switch1","pos1")
                end
            end,
        },
        switch2I = {
            hitbox = {c1 = {}, c2 = {}},
            state = 1,
            execute = function(self)
                if self.state == 1 then
                    self.state = 2
                    updateswitch("switch2","pos2")
                else
                    self.state = 1
                    updateswitch("switch2","pos1")
                end
            end,
        }
    }
}

local function getinteraction(clickx,clicky)
    for _,interaction in pairs(yardInteractions.interactions) do
        if interaction.hitbox.c1[1] <= clickx and interaction.hitbox.c2[1] >= clickx and interaction.hitbox.c1[2] <= clicky and interaction.hitbox.c2[2] >= clicky then
            interaction.execute()
        end
    end
end

-- Contains Testing
drawYard()
updateswitch("switch1","pos2")
updatesignal("signal1","state2")
getinteraction()


local click = display.getClick()
getinteraction(click[1],click[2])


display.flush() -- Send Data to Display
