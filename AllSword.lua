-- ฟังก์ชันสำหรับดึงข้อมูล inventory ของผู้เล่น
function GetWeaponInventory()
    return game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("getInventory")
end

-- ฟังก์ชันสำหรับแสดงค่าทั้งหมดใน inventory ของอาวุธแต่ละชิ้น รวมถึงตารางย่อย
function PrintTable(tbl, indent)
    indent = indent or 0
    local indentString = string.rep("  ", indent)
    
    for key, value in pairs(tbl) do
        if type(value) == "table" then
            print(indentString .. tostring(key) .. ": (table)")
            PrintTable(value, indent + 1) -- เรียกฟังก์ชันตัวเองเพื่อพิมพ์ตารางย่อย
        else
            print(indentString .. tostring(key) .. ": " .. tostring(value))
        end
    end
end

-- ฟังก์ชันสำหรับแสดงข้อมูลรายละเอียดของอาวุธทั้งหมดใน inventory เฉพาะ Sword
function ShowSwordDetails()
    -- ดึงข้อมูล inventory ของผู้เล่น
    local player = game:GetService("Players").LocalPlayer
    local inventory = GetWeaponInventory()
    
    -- ตรวจสอบว่า inventory ไม่เป็น nil ก่อนที่จะดำเนินการต่อ
    if not inventory then
        print("[ERROR]: Inventory is nil. Please check if the player has inventory data.")
        return
    end

    local allMasteryCompleted = true  -- ตัวแปรใช้ตรวจสอบว่ามี Mastery ครบทุกดาบหรือไม่

    -- ตรวจสอบรายการอาวุธใน inventory
    print("Swords in your inventory:")
    for _, weapon in pairs(inventory) do
        if type(weapon) == "table" and weapon.Type == "Sword" then
            print("Sword details:")
            PrintTable(weapon) -- เรียกใช้ฟังก์ชันเพื่อพิมพ์ข้อมูลของอาวุธประเภท Sword
            
            -- ตรวจสอบ Mastery และ MasteryRequirements
            local mastery = weapon.Mastery or 0
            if weapon.MasteryRequirements and weapon.MasteryRequirements.X then
                local masteryRequirementX = weapon.MasteryRequirements.X
                if mastery < masteryRequirementX then
                    allMasteryCompleted = false  -- ถ้ามีดาบไหน Mastery ไม่ครบ ให้ตั้งค่านี้เป็น false
                    print(weapon.Name .. " Mastery ยังไม่ครบ ❌")
                else
                    print(weapon.Name .. " Mastery ครบแล้ว ✅")
                end
            end
            print("--------------------------------------")
        end
    end

    -- ถ้า Mastery ของทุกดาบครบ ให้สร้างไฟล์
    if allMasteryCompleted then
        local fileName = player.Name .. ".txt"
        local message = "Completed-AllSwordMasteryFull"

        -- ตรวจสอบว่าฟังก์ชัน writefile ทำงานได้หรือไม่
        local success, errorMessage = pcall(function()
            writefile(fileName, message)  -- ใช้ฟังก์ชัน writefile ใน Roblox Studio plugins หรือสภาพแวดล้อมที่รองรับ
            print("File created:", fileName)
        end)

        if success then
            print("File created successfully:", fileName)
        else
            print("Error creating file:", errorMessage)
        end

        return true -- คืนค่า true เพื่อหยุดการทำงานของลูป
    else
        print("Mastery ยังไม่ครบทุกดาบ")
    end

    return false -- คืนค่า false เพื่อดำเนินการลูปต่อ
end

-- เรียกใช้ฟังก์ชันเพื่อแสดงรายละเอียดของอาวุธประเภท Sword และตรวจสอบ Mastery
ShowSwordDetails()
