
-- lua locals
local table_remove, table_insert
=
      table.remove, table.insert


-- helper function

local function contains(table, value)
    for _,key in ipairs(table) do
        if key == value then
            return true
        end
    end
    return false
end

-- ecs base class

ecs = {}

local id = 0

-- constructor

function ecs:new(object)
    object = object or {}

    object.entity_count = 0

    object.id = id

    object.component_list = {}

    id = id + 1

    setmetatable(object, self)

    self.__index = self

    return object
end

-- component addons

function ecs:add_component(component)

    assert(component ~= "entity_count", "entity_count is a reserved key word for ecs")
    assert(component ~= "id", "id is a reserved key word for ecs")
    assert(type(component) == "string", "ecs key word must be a string")
    assert(component ~= nil, "nil keyword for ecs")

    -- only allow new components
    if not contains(self.component_list, component) then
        self[component] = {}
        table_insert(self.component_list, component)
    end
end

-- bulk component addons

function ecs:add_components(component_table)

    local inernal_component_list = self.component_list

    for _,component in ipairs(component_table) do

        assert(component ~= "entity_count", "entity_count is a reserved key word for ecs")
        assert(component ~= "id", "id is a reserved key word for ecs")
        assert(type(component) == "string", "ecs key word must be a string")
        assert(component ~= nil, "nil keyword for ecs")

        if not contains(inernal_component_list, component) then
            self[component] = {}
            table_insert(inernal_component_list, component)
        end
    end
end

-- allows you to get the component table

function ecs:get_component(component)
    if contains(self.component_list, component) then
        return self[component]
    else
        return nil
    end
end

-- entity creation system

function ecs:add_entity(component_variable_table)

    -- skip having to count internal tables

    self.entity_count = self.entity_count + 1

    -- dynamic calculation of missing variables

    for _,key in ipairs(self.component_list) do

        local new_value = component_variable_table[key]

        -- undefined - false

        if new_value == nil then
            new_value = false
        end

        table_insert(self[key], new_value)
    end
end

-- entity destruction system
function ecs:remove_entity(index)

    -- do not allow removing nil entity

    local internal_component_list = self.component_list

    assert(self[internal_component_list[1]][index] ~= nil, "Tried to remove nil entity!")

    for _,key in ipairs(internal_component_list) do
        table_remove(self[key], index)
    end

    self.entity_count = self.entity_count - 1
end

function dump_ecs(entity_component_system)

	-- don't try to print ecs if no entities

	if entity_component_system.entity_count <= 0 then
		print("No entities defined")
		return
	end

	-- run through each entity, assemble it into debug string

	for i = 1,entity_component_system.entity_count do

		local entity_print_string = "[entity " .. tostring(i) .. "]"

		for _,key in ipairs(entity_component_system.component_list) do

			entity_print_string = entity_print_string .. " " .. key .. ": "

			entity_print_string = entity_print_string .. tostring(entity_component_system[key][i]) .. " |"

		end

		print(entity_print_string)
	end
end