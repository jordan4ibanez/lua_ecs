require("ecs")
--[[
OR do a dofile
dofile("ecs.lua")
]]--

local my_component_system = ecs:new()

my_component_system:add_component("life")

-- even though we have defined life twice, this secondary attempt will be ignored
my_component_system:add_components({
    "life",
    "evil",
    "red",
    "name"
})


-- let's add some entities
my_component_system:add_entity({
    name = "frank",
    life = 10,
    evil = true,
    red = true
})

my_component_system:add_entity({
    name = "johnny",
    life = 2,
    evil = false,
})

my_component_system:add_entity({
    name = "vinny",
    life = 234324,
})

-- you can also dump an entity in that is completely blank
my_component_system:add_entity({})

-- okay, let's see what we've got here
-- now let's print it
print(dump_ecs(my_component_system))

-- let's remove jonny from the ecs, normally a system will handle this, but this is just a tutorial
my_component_system:remove_entity(2)

-- some useful seperation of the ecs dumps
print("JONNY'S OUT OF THERE!\n")

-- now let's print it
print(dump_ecs(my_component_system))

--[[
if you take a look at the debug print, every entity after jonny has suddenly dropped down to replace him

this is a useful built in lua component to ensure that tables utilizing the table class for insertions and deletions stay synced

this is also extremely useful for this current scenario, as we can add and remove entities to our heart's content
]]--


-- let's throw jonny back in, but this time, his health is depleted
my_component_system:add_entity({
    name = "johnny",
    life = 0,
    evil = false,
})

-- more debug
print("JONNY'S BACK IN BOI!\n")

-- let's take another look
print(dump_ecs(my_component_system))

--[[
this time, jonny's at the end. this is because the order of the entities do not matter in an ecs

the only thing that matters is that their components stay synced!
]]--

-- okay, now let's write a basic system

print("BEGINNING SYSTEM TEST!\n")

local function check_who_died()

    -- we can hook table pointers into locals for performance, fancy
    local life = my_component_system:get_component("life")
    local name = my_component_system:get_component("name")

    -- entity component systems utilizing this class have a built in feature, they count their entities
    local entity_count = my_component_system.entity_count

    -- now let's run through the life component, to see who is dead
    for i = 1,entity_count do
        --[[
        because you might have a combat system which can turn an enemies health negative, utilize <= just in case

        also because lua is weakly typed, we must simply ensure that the type in the slot is a number

        this is also why there is a blank entity inserted into the ecs earlier, it's health is false, aka, immortal
        ]]--
        if type(life[i]) == "number" and life[i] <= 0 then
            -- now we can utilize only the required data to display who is dead
            print(tostring(name[i]) .. " has perished!!")
        end
    end
end

-- now let's run our system
check_who_died()

--[[
welp, see you later jonny, he has perished.

it's that simple. the ecs is components and systems. you're focusing on data over objects

I think it's pretty neat, hopefully this little library helps you out in your endevors
]]