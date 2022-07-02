# What is an ECS? Entity Component System

An entity component system is an architectural pattern designed to allow limitless,functional, and fast access to data. This data is commonly broken down into two catagories. Components and systems. This is the most powerful class shipped with the engine.

## Components

Components are the base of what makes the ECS work. You can think of the ECS as a database for data. Each of these components represent an ``entity`` implicitly. There are no actual entities, only data in which give the entities existence. An ``entity`` is simply a piece of data which represents something in memory.

Take the following simple example of a traditional object oriented Lua object into consideration:

```
entity_holder = {
    my_entity_1 = {
        life = 10,
        name = "jeff"
    },
    my_entity_2 = {
        life = 8,
        name = "frank"
    }
}
```

You can see that each entity is represented as a sub table from the base table which is ``entity_holder``. The data in which represents them are contained within themselves. This is fantastic for smaller programs which do very basic things with them. But when you begin to have hundreds of entities, things like name comparisons, collision detection, seeing what's alive or dead, etc, become monumentally more expensive. It becomes more expensive not because the design pattern in which this utilizes is inherently wrong. It is because the bridge between your ``CPU`` and ``RAM`` become an immense bottleneck. This becomes accentuated further by the need for your ram to lookup the address that the Lua VM is asking for.


Now let's take a look at the following simple example of an ECS holding the same data:

```
entity_holder = {
    life = {  10,     8      },
    name = { "jeff", "frank" }
}
```

As you can see, this is much cleaner. Jeff and Frank do not actually exist, but we could make them back into the object oriented design utilizing a system. For two entities, this may not appear to be of any use, but for hundreds of entities in serial comparison it is extreme. A massive speed up with this pattern allows the ``CPU`` to cache data much better. Lua is also very closely mapped to C. This allows for the computer to do pointer arithmatic on the base pointer position of the table to retrieve data a LOT faster. This also allows the ``CPU`` to utilize it's prefetch to get the next piece of data before it's done with the current calculation.

## Systems

A system is simply a way to process the data. We will utilize the most basic function to explain it. We will use the basic ECS as defined above.

```
function process_dead()
    for id,value in ipairs(entity_holder.life) do
        if value <= 0 then
            print(entity_holder.name[id] .. " is dead")
        end
    end
end
```

There are further ways to optimize this. You could have process_dead() run every 10 game steps, or maybe every step if you so choose. It's totally up to you. All we are doing is running through the life component and printing out the corresponding name of the dead entity. Lua lists will stay in the order that they are defined as there is an internal C component which locks them into it unless a piece of data is removed between two components. Then the entire list after that component is shifted down by 1.

This may look like we're doing almost the same thing as you would normally do in Lua OOP. But there is one more thing which makes it so we do not have to jump through pointer lookups on each passthrough.

```
function process_dead()
    local life = entity_holder.life
    local name = entity_holder.name

    for id,value in ipairs(life) do
        if value <= 0 then
            print(name[id] .. " is dead")
        end
    end
end
```

We can utilize pointer precaching. Instead of doing a pointer lookup in the subtable of the ECS, we can tell the Lua VM where the pointer is in the first place, then race through it without having to recheck every step.