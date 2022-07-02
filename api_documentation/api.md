# API Documentation for Lua ECS

# ECS - Entity Component System

We must get the question "what is that?" out of the way. [You can read about that in the document I've prepared here.](https://github.com/jordan4ibanez/moongl_test/blob/main/api_documentation/what_is_ecs.md)


## ecs:new()

Creates a new ECS. A blank canvas for you to hold data.

```
my_component_system = ecs:new()
```

## ecs:add_component(component)

Creates a new component within the ECS. Component is a string which defines a table label for a series of data in which your entities will utilize.

```
my_component_system:add_component("life")
```

## ecs:add_components(component_table)

Lets you bulk add components with a table of strings.
```
my_component_system:add_components({"life", "friendly", "red"})
```

## ecs:get_component(component)

Let's you get a component of the entities. ``component`` is a string literal.

```
local life_component = my_component_system:get_component("life")
```

## ecs:add_entity(component_variable_table)

This is the method that allows you to store entities within your ECS. All undefined values are set to false as a place holder.

```
my_component_system:add_entity({
    life = 10,
    friendly = false,
    -- red will be false, it is undefined
})
```

## ecs:remove_entity(index)

Removes an entity from the ECS. Index is a number. It's best to let a system handle this rather than try to manually remove indexes.

