-- Noclip com Pet e UI - Versão estável e sem erros

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local allowedUserIds = {123456789} -- ← Substitua por seu UserId

local noclipActive = false
local character = nil

-- Detecta se o jogador está autorizado a usar o script
local function isAllowed()
	for _, id in ipairs(allowedUserIds) do
		if player.UserId == id then
			return true
		end
	end
	return false
end

-- Atualiza o personagem ao spawnar
local function setupCharacter(char)
	character = char
end

player.CharacterAdded:Connect(setupCharacter)
if player.Character then setupCharacter(player.Character) end

-- Desativa colisão das partes do modelo
local function disableCollision(model)
	for _, part in ipairs(model:GetDescendants()) do
		if part:IsA("BasePart") then
			part.CanCollide = false
		end
	end
end

-- Suaviza a velocidade para não ser detectado por movimento brusco
local function smoothVelocity(model)
	for _, part in ipairs(model:GetDescendants()) do
		if part:IsA("BasePart") then
			local vel = part.AssemblyLinearVelocity
			if vel.Magnitude > 0.05 then
				part.AssemblyLinearVelocity = vel:Lerp(Vector3.new(0, 0, 0), 0.3)
			end
		end
	end
end

-- Retorna o pet (troque o nome se for diferente no seu jogo)
local function getPet()
	if character then
		local pet = character:FindFirstChild("BrainrotPet") -- ← Altere o nome se necessário
		return pet
	end
	return nil
end

-- Criação da UI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "NoclipUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = player:WaitForChild("PlayerGui")

local button = Instance.new("TextButton")
button.Size = UDim2.new(0, 150, 0, 40)
button.Position = UDim2.new(0, 20,
