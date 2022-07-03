
-- lua locals
local table_remove, table_insert
=
      table.remove, table.insert


-- ecs base class

ecs = {}

local id = 0

-- constructor

function ecs:new(object)
    object = object or {}

    object.entity_count = 0

    object.id = id

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



    if not self[component] then
        self[component] = {}
    end
end

-- bulk component addons

function ecs:add_components(component_table)
    for key,value in pairs(component_table) do

        assert(value ~= "entity_count", "entity_count is a reserved key word for ecs")

        assert(value ~= "id", "id is a reserved key word for ecs")

        assert(type(value) == "string", "ecs key word must be a string")

        assert(value ~= nil, "nil keyword for ecs")

        if not self[value] then
            self[value] = {}
        end
    end
end

-- allows you to get the component table

function ecs:get_component(component)
    if self[component] then
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

    for key,_ in pairs(self) do

        -- don't utilize ecs builder

        if key ~= "entity_count" and key ~= "id" then

            local new_value = component_variable_table[key]

            -- undefined - false

            if new_value == nil then
                new_value = false
            end

            table_insert(self[key], new_value)

        end
    end
end

-- entity destruction system
function ecs:remove_entity(index)

    -- do not allow out of bounds

    assert(index <= self.entity_count and index > 0, "trying to remove entity that does not exist!")

    for key,table in pairs(self) do
        if key ~= "entity_count" and key ~= "id" then
            table_remove(table, index)
        end
    end

    self.entity_count = self.entity_count - 1
end

function dump_ecs(entity_component_system)

	-- don't try to print ecs if no entities

	if entity_component_system.entity_count <= 0 then
		print("No entities defined")
		return
	end

	-- preassemble the components of the ecs

	local key_dump = {}

	for key,_ in pairs(entity_component_system) do
		if key ~= "entity_count" and key ~= "id" then
			table_insert(key_dump, key)
		end
	end

	-- run through each entity, assemble it into debug string

	for i = 1,entity_component_system.entity_count do

		local entity_print_string = "[entity " .. tostring(i) .. "]"

		for _,value in ipairs(key_dump) do

			entity_print_string = entity_print_string .. " " .. value .. ": "

			entity_print_string = entity_print_string .. tostring(entity_component_system[value][i]) .. " |"

		end

		print(entity_print_string)
	end
end