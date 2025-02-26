local ped
local coordsList = {
    vector3(200.0, -900.0, 30.0),
    vector3(210.0, -910.0, 30.0),
    vector3(220.0, -920.0, 30.0)
}
local currentIndex = 1
local lastChangeTime = 0

local function loadLastChange()
    local savedTime = GetResourceKvpInt("ped_lastChangeTime")
    local savedIndex = GetResourceKvpInt("ped_currentIndex")

    if savedTime and savedTime > 0 then
        lastChangeTime = savedTime
    end
    if savedIndex and savedIndex > 0 then
        currentIndex = savedIndex
    end
end

local function saveLastChange()
    SetResourceKvpInt("ped_lastChangeTime", lastChangeTime)
    SetResourceKvpInt("ped_currentIndex", currentIndex)
end

local function spawnPed()
    local model = GetHashKey("a_m_m_business_01")
    RequestModel(model)
    while not HasModelLoaded(model) do
        Wait(100)
    end

    ped = CreatePed(4, model, coordsList[currentIndex], 0.0, false, true)
    SetEntityInvincible(ped, true)
    SetBlockingOfNonTemporaryEvents(ped, true)

end

local function checkPedMove()
    while true do
        Citizen.Wait(60000)

        local currentTime = GetCloudTimeAsInt()

        if currentTime - lastChangeTime >= 72 * 60 * 60 then 
            currentIndex = currentIndex % #coordsList + 1

            if ped and DoesEntityExist(ped) then
                SetEntityCoords(ped, coordsList[currentIndex].x, coordsList[currentIndex].y, coordsList[currentIndex].z, false, false, false, false)
            else
                spawnPed()
            end

            lastChangeTime = currentTime
            saveLastChange()
        end
    end
end

loadLastChange()
spawnPed()
CreateThread(checkPedMove)
