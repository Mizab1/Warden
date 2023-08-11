import ./macros/rngV2.mcm
import ./macros/wait_as.mcm

function load{
    scoreboard objectives add vibe_found dummy
    scoreboard objectives add ak.var dummy
    scoreboard objectives add vibe_id dummy
    scoreboard objectives add LANG_MC_INTERNAL dummy
    scoreboard objectives add event_id dummy
    scoreboard objectives add pose dummy
    scoreboard objectives add rotate dummy
    scoreboard objectives add motion0 dummy
    scoreboard objectives add motion1 dummy
    scoreboard objectives add motion2 dummy

    scoreboard objectives add current_pos0 dummy
    scoreboard objectives add current_pos1 dummy
    scoreboard objectives add current_pos2 dummy
    scoreboard objectives add previous_pos0 dummy
    scoreboard objectives add previous_pos1 dummy
    scoreboard objectives add previous_pos2 dummy
    scoreboard objectives add LANG_MC_INTERNAL dummy
    team add NoCollision
    team modify NoCollision collisionRule never
    team modify NoCollision seeFriendlyInvisibles false
    scoreboard objectives add vibe_detect dummy
    scoreboard players set success vibe_id 0
    scoreboard objectives add interpolDelay dummy
    scoreboard objectives add hurtTime dummy
    scoreboard objectives add killed dummy
    scoreboard objectives add vibesense dummy


    # written by Mizab coz the mcb isn't detecting load function in warden.main
    scoreboard objectives add LANG_MC_INTERNAL dummy
    scoreboard objectives add warden.private dummy

    scoreboard objectives add Motion.X dummy
    scoreboard objectives add Motion.Y dummy
    scoreboard objectives add Motion.Z dummy

    scoreboard objectives add pos1.x dummy
    scoreboard objectives add pos2.x dummy
    scoreboard objectives add pos1.z dummy
    scoreboard objectives add pos2.z dummy

    scoreboard objectives add cooldown dummy

    scoreboard objectives add tp_upward dummy


    scoreboard players set min warden.private 2147483647
    scoreboard players set player_motion_delay warden.private 0
    scoreboard players set player_motion_delay_sprint warden.private 0

    scoreboard players set $dialogue_1 warden.private 0

    scoreboard players set warden.attack warden.private 0
    scoreboard players set $defeated warden.private 0

    gamemode survival @a
}



dir summon{
    function warden{
        function model:summon_model/animated_heart
    }

    function vibe{
        summon armor_stand ~ ~ ~ {NoGravity:1b,Silent:1b,Invulnerable:1b,Marker:1b,Invisible:1b,Tags:["vibration"],Pose:{Head:[0.1f,0f,0f]},DisabledSlots:4144959,ArmorItems:[{},{},{},{id:"minecraft:blue_dye",Count:1b,tag:{CustomModelData:1}}]}
        summon armor_stand ~ ~ ~1 {NoGravity:1b,Silent:1b,Invulnerable:1b,Marker:1b,Invisible:1b,Tags:["vibration"],Pose:{Head:[0.1f,0f,0f]},DisabledSlots:4144959,ArmorItems:[{},{},{},{id:"minecraft:blue_dye",Count:1b,tag:{CustomModelData:1}}]}
        summon armor_stand ~2 ~ ~ {NoGravity:1b,Silent:1b,Invulnerable:1b,Marker:1b,Invisible:1b,Tags:["vibration"],Pose:{Head:[0.1f,0f,0f]},DisabledSlots:4144959,ArmorItems:[{},{},{},{id:"minecraft:blue_dye",Count:1b,tag:{CustomModelData:1}}]}
        summon armor_stand ~ ~2 ~ {NoGravity:1b,Silent:1b,Invulnerable:1b,Marker:1b,Invisible:1b,Tags:["vibration"],Pose:{Head:[0.1f,0f,0f]},DisabledSlots:4144959,ArmorItems:[{},{},{},{id:"minecraft:blue_dye",Count:1b,tag:{CustomModelData:1}}]}
        summon armor_stand ~1 ~ ~1 {NoGravity:1b,Silent:1b,Invulnerable:1b,Marker:1b,Invisible:1b,Tags:["vibration"],Pose:{Head:[0.1f,0f,0f]},DisabledSlots:4144959,ArmorItems:[{},{},{},{id:"minecraft:blue_dye",Count:1b,tag:{CustomModelData:1}}]}
    }
}

clock 10t{
    execute as @e[type=wandering_trader,tag=warden,tag=angry] at @s run{
        execute store result entity @s WanderTarget.X int 1 run data get entity @p Pos[0]
        execute store result entity @s WanderTarget.Y int 1 run data get entity @p Pos[1]
        execute store result entity @s WanderTarget.Z int 1 run data get entity @p Pos[2]
    }
}


#>------ raycast laser for fun just for video
# clock 20t{
#     scoreboard players set raycast ak.var 0
#     execute as @e[type=armor_stand,tag=angry,tag=!angry_anim] at @s anchored eyes positioned ^ ^-0.75 ^ run{
#         particle witch ^ ^ ^ 0 0 0 0 15
#         scoreboard players add raycast ak.var 1
#         effect give @a[distance=..2] instant_damage
#         execute if block ~ ~ ~ air unless score raycast ak.var matches 200.. positioned ^ ^ ^0.1 facing entity @p eyes run function $block
#     }
# }

function tick{
    execute positioned 24.37 117.00 -47.34 run spawnpoint @a[distance=..10] ~ ~ ~
    execute positioned -24.86 85.00 -58.21 run spawnpoint @a[distance=..10] ~ ~ ~
    execute positioned -15.38 92.00 -126.62 run spawnpoint @a[distance=..10] ~ ~ ~
    effect give @a saturation 100000 0 true
    execute as @e[type=iron_golem,tag=angry,tag=!angry_nbt] run{
        data merge entity @s {AngerTime:1000,AngryAt:[I;0,0,0,0]}
        data modify entity @s AngryAt set from entity @p UUID
        tag @s add angry_nbt
    }

    scoreboard players add @e[tag=killed,type=armor_stand] killed 1
    execute as @e[type=armor_stand,tag=model.warden.root_entity,tag=!no_hitbox,tag=!killed] at @s positioned ~ ~-1 ~ unless entity @e[type=iron_golem,tag=hitbox,distance=..2] run{
        tp @s ~ ~1 ~
        tag @s add killed
        scoreboard players set @s model.i 0
        function model:set_state/animated_heart_hurt
        #put code here for start when he dies
    }
    execute as @e[type=armor_stand,tag=killed,scores={killed=3..19}] at @s run function model:animations/warden.death/loop
    execute as @e[type=armor_stand,tag=killed,scores={killed=40..}] at @s run{
        execute positioned ~ ~-1 ~ run tag @e[type=wandering_trader,tag=warden,distance=..1] add killed
        execute positioned ~ ~-1 ~ run tag @e[type=wandering_trader,tag=killed,distance=..1] remove warden
        tag @e[type=iron_golem,tag=hitbox,distance=..1] add killed
        function model:remove/this_model
    }
    tp @e[type=wandering_trader, tag=killed] 0 -300 0
    tp @e[type=iron_golem,tag=killed] 0 -300 0

    execute as @e[type=armor_stand,tag=model.warden.root_entity,tag=!boss_as,tag=no_hitbox] at @s positioned ~ ~-1 ~ run{
        summon iron_golem ~ ~ ~ {CustomName:'{"text":"Warden"}',DeathLootTable:"minecraft:empty",Tags:["hitbox"],NoGravity:1b,Silent:1b,ActiveEffects:[{Id:14b,Amplifier:1b,Duration:4000000,ShowParticles:0b}]}
        tag @s remove no_hitbox
    }
    execute as @e[type=armor_stand,tag=model.warden.root_entity,tag=!no_hitbox] at @s positioned ~ ~-1 ~ if entity @e[type=iron_golem,distance=..0.5,tag=hitbox,nbt={HurtTime:10s}] run{
        tag @s add hurttime
    }
    scoreboard players add @e[type=armor_stand,tag=hurttime,tag=model.warden.root_entity] hurtTime 1
    scoreboard players add @e[type=armor_stand,tag=angry] vibesense 1
    execute as @e[type=armor_stand,tag=model.warden.root_entity,scores={vibesense=10..145}] at @s run{
        function model:animations/warden.angry/loop
    }
    tag @e[type=armor_stand,tag=angry_anim,scores={vibesense=146..}] remove angry_anim
    execute as @e[type=armor_stand,tag=model.warden.root_entity,scores={vibesense=150}] at @s run{
        attribute @e[type=minecraft:wandering_trader,tag=warden,distance=..1.75,limit=1] minecraft:generic.movement_speed modifier add 0-1-2-3-4 speedy_boi 0.40 add
        tag @e[type=minecraft:wandering_trader,tag=warden,distance=..1.75,limit=1] add angry
        execute positioned ~ ~-1 ~ run data modify entity @e[type=wandering_trader,tag=warden,distance=..1,limit=1] NoAI set value 0b
        execute as @e[type=wandering_trader,tag=warden,tag=angry] at @s run{
                execute store result entity @s WanderTarget.X int 1 run data get entity @p Pos[0]
                execute store result entity @s WanderTarget.Y int 1 run data get entity @p Pos[1]
                execute store result entity @s WanderTarget.Z int 1 run data get entity @p Pos[2]
            }
    }
    execute as @e[type=armor_stand,tag=model.warden.root_entity,scores={vibesense=1000..}] at @s unless data entity @e[type=iron_golem,distance=..1,limit=1] AngryAt run{
        attribute @e[type=minecraft:wandering_trader,tag=warden,distance=..1.75,limit=1] minecraft:generic.movement_speed modifier remove 0-1-2-3-4
        tag @s remove angry
        tag @e[type=iron_golem,tag=hitbox,distance=..1,limit=1] remove angry
        tag @e[type=iron_golem,tag=hitbox,distance=..1,limit=1] remove angry_nbt
        tag @e[type=minecraft:wandering_trader,tag=warden,distance=..1.75,limit=1] remove angry
        scoreboard players set @s vibesense 0
    }
    execute as @e[type=armor_stand,tag=model.warden.root_entity,scores={vibesense=1000..}] at @s run{
        attribute @e[type=minecraft:wandering_trader,tag=warden,distance=..1.75,limit=1] minecraft:generic.movement_speed modifier remove 0-1-2-3-4
        tag @s remove angry
        tag @e[type=iron_golem,tag=hitbox,distance=..1,limit=1] remove angry
        tag @e[type=iron_golem,tag=hitbox,distance=..1,limit=1] remove angry_nbt
        tag @e[type=minecraft:wandering_trader,tag=warden,distance=..1.75,limit=1] remove angry
        scoreboard players set @s vibesense 0
    }
    execute as @e[type=armor_stand,tag=hurttime,tag=model.warden.root_entity,scores={hurtTime=1},tag=!killed] at @s run{
        execute unless score @s vibesense matches 1.. run{
            tag @s add angry
            tag @s add angry_anim
            execute positioned ~ ~-1 ~ run data merge entity @e[type=wandering_trader,tag=warden,distance=..1,limit=1] {NoAI:1b}
            tag @e[type=iron_golem,tag=hitbox,distance=..1,limit=1] add angry
            scoreboard players set @s vibesense 1
            scoreboard players set @s model.i 0
        } 
        function model:set_state/animated_heart_hurt
        playsound warden.hurt master @a ~ ~ ~ 0.6
    } 
    execute as @e[type=armor_stand,tag=hurttime,scores={hurtTime=8..}] at @s run{
        function model:set_state/animated_heart
        tag @s remove hurttime
        scoreboard players set @s hurtTime 0
    }
    execute as @e[type=armor_stand,tag=model.warden.root_entity,tag=!no_hitbox] at @s positioned ~ ~-1 ~ run tp @e[type=iron_golem,tag=hitbox,limit=1,sort=nearest] ~ ~ ~
    # execute at @e[type=wandering_trader,tag=warden] if entity @e[type=wandering_trader,tag=warden,distance=0.01..2] as @e[type=wandering_trader,tag=warden,limit=1,distance=..2] at @s run{
    #     execute positioned ^0.5 ^ ^ if entity @e[type=wandering_trader,distance=..0.49] run tp @s ^-0.1 ^ ^
    #     execute positioned ^-0.5 ^ ^ if entity @e[type=wandering_trader,distance=..0.49] run tp @s ^0.1 ^ ^
    #     execute positioned ^ ^ ^0.5 if entity @e[type=wandering_trader,distance=..0.49] run tp @s ^ ^ ^-0.05
    #     execute positioned ^ ^ ^-0.5 if entity @e[type=wandering_trader,distance=..0.49] run tp @s ^ ^ ^0.05
    #     tp @s ^ ^ ^0.05 0 ~
    # }

    execute as @e[type=wandering_trader,tag=warden] run{
        scoreboard players operation @s previous_pos0 = @s current_pos0
        scoreboard players operation @s previous_pos1 = @s current_pos1
        scoreboard players operation @s previous_pos2 = @s current_pos2
    } 
    execute as @e[type=wandering_trader,tag=warden] run{
        execute store result score @s current_pos0 run data get entity @s Pos[0] 100000
        execute store result score @s current_pos1 run data get entity @s Pos[1] 100000
        execute store result score @s current_pos2 run data get entity @s Pos[2] 100000
    }
    execute as @e[type=wandering_trader,tag=warden] run{
        scoreboard players operation @s motion0 = @s current_pos0
        scoreboard players operation @s motion1 = @s current_pos1
        scoreboard players operation @s motion2 = @s current_pos2
        
        scoreboard players operation @s motion0 -= @s previous_pos0
        scoreboard players operation @s motion1 -= @s previous_pos1
        scoreboard players operation @s motion2 -= @s previous_pos2
    }
    execute as @e[tag=vibe_detect,type=wandering_trader] at @s run tag @e[type=armor_stand,tag=model.warden.root_entity,distance=..2] add vibe_detect
    scoreboard players add @e[tag=vibe_detect] vibe_detect 1
    tag @e[tag=vibe_detect,scores={vibe_detect=40..}] remove vibe_detect
    scoreboard players set @e[scores={vibe_detect=40..}] vibe_detect 0
    # say @e[tag=vibe_detect]
    team join NoCollision @a
    team join NoCollision @e[type=wandering_trader,tag=warden]
    execute as @e[type=wandering_trader] run data modify entity @s HandItems set value [{},{}]
    execute as @e[type=armor_stand,tag=model.warden.root_entity] at @s rotated as @e[type=wandering_trader,tag=warden,sort=nearest,limit=1] run tp @s ~ ~ ~ ~ 0
    execute as @e[type=wandering_trader,tag=warden] at @s run{
        # execute store result score @s motion0 run data get entity @s Motion[0] 1000
        # execute store result score @s motion1 run data get entity @s Motion[1] 1000
        # execute store result score @s motion2 run data get entity @s Motion[2] 1000
        execute(unless score @s motion0 matches 0 unless score @s motion2 matches 0){
            execute as @e[tag=model.warden.root_entity,tag=!killed,limit=1,distance=..2,sort=nearest,tag=!vibe_detect,tag=!angry,tag=!bash] at @s run function model:animations/warden.walk.slow/loop
            execute as @e[tag=model.warden.root_entity,tag=!killed,limit=1,distance=..2,sort=nearest,tag=vibe_detect,tag=!angry,tag=!bash] at @s run function model:animations/warden.walk.slow.sound/loop
            execute as @e[tag=model.warden.root_entity,tag=!killed,limit=1,distance=..2,sort=nearest,tag=!vibe_detect,tag=angry,tag=!bash,tag=!angry_anim] at @s run function model:animations/warden.walk.fast/loop
            execute as @e[tag=model.warden.root_entity,tag=!killed,limit=1,distance=..2,sort=nearest,tag=vibe_detect,tag=angry,tag=!bash,tag=!angry_anim] at @s run function model:animations/warden.walk.fast.sound/loop
            execute as @e[tag=model.warden.root_entity,tag=!killed,limit=1,distance=..2,sort=nearest,tag=bash] at @s run function model:animations/warden.walk.fast/loop
        }else{
            execute as @e[tag=model.warden.root_entity,tag=!killed,limit=1,distance=..2,sort=nearest,tag=!vibe_detect,tag=!angry_anim,tag=!bash] at @s run function model:animations/warden.idle/loop
            execute as @e[tag=model.warden.root_entity,tag=!killed,limit=1,distance=..2,sort=nearest,tag=vibe_detect,tag=!angry_anim,tag=!bash] at @s run function model:animations/warden.idle.sound/loop
        }
    }
    # execute as @e[type=armor_stand,tag=vibration] store result score @s pose run data get entity @s Pose.Head[2] 1
    scoreboard players add @e[type=armor_stand,tag=vibration] pose 15
    execute as @e[type=armor_stand,tag=vibration] store result entity @s Pose.Head[2] float 1 run scoreboard players get @s pose
    # execute as @e[type=armor_stand,tag=vibration] run data modify entity @s Pose.Head[1] set from entity @s Rotation[0]
    execute as @e[type=wandering_trader,tag=warden,tag=!vibe_id] run{
        execute store result score @s vibe_id run data get entity @s UUID[0]
        tag @s add vibe_id
    }
    # tag @e[tag=linked] remove linked


    execute as @e[tag=warden,type=wandering_trader] at @s if entity @e[tag=vibration,type=armor_stand,distance=..30] run{
        # tag @s add warden_checked
        # tp @a[gamemode=spectator] @s
        scoreboard players set this event_id 0
        scoreboard players set max event_id -1
        scoreboard players operation max event_id > @e[tag=vibration,type=armor_stand] event_id
        block{
            # tellraw @p {"score":{"name":"this","objective":"event_id"}}
            
            # say hi
            execute as @e[tag=vibration,type=armor_stand,tag=!vibe_linked] if score @s event_id = this event_id run tag @s add this.event
            # say @e[tag=this.event]
            execute store result score vibe_amount vibe_id if entity @e[tag=this.event]
            block{
                # tellraw @p {"score":{"name":"vibe_amount","objective":"vibe_id"}}
                tag @e[tag=vibration,type=armor_stand,tag=!vibe_checked,limit=1,tag=!vibe_linked,tag=this.event] add this.vibe
                # tp @a[gamemode=spectator] @s
                scoreboard players remove vibe_amount vibe_id 1
                # execute if score @e[tag=this.vibe,limit=1] vibe_id = @s vibe_id run{
                #     say theres already another entity
                # } 
                execute unless score @e[tag=this.vibe,limit=1] vibe_id = @s vibe_id if score vibe_amount vibe_id matches 0 run{
                    scoreboard players operation @e[tag=this.vibe] vibe_id = @s vibe_id
                    tag @e[tag=this.vibe] add vibe_linked
                    tag @e[tag=this.vibe] remove this.vibe
                    # say there's not another entity
                } 
                execute unless score @e[tag=this.vibe,limit=1] vibe_id = @s vibe_id unless score vibe_amount vibe_id matches 0 run{
                    tag @e[tag=this.vibe] add vibe_checked
                    tag @e[tag=this.vibe] remove this.vibe
                    function $parent
                } 
            }
            scoreboard players add this event_id 1
            tag @e[tag=this.event] remove this.event
            tag @e[tag=vibe_checked] remove vibe_checked
            execute unless score this event_id > max event_id run function $block
        }
    }
    function warden:link
    execute as @e[type=armor_stand,tag=vibration,scores={rotate=5..}] at @s run tp @s ^ ^ ^0.6 ~ ~

    
    execute as @e[type=#warden.main:makes_sound,tag=!hasPassenger,tag=!interpolDelay] at @s run{
        execute if entity @s[type=snowball] run summon snowball ~ ~200 ~ {Tags:["hasPassenger","ak.new"],Passengers:[{id:"minecraft:armor_stand",Invisible:1b,Tags:["event_detection"]}]}
        execute if entity @s[type=egg] run summon egg ~ ~200 ~ {Tags:["hasPassenger","ak.new"],Passengers:[{id:"minecraft:armor_stand",Invisible:1b,Tags:["event_detection"]}]}
        tp @e[tag=hasPassenger,tag=ak.new] ~ ~ ~
        data modify entity @e[type=#warden.main:makes_sound,limit=1,tag=ak.new,tag=hasPassenger] Motion set from entity @s Motion
        tag @e[tag=ak.new] remove ak.new
        tag @s add interpolDelay
    }
    scoreboard players add @e[tag=interpolDelay,type=#warden.main:makes_sound] interpolDelay 1
    kill @e[tag=interpolDelay,type=#warden.main:makes_sound,scores={interpolDelay=10..}]
    execute as @e[type=wandering_trader,tag=bash] at @s facing entity @p feet unless entity @a[distance=..1] run tp @s ^ ^ ^0.7 ~ 0
    execute as @e[type=wandering_trader,tag=bash] at @s unless block ^ ^ ^0.3 air run fill ^-2 ^4 ^1 ^2 ^ ^ air destroy
}

function link{
    execute as @e[tag=vibration,type=armor_stand] at @s if entity @e[type=wandering_trader,tag=warden,distance=..30] run{
        scoreboard players set @s vibe_found 0
        scoreboard players set @s[tag=!rotate] rotate 0
        tag @s add rotate
        block{
            tag @e[type=wandering_trader,tag=warden,tag=!processed,limit=1] add warden.check
            execute if score @s vibe_id = @e[tag=warden.check,limit=1] vibe_id run{
                tag @e[tag=warden.check] add current.warden
                scoreboard players add @s rotate 1
                execute facing entity @e[tag=current.warden] eyes run tp @s ^ ^ ^ ~ ~
                execute at @s if entity @e[tag=current.warden,distance=..2] run{
                    #put code here when vibe arrives at warden
                    kill @s
                    tag @e[tag=current.warden,limit=1] add vibe_detect
                    # scoreboard players add @e[tag=current.warden,limit=1] vibesense 1
                } 
                tag @e[tag=current.warden] remove current.warden
                scoreboard players set @s vibe_found 1
            }
            tag @e[tag=warden.check] add processed
            tag @e[tag=warden.check] remove warden.check
            execute unless score @s vibe_found matches 1 run function $block
        }
        tag @e[tag=processed] remove processed
    }
}

#should be executed as the wandering trader entity
function bash{
    tag @s add bash
    execute positioned ~ ~1 ~ run tag @e[type=armor_stand,tag=model.warden.root_entity,limit=1,sort=nearest,distance=..1] add bash
    playsound minecraft:warden.hurt hostile @a ~ ~ ~ 0.8 0.1 1
    execute store result entity @s WanderTarget.X int 1 run data get entity @p Pos[0]
    execute store result entity @s WanderTarget.Y int 1 run data get entity @p Pos[1]
    execute store result entity @s WanderTarget.Z int 1 run data get entity @p Pos[2]
    execute positioned ~ ~1 ~ as @e[type=iron_golem,tag=hitbox,limit=1,sort=nearest,distance=..2] run{
        data merge entity @s {AngerTime:1000,AngryAt:[I;0,0,0,0]}
        data modify entity @s AngryAt set from entity @p UUID
    }
    wait as @s for 30t {
        tag @s remove bash
        execute at @s positioned ~ ~1 ~ run tag @e[type=armor_stand,tag=model.warden.root_entity,limit=1,sort=nearest,distance=..1] remove bash
    }
}

# Notes:
# summon wandering_trader ~ ~ ~ {Silent:1b,Invulnerable:1b,Tags:["warden"],Passengers:[{id:"minecraft:armor_stand",Tags:['model.warden','model.warden.root_entity','new','no_hitbox'],NoGravity:1b,Invisible:1b,DisabledSlots:4144959,CustomName:'["",{"text":"model.","color":"gray"},{"color":"blue"},{"text":".root_entity","color":"gray"}]'}],ActiveEffects:[{Id:14b,Amplifier:1b,Duration:2000000,ShowParticles:0b}]}