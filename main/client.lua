-- WEAPON DROP WHEN GET DAMAGE FROM UR HAND
local savedWeaponPositions = {}

local lastHitTime = 0
local cooldownTime = 2000
AddEventHandler("gameEventTriggered", function(name, args)
    -- if event ~= "CEventNetworkEntityDamage" or GetEntityType(args[1]) ~= 1 or NetworkGetPlayerIndexFromPed(args[1]) ~= PlayerId() then return end
    if Config.DropWeaponWhenHitHand == true then
        local victim = args[1]
        local hit, bone = GetPedLastDamageBone(victim)
        if hit then
            -- print(bone)
            local currentTime = GetGameTimer()
            if currentTime - lastHitTime > cooldownTime then
                lastHitTime = currentTime

                if bone == 18905 or bone == 57005 or bone == 28252 or bone == 14201 or bone == 24816 or bone == 51826 then
                    if IsPedArmed(victim, 14) then
                        local weapon = GetSelectedPedWeapon(victim)
                        local pedPosition = GetEntityCoords(victim)

                        -- CREATES WEAPON ON THE GROUND
                        SetPedToRagdoll(victim, 1000, 1000, 0, 0, 0, 0)
                        weaponThrewAwayHash = weapon
                        local pickupHash = GetPickupHashFromWeapon(weapon)

                        -- local pickup = CreatePickupRotate(pickupHash, pedPosition.x, pedPosition.y, pedPosition.z, 0, 0, 0, 8, 1, 1, true, weapon)
                        SetCurrentPedWeapon(victim, `WEAPON_UNARMED`, true)
                        --

                        if Config.Debug == true then
                            print("{DROP WEAPON WHEN HIT} test prints 0resmon GetSelectedPedWeapon" .. weapon)
                            print("{DROP WEAPON WHEN HIT} pickup hash" .. pickupHash)
                        end


                        -- FRAMEWORK CHECK
                        local weaponName = Config.Weapons[tostring(weapon)]
                        -- if Config.Framework == "qb" or Config.Framework == "oldqb" then
                        --     local victimID = GetPlayerServerId(NetworkGetEntityOwner(victim))

                        --     local weaponName = Config.Weapons[tostring(weapon)]
                        --     TriggerServerEvent('0r-weaponReality:weaponRemoveFromInventory', weaponName, victimID)
                        -- elseif Config.Framework == "esx" or Config.Framework == "oldesx" then
                        --     local victimID = GetPlayerServerId(NetworkGetEntityOwner(victim))
                        --     local weaponName = Config.Weapons[tostring(weapon)]
                        --     TriggerServerEvent('0r-weaponReality:weaponRemoveFromInventory', weaponName, victimID)
                        -- end
                        --
                        print('remove weapon')

                        TriggerServerEvent('0r-weaponReality:weaponThrown', pickupHash, pedPosition, weaponName,
                            weaponThrewAwayHash)
                        -- table.insert(savedWeaponPositions, { weapon = pickupHash, x = pedPosition.x, y = pedPosition.y, z = pedPosition.z, pickup = pickup, realWeapon = weaponName})
                        return
                    end
                end
            end
        end
    else
        return
    end
end)

RegisterCommand("checkSpotsAdmin", function()
    if Config.Debug == true then
        Notification(Config.Notifications['checkSpotsAdmin'].message)
        print(json.encode(savedWeaponPositions))
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        local pedCoords = GetEntityCoords(PlayerPedId())
        for i, weaponPos in ipairs(savedWeaponPositions) do
            local distance = #(vector3(weaponPos.x, weaponPos.y, weaponPos.z) - pedCoords)
            if distance < 5.0 then
                if Config.PickUpMenu == "drawtext" then
                    -- Config.TakeWeaponText["DrawText"] = Config.TakeWeaponText["DrawText"]:gsub("XXX", weaponPos.realWeapon)
                    DrawText3D(weaponPos.x, weaponPos.y, weaponPos.z - 1, Config.TakeWeaponText["DrawText"])
                elseif Config.PickUpMenu == "textui" then
                    if Config.TextUI == "qb-textui" then
                        -- Config.TakeWeaponText["TextUI"] = Config.TakeWeaponText["TextUI"]:gsub("XXX", weaponPos.realWeapon)
                        exports['qb-core']:DrawText(Config.TakeWeaponText["TextUI"], 'left')
                    elseif Config.TextUI == "ox-textui" then
                        -- Config.TakeWeaponText["TextUI"] = Config.TakeWeaponText["TextUI"]:gsub("XXX", weaponPos.realWeapon)
                        exports['ox_lib']:showTextUI(Config.TakeWeaponText["TextUI"])
                        -- exports['ox_lib']:showTextUI(Config.TakeWeaponText["TextUI"], 0.5, 1.0, 255, 255, 255, 255)
                    end
                end
                if IsControlJustReleased(0, 38) then
                    ClearPedTasksImmediately(PlayerPedId())
                    FreezeEntityPosition(PlayerPedId(), true)
                    PlayAnim(PlayerPedId(), "pickup_object", "pickup_low", -8.0, 8.0, -1, 49, 1.0)
                    Wait(800)
                    ClearPedTasks(PlayerPedId())
                    FreezeEntityPosition(PlayerPedId(), false)
                    Wait(math.random(100, 1000))
                    TriggerServerEvent('0r-weaponReality:takeWeaponFromGround', weaponPos.pickup, weaponPos.realWeapon,
                        weaponPos.randomWeaponID)
                end
            else
                if Config.PickUpMenu == "textui" then
                    if Config.TextUI == "qb-textui" then
                        exports['qb-core']:HideText()
                    elseif Config.TextUI == "ox-textui" then
                        exports['ox_lib']:hideTextUI()
                    end
                end
            end
        end
    end
end)

RegisterNetEvent('0r-weaponReality:takeWeaponFromGround:client', function(pickup)
    if Config.PickUpMenu == "textui" then
        if Config.TextUI == "qb-textui" then
            exports['qb-core']:HideText()
        elseif Config.TextUI == "ox-textui" then
            exports['ox_lib']:hideTextUI()
        end
    end
    for i, weaponPos in ipairs(savedWeaponPositions) do
        if weaponPos.pickup == pickup then
            -- print(i)
            TriggerServerEvent('0r-weaponReality:takeWeaponFromGround', weaponPos.pickup, weaponPos.realWeapon)
            table.remove(savedWeaponPositions, i)
            RemovePickup(weaponPos.pickup)
            RemovePickup(pickup)
            break
        end
    end
end)

RegisterNetEvent("0r-weaponReality:DeleteOnClient", function(pickup)
    for i, weaponPos in ipairs(savedWeaponPositions) do
        if weaponPos.pickup == pickup then
            table.remove(savedWeaponPositions, i)
            RemovePickup(pickup)
            RemovePickup(weaponPos.pickup)
            break
        end
    end
end)

-- THROW WEAPON

function GetDirectionFromRotation(rotation)
    local dm = (math.pi / 180)
    return vector3(-math.sin(dm * rotation.z) * math.abs(math.cos(dm * rotation.x)),
        math.cos(dm * rotation.z) * math.abs(math.cos(dm * rotation.x)), math.sin(dm * rotation.x))
end

-- function CheckCollisionWithProps(entity)
--     local pos = GetEntityCoords(entity)
--     local radius = 2.0
--     local nearbyEntities = Citizen.InvokeNative(0x2E941B5A, pos.x, pos.y, pos.z, radius, Citizen.InvokeNative(0xFA7F5047, "prop")) -- Bu native fonksiyon çevresindeki nesneleri alır
--     for _, nearbyEntity in ipairs(nearbyEntities) do
--         if nearbyEntity ~= entity then -- Fırlatılan nesneyle çakışan nesneyi kontrol ederken aynı nesneyi dikkate almayalım
--             print("Çarpışma tespit edildi: " .. nearbyEntity) -- İsim yerine farklı bir özelliği de yazdırabilirsiniz
--             -- Ekstra işlemler buraya eklenebilir, örneğin:
--             -- DeleteEntity(nearbyEntity) -- Çarpışan nesneyi sil
--             -- TriggerEvent("collisionDetected", nearbyEntity) -- Bir olay tetikle
--         end
--     end
-- end

function PerformPhysics(entity)
    local power = 25
    FreezeEntityPosition(entity, false)
    local ped = PlayerPedId()
    local rot = GetGameplayCamRot(2)
    local dir = GetDirectionFromRotation(rot)
    SetEntityHeading(entity, rot.z + 90.0)
    SetEntityVelocity(entity, dir.x * power, dir.y * power, power * dir.z)
    -- CheckCollisionWithProps(entity) -- Fırlatılan nesnenin çarpışma kontrolü
end

function CreateProp(modelHash, ...)
    RequestModel(modelHash)
    while not HasModelLoaded(modelHash) do Wait(0) end
    local obj = CreateObject(modelHash, ...)
    SetModelAsNoLongerNeeded(modelHash)
    return obj
end

local weaponThrewAwayName, weaponThrewAwayHash = nil;

RegisterNetEvent("0r-weaponReality:createOnClient",
    function(pickupHash, finalCoords, weaponName, weaponThrewAwayHash, randomWeaponID)
        -- print("Weapon thrown: " .. weaponName .. " (" .. pickupHash .. ") at " .. finalCoords.x .. ", " .. finalCoords.y .. ", " .. finalCoords.z)
        local pickupHash = GetPickupHashFromWeapon(weaponThrewAwayHash)
        local pickup = CreatePickupRotate(pickupHash, finalCoords.x, finalCoords.y, finalCoords.z, 0, 0, 0, 8, 1, 1, true,
            weaponThrewAwayHash)
        -- print("pickup" .. pickup)
        table.insert(savedWeaponPositions,
            {
                weapon = pickupHash,
                x = finalCoords.x,
                y = finalCoords.y,
                z = finalCoords.z + 1,
                realWeapon = weaponName,
                pickup =
                    pickup,
                randomWeaponID = randomWeaponID
            })
    end)

function ToggleCreationLaser()
    print("ToggleCreationLaser function called")
    deletionLaser = false
    creationLaser = not creationLaser
    print("creationLaser set to: " .. tostring(creationLaser))

    if creationLaser then
        CreateThread(function()
            print("Starting aim animation")
            PlayAnim(PlayerPedId(), "weapons@first_person@aim_rng@generic@projectile@shared@core", "aim_med_loop", -8.0,
                8.0, -1, 49)
        end)
        CreateThread(function()
            while creationLaser do
                local hit, coords = DrawLaser(Config.Lasers["Text"],
                    { r = Config.Lasers["R"], g = Config.Lasers["G"], b = Config.Lasers["B"], a = Config.Lasers["A"] })
                print("Laser hit: " .. tostring(hit) .. ", Coords: " .. tostring(coords))

                if IsControlJustReleased(0, 38) then
                    print("Control 38 just released")
                    local tt = coords
                    creationLaser = false
                    if hit then
                        print("Laser hit confirmed")

                        local weapon = GetSelectedPedWeapon(PlayerPedId())
                        print("Selected weapon: " .. tostring(weapon))
                        local pedPosition = GetEntityCoords(PlayerPedId())
                        print("Ped position: " .. tostring(pedPosition))
                        SetCurrentPedWeapon(PlayerPedId(), `WEAPON_UNARMED`, true)
                        CreateThread(function()
                            print("Starting throw animation")
                            PlayAnim(PlayerPedId(), "weapons@first_person@aim_rng@generic@projectile@shared@core",
                                "throw_m_fb_stand", -8.0, 8.0, -1, 49)
                            Wait(1000)
                            ClearPedTasks(PlayerPedId())
                            print("Throw animation completed")
                            print("tt: " .. tostring(tt))
                            local victimID = GetPlayerServerId(NetworkGetEntityOwner(PlayerPedId()))
                            local weaponName = Config.Weapons[tostring(weapon)]
                            print("weaponName: " .. tostring(weaponName))
                            TriggerServerEvent('0r-weaponReality:weaponRemoveFromInventory', weaponName, victimID)
                            TriggerServerEvent('0r-weaponReality:weaponThrown', pickupHash, tt, weaponName,
                                weaponThrewAwayHash)
                        end)
                        Wait(550)

                        local weaponHash = GetCurrentPedWeapon(PlayerPedId(), 1)
                        weaponThrewAwayHash = weapon
                        print("Weapon hash: " .. tostring(weaponHash))
                        local prop = GetWeaponObjectFromPed(PlayerPedId(), true)
                        local model = GetEntityModel(prop)
                        print("Weapon model: " .. tostring(model))
                        RemoveWeaponFromPed(PlayerPedId(), weaponHash)
                        DeleteEntity(prop)
                        prop = CreateProp(model, coords.x, coords.y, coords.z, true, false, true)
                        print("Created prop: " .. tostring(prop))
                        PerformPhysics(prop)


                        local initialPos = GetEntityCoords(prop)
                        local currentPos = initialPos
                        local isWeaponMoving = true
                        print("Starting weapon movement check")
                        while isWeaponMoving do
                            Wait(500)
                            currentPos = GetEntityCoords(prop)
                            print("Current position: " .. tostring(currentPos))
                            if Vdist2(initialPos.x, initialPos.y, initialPos.z, currentPos.x, currentPos.y, currentPos.z) < 0.1 then
                                isWeaponMoving = false
                                print("Weapon stopped moving")
                            else
                                initialPos = currentPos
                            end
                        end


                        local finalCoords = currentPos
                        print("Final coordinates: " .. tostring(finalCoords))
                        DeleteEntity(prop)
                        local pickupHash = GetPickupHashFromWeapon(weaponThrewAwayHash)
                        print("Pickup hash: " .. tostring(pickupHash))
                        local weaponName = Config.Weapons[tostring(weaponThrewAwayHash)]
                        print("Weapon name: " .. tostring(weaponName))
                        Notification(Config.Notifications['weaponThrown'].message)
                        if Config.Debug == true then
                            print("{THROW WEAPON} test prints 0resmon GetSelectedPedWeapon" .. weapon)
                            print("{THROW WEAPON} pickup hash" .. pickupHash)
                        end
                        TriggerServerEvent('0r-weaponReality:weaponThrown', pickupHash, finalCoords, weaponName,
                            weaponThrewAwayHash)
                        print("Triggered server event: 0r-weaponReality:weaponThrown")
                    else
                        print("Laser did not hit, too long distance")
                        TriggerEvent('Notify', 'error', Config.Notifications['tooLongDistance'].message)
                        ClearPedTasks(PlayerPedId())
                    end
                end

                Wait(0)
            end
        end)
    else
        print("Clearing ped tasks")
        ClearPedTasks(PlayerPedId())
    end
end

local gameTime = 0
local lastUsed = 0

RegisterCommand("0r-weaponReality:ThrowWeapon", function()
    -- local currentTime = GetGameTimer() / 5000
    -- if currentTime - lastUsed < 1 then
    --     return Notification(Config.Notifications['toofast_throw'].message)
    -- end

    -- lastUsed = currentTime

    -- local ped = PlayerPedId()
    -- if Config.ThrowWeapon == true then
    --     if IsPedArmed(ped, 14) then
    --         ToggleCreationLaser()
    --     else
    --         Notification(Config.Notifications['NoWeapon'].message)
    --     end
    -- end
end)

RegisterKeyMapping('0r-weaponReality:ThrowWeapon', 'Throw Weapon (J)', 'keyboard', Config.ThrowWeaponMenuOpenKey)


-- TEST

local keyPressed = false
local weaponAdded = false

RegisterCommand("0r-weaponReality:ChangeWeaponRunningAnimation", function()
    if Config.WeaponAnimation == "always" then
        Notification(Config.Notifications['changedAnimationsAlways'].message)
        return
    end
    keyPressed = not keyPressed
    Notification("" ..
        (keyPressed and Config.Notifications['changedanimationsTrue'].message or Config.Notifications['changedanimationsFalse'].message) ..
        "")
end)

RegisterKeyMapping('0r-weaponReality:ChangeWeaponRunningAnimation', 'Change Weapon Running Animation', 'keyboard',
    Config.ChangeWeaponRunningAnimationKey)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(100)
        local ped = PlayerPedId()
        if Config.WeaponAnimation == "always" then
            if not weaponAdded then
                GiveWeaponToPed(ped, GetHashKey("weapon_petrolcan"), 0, false, true)
                RemoveWeaponFromPed(ped, GetHashKey("weapon_petrolcan"))
                weaponAdded = true
            end
            if IsPedArmed(ped, 4) then
                SetPedWeaponMovementClipset(ped, "move_ped_wpn_jerrycan_generic", 0.50)
            else
                ResetPedWeaponMovementClipset(ped, 0.0)
            end
        elseif Config.WeaponAnimation == "key" then
            if keyPressed and not weaponAdded then
                GiveWeaponToPed(ped, GetHashKey("weapon_petrolcan"), 0, false, true)
                RemoveWeaponFromPed(ped, GetHashKey("weapon_petrolcan"))
                weaponAdded = true
            end

            if keyPressed then
                if IsPedArmed(ped, 4) then
                    SetPedWeaponMovementClipset(ped, "move_ped_wpn_jerrycan_generic", 0.50)
                else
                    ResetPedWeaponMovementClipset(ped, 0.0)
                end
            else
                ResetPedWeaponMovementClipset(ped, 0.0)
            end
        end
    end
end)



--


local disabledPickups = {
    `PICKUP_WEAPON_ADVANCEDRIFLE`,
    `PICKUP_WEAPON_APPISTOL`,
    `PICKUP_WEAPON_ASSAULTRIFLE`,
    `PICKUP_WEAPON_ASSAULTRIFLE_MK2`,
    `PICKUP_WEAPON_ASSAULTSHOTGUN`,
    `PICKUP_WEAPON_ASSAULTSMG`,
    `PICKUP_WEAPON_AUTOSHOTGUN`,
    `PICKUP_WEAPON_BAT`,
    `PICKUP_WEAPON_BATTLEAXE`,
    `PICKUP_WEAPON_BOTTLE`,
    `PICKUP_WEAPON_BULLPUPRIFLE`,
    `PICKUP_WEAPON_BULLPUPRIFLE_MK2`,
    `PICKUP_WEAPON_BULLPUPSHOTGUN`,
    `PICKUP_WEAPON_CARBINERIFLE`,
    `PICKUP_WEAPON_CARBINERIFLE_MK2`,
    `PICKUP_WEAPON_COMBATMG`,
    `PICKUP_WEAPON_COMBATMG_MK2`,
    `PICKUP_WEAPON_COMBATPDW`,
    `PICKUP_WEAPON_COMBATPISTOL`,
    `PICKUP_WEAPON_COMPACTLAUNCHER`,
    `PICKUP_WEAPON_COMPACTRIFLE`,
    `PICKUP_WEAPON_CROWBAR`,
    `PICKUP_WEAPON_DAGGER`,
    `PICKUP_WEAPON_DBSHOTGUN`,
    `PICKUP_WEAPON_DOUBLEACTION`,
    `PICKUP_WEAPON_FIREWORK`,
    `PICKUP_WEAPON_FLAREGUN`,
    `PICKUP_WEAPON_FLASHLIGHT`,
    `PICKUP_WEAPON_GRENADE`,
    `PICKUP_WEAPON_GRENADELAUNCHER`,
    `PICKUP_WEAPON_GUSENBERG`,
    `PICKUP_WEAPON_GolfClub`,
    `PICKUP_WEAPON_HAMMER`,
    `PICKUP_WEAPON_HATCHET`,
    `PICKUP_WEAPON_HEAVYPISTOL`,
    `PICKUP_WEAPON_HEAVYSHOTGUN`,
    `PICKUP_WEAPON_HEAVYSNIPER`,
    `PICKUP_WEAPON_HEAVYSNIPER_MK2`,
    `PICKUP_WEAPON_HOMINGLAUNCHER`,
    `PICKUP_WEAPON_KNIFE`,
    `PICKUP_WEAPON_KNUCKLE`,
    `PICKUP_WEAPON_MACHETE`,
    `PICKUP_WEAPON_MACHINEPISTOL`,
    `PICKUP_WEAPON_MARKSMANPISTOL`,
    `PICKUP_WEAPON_MARKSMANRIFLE`,
    `PICKUP_WEAPON_MARKSMANRIFLE_MK2`,
    `PICKUP_WEAPON_MG`,
    `PICKUP_WEAPON_MICROSMG`,
    `PICKUP_WEAPON_MINIGUN`,
    `PICKUP_WEAPON_MINISMG`,
    `PICKUP_WEAPON_MOLOTOV`,
    `PICKUP_WEAPON_MUSKET`,
    `PICKUP_WEAPON_NIGHTSTICK`,
    `PICKUP_WEAPON_PETROLCAN`,
    `PICKUP_WEAPON_PIPEBOMB`,
    `PICKUP_WEAPON_PISTOL`,
    `PICKUP_WEAPON_PISTOL50`,
    `PICKUP_WEAPON_PISTOL_MK2`,
    `PICKUP_WEAPON_POOLCUE`,
    `PICKUP_WEAPON_PROXMINE`,
    `PICKUP_WEAPON_PUMPSHOTGUN`,
    `PICKUP_WEAPON_PUMPSHOTGUN_MK2`,
    `PICKUP_WEAPON_RAILGUN`,
    `PICKUP_WEAPON_RAYCARBINE`,
    `PICKUP_WEAPON_RAYMINIGUN`,
    `PICKUP_WEAPON_RAYPISTOL`,
    `PICKUP_WEAPON_REVOLVER`,
    `PICKUP_WEAPON_REVOLVER_MK2`,
    `PICKUP_WEAPON_RPG`,
    `PICKUP_WEAPON_SAWNOFFSHOTGUN`,
    `PICKUP_WEAPON_SMG`,
    `PICKUP_WEAPON_SMG_MK2`,
    `PICKUP_WEAPON_SMOKEGRENADE`,
    `PICKUP_WEAPON_SNIPERRIFLE`,
    `PICKUP_WEAPON_SNSPISTOL`,
    `PICKUP_WEAPON_SNSPISTOL_MK2`,
    `PICKUP_WEAPON_SPECIALCARBINE`,
    `PICKUP_WEAPON_SPECIALCARBINE_MK2`,
    `PICKUP_WEAPON_STICKYBOMB`,
    `PICKUP_WEAPON_STONE_HATCHET`,
    `PICKUP_WEAPON_STUNGUN`,
    `PICKUP_WEAPON_SWITCHBLADE`,
    `PICKUP_WEAPON_VINTAGEPISTOL`,
    `PICKUP_WEAPON_WRENCH`
}

CreateThread(function()
    for _, hash in pairs(disabledPickups) do
        ToggleUsePickupsForPlayer(PlayerId(), hash, false)
    end
end)

local camtoggle = false
local cam = nil
local originalFov = 50.0
local bekle = 1000
local lastWeapon = nil

-- Function to toggle the camera
function ToggleCamera()
    local playerPed = PlayerPedId()
    local weapon = GetSelectedPedWeapon(playerPed)

    DisableControlAction(0, 0)
    if IsPedArmed(playerPed, 14) and IsPlayerFreeAiming(PlayerId()) then
        SetBlackout(false)
        if camtoggle then
            SetCamActive(cam, false)
            RenderScriptCams(false, true, 500, true, true)
            camtoggle = false
            SetCamFov(cam, originalFov) -- Reset FOV when camera is toggled off
        else
            -- print("hangi kamera bu")
            cam = CreateCam("DEFAULT_SCRIPTED_CAMERA", 1)
            AttachCamToPedBone(
                cam,
                PlayerPedId(),
                31086,
                -0.3,
                -1.2,
                0.1,
                GetEntityHeading(PlayerPedId()) + .0
            )
            SetCamAffectsAiming(cam, false)
            SetCamFov(cam, originalFov)
            RenderScriptCams(true, true, 500, true, true)
            camtoggle = true
            ChangeCameraRotation()
        end
    end
end

-- Function to continuously update camera rotation
function ChangeCameraRotation()
    while camtoggle do
        Citizen.Wait(1)
        SetCamRot(cam, GetEntityRotation(PlayerPedId(), 2), 2)
    end
end

-- Keymapping
RegisterCommand("shoulderSwap", function()
    if Config.ShoulderSwap == true then
        ToggleCamera()
    else
        Notification(Config.Notifications['shoulderSwapDisabled'].message)
    end
end, false)

RegisterKeyMapping("shoulderSwap", "Shoulder Swap", "keyboard", Config.DefaultShoulderSwapKey)

-- Main thread
Citizen.CreateThread(function()
    while true do
        SetBlackout(false)
        Citizen.Wait(bekle)
        local playerPed = PlayerPedId()
        local currentWeapon = GetSelectedPedWeapon(playerPed)
        if IsPlayerFreeAiming(PlayerId()) then
            bekle = 0
            if currentWeapon ~= lastWeapon then
                lastWeapon = currentWeapon
                -- if not camtoggle then
                -- ToggleCamera()
                -- end
            end
            if IsControlJustPressed(0, 246) then
                ToggleCamera()
            end
        else
            bekle = 1000
            camtoggle = false
            if cam ~= nil then
                SetCamActive(cam, false)
                RenderScriptCams(false, true, 500, true, true)
                SetCamFov(cam, originalFov)
            end
        end
    end
end)


-- local camtoggle = false
-- local cam = nil
-- local originalFov = 50.0
-- local bekle = 1000
-- local lastWeapon = nil

-- -- Function to toggle the camera
-- function ToggleCamera()
--     local playerPed = PlayerPedId()
--     local weapon = GetSelectedPedWeapon(playerPed)

--     DisableControlAction(0, 0)
--     if IsPedArmed(playerPed, 14) and IsPlayerFreeAiming(PlayerId()) then
--         SetBlackout(false)
--         if camtoggle then
--             SetCamActive(cam, false)
--             RenderScriptCams(false, true, 500, true, true)
--             camtoggle = false
--         else
--             cam = CreateCam("DEFAULT_SCRIPTED_CAMERA", 1)
--             AttachCamToPedBone(
--                 cam,
--                 PlayerPedId(),
--                 31086,
--                 -0.3,
--                 -1.2,
--                 0.1,
--                 GetEntityHeading(PlayerPedId()) + .0
--             )
--             SetCamAffectsAiming(cam, false)
--             RenderScriptCams(true, true, 500, true, true)
--             camtoggle = true
--             ChangeCameraRotation()
--         end
--     end
-- end

-- -- Function to continuously update camera rotation
-- function ChangeCameraRotation()
--     while camtoggle do
--         Citizen.Wait(1)
--         SetCamRot(cam, GetEntityRotation(PlayerPedId(), 1), 1)
--     end
-- end

-- -- Keymapping
-- RegisterCommand("shoulderSwap", function()
--     if Config.ShoulderSwap == true then
--         ToggleCamera()
--     else
--         Notification(Config.Notifications['shoulderSwapDisabled'].message)
--     end
-- end, false)

-- RegisterKeyMapping("shoulderSwap", "Shoulder Swap", "keyboard", "H")

-- -- Main thread
-- Citizen.CreateThread(function()
--     while true do
--         SetBlackout(false)
--         Citizen.Wait(bekle)
--         local playerPed = PlayerPedId()
--         local currentWeapon = GetSelectedPedWeapon(playerPed)
--         if IsPlayerFreeAiming(PlayerId()) then
--             bekle = 0
--             if currentWeapon ~= lastWeapon then
--                 lastWeapon = currentWeapon
--                 ToggleCamera()
--             end
--             if IsControlJustPressed(0, 246) then
--                 ToggleCamera()
--             end
--         else
--             bekle = 1000
--             camtoggle = false
--             if cam ~= nil then
--                 SetCamActive(cam, false)
--                 RenderScriptCams(false, true, 500, true, true)
--             end
--         end
--     end
-- end)




-- RegisterNetEvent('baseevents:onPlayerDied')
-- AddEventHandler('baseevents:onPlayerDied', function()
--     if Config.WhenDeadDropGun == true then
--     local ped = PlayerPedId()
--     if IsPedArmed(PlayerPedId(), 14) then
--         local weapon = GetSelectedPedWeapon(PlayerPedId())
--             local pedPosition = GetEntityCoords(PlayerPedId())
--             -- CREATES WEAPON ON THE GROUND
--             SetPedToRagdoll(PlayerPedId(), 1000, 1000, 0, 0, 0, 0)
--             weaponThrewAwayHash = weapon
--             local pickupHash = GetPickupHashFromWeapon(weapon)
--             -- local pickup = CreatePickupRotate(pickupHash, pedPosition.x, pedPosition.y, pedPosition.z, 0, 0, 0, 8, 1, 1, true, weapon)
--             SetCurrentPedWeapon(victim, `WEAPON_UNARMED`, true)
--             --
--             -- FRAMEWORK CHECK
--             local weaponName = Config.Weapons[tostring(weapon)]
--             if Config.Framework == "qb" or Config.Framework == "oldqb" then
--                 local victimID = GetPlayerServerId(NetworkGetEntityOwner(PlayerPedId()))
--                 local weaponName = Config.Weapons[tostring(weapon)]
--                 TriggerServerEvent('0r-weaponReality:weaponRemoveFromInventory', weaponName, victimID)
--             elseif Config.Framework == "esx" or Config.Framework == "oldesx" then
--                 local victimID = GetPlayerServerId(NetworkGetEntityOwner(PlayerPedId()))
--                 local weaponName = Config.Weapons[tostring(weapon)]
--                 TriggerServerEvent('0r-weaponReality:weaponRemoveFromInventory', weaponName, victimID)
--             end
--             --
--             if Config.Debug == true then
--                 print("{DROP WEAPON WHEN DIE} test prints 0resmon GetSelectedPedWeapon" .. weapon)
--                 print("{DROP WEAPON WHEN DIE} pickup hash" .. pickupHash)
--             end
--             TriggerServerEvent('0r-weaponReality:weaponThrown', pickupHash, pedPosition, weaponName, weaponThrewAwayHash)
--     else
--         if Config.Debug == true then
--             print("{DROP WEAPON WHEN DIE} You died without gun.")
--         end
--         return
--     end
-- else
--     return
-- end
-- end)
