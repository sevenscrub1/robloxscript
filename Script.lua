-- Noclip com pet Brainrot + UI - Roblox

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local allowedUserIds = {123456789} -- Coloque seu UserId aqui

local noclipActive = false
local character = nil

local function isAllowed()
	for _, id in ipairs(allowedUserIds) do
		if player.UserId == id then
			return true
		end
	end
	return false
end

local function setupCharacter(char)
	character = char
end

player.CharacterAdded:Connect(setupCharacter)
if player.Character then setupCharacter(player.Character) end

local function disableCollision(model)
	for _, part in ipairs(model:GetDescendants()) do
		if part:IsA("BasePart") and part.CanCollide then
			part.CanCollide = false
		end
	end
end

local function smoothVelocity(model)
	for _, part in ipairs(model:GetDescendants()) do
		if part:IsA("BasePart") then
			local vel = part.AssemblyLinearVelocity
			if vel.Magnitude > 0.05 then
				part.AssemblyLinearVelocity = vel:Lerp(Vector3.new(0,0,0), 0.3)
			end
		end
	end
end

local function getPet()
	if character then
		local pet = character:FindFirstChild("BrainrotPet") -- Ajuste o nome do pet aqui
		if pet then
			return pet
		end
	end
	return nil
end

-- Criar a UI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "NoclipUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = player:WaitForChild("PlayerGui")

local button = Instance.new("TextButton")
button.Size = UDim2.new(0, 150, 0, 40)
button.Position = UDim2.new(0, 20, 0, 20)
button.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
button.TextColor3 = Color3.new(1, 1, 1)
button.Text = "Ativar Noclip"
button.Parent = screenGui

local statusLabel = Instance.new("TextLabel")
statusLabel.Size = UDim2.new(0, 150, 0, 25)
statusLabel.Position = UDim2.new(0, 20, 0, 65)
statusLabel.BackgroundTransparency = 1
statusLabel.TextColor3 = Color3.new(1, 1, 1)
statusLabel.Text = "Status: Desativado"
statusLabel.Parent = screenGui

local function updateUI()
	if noclipActive then
		button.Text = "Desativar Noclip"
		statusLabel.Text = "Status: Ativado"
	else
		button.Text = "Ativar Noclip"
		statusLabel.Text = "Status: Desativado"
	end
end

button.MouseButton1Click:Connect(function()
	if not isAllowed() then return end
	noclipActive = not noclipActive
	updateUI()
	print(noclipActive and "✅ Noclip ativado" or "❌ Noclip desativado")
end)

RunService.Heartbeat:Connect(function()
	if noclipActive and character and character.Parent then
		disableCollision(character)
		smoothVelocity(character)
		
		local pet = getPet()
		if pet then
			disableCollision(pet)
			smoothVelocity(pet)
		end
	end
end)

updateUI()
