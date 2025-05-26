local Lib = {}
local UIS = game:GetService("UserInputService")
local StarterGui = game:GetService("StarterGui")

local Themes = {
	impulse = {
		Background = Color3.fromRGB(30,30,30),
		Accent = Color3.fromRGB(43, 141, 86),         
		Foreground = Color3.fromRGB(45, 45, 45),   
		Text = Color3.fromRGB(76, 245, 152),
		Hover = Color3.fromRGB(56, 200, 120)
	},
	dark = {
		Background = Color3.fromRGB(32, 32, 32),
		Accent = Color3.fromRGB(0, 153, 255),
		Foreground = Color3.fromRGB(45, 45, 45),
		Text = Color3.fromRGB(255, 255, 255),
		Hover = Color3.fromRGB(70, 70, 70)
	},
	light = {
		Background = Color3.fromRGB(255, 255, 255),
		Accent = Color3.fromRGB(150, 150, 150),
		Foreground = Color3.fromRGB(200, 200, 200),
		Text = Color3.fromRGB(0, 0, 0),
		Hover = Color3.fromRGB(224, 224, 224)
	},
	blood = {
		Background = Color3.fromRGB(10, 10, 10),
		Accent = Color3.fromRGB(227, 27, 27),
		Foreground = Color3.fromRGB(5, 5, 5),
		Text = Color3.fromRGB(255, 255, 255),
		Hover = Color3.fromRGB(20, 20, 20)
	},
	grape = {
		Background = Color3.fromRGB(64, 50, 71),
		Accent = Color3.fromRGB(166, 71, 214),
		Foreground = Color3.fromRGB(36, 28, 41),
		Text = Color3.fromRGB(255, 255, 255),
		Hover = Color3.fromRGB(74, 58, 84)
	},
	ocean = {
		Background = Color3.fromRGB(26, 32, 58),
		Accent = Color3.fromRGB(86, 76, 251),
		Foreground = Color3.fromRGB(38, 45, 71),
		Text = Color3.fromRGB(200, 200, 200),
		Hover = Color3.fromRGB(38, 45, 71)
	},
	midnight = {
		Background = Color3.fromRGB(44, 62, 82),
		Accent = Color3.fromRGB(26, 189, 158),
		Foreground = Color3.fromRGB(57, 81, 105),
		Text = Color3.fromRGB(255, 255, 255),
		Hover = Color3.fromRGB(52, 74, 95)
	},
	sentinel = {
		Background = Color3.fromRGB(32, 32, 32),
		Accent = Color3.fromRGB(230, 35, 69),
		Foreground = Color3.fromRGB(24, 24, 24),
		Text = Color3.fromRGB(119, 209, 138),
		Hover = Color3.fromRGB(24, 24, 24)
	},
	synapse = {
		Background = Color3.fromRGB(13, 15, 12),
		Accent = Color3.fromRGB(46, 48, 43),
		Foreground = Color3.fromRGB(36, 38, 35),
		Text = Color3.fromRGB(152, 99, 53),
		Hover = Color3.fromRGB(24, 24, 24)
	},
	serpent = {
		Background = Color3.fromRGB(31, 41, 43),
		Accent = Color3.fromRGB(0, 166, 58),
		Foreground = Color3.fromRGB(22, 29, 31),
		Text = Color3.fromRGB(255, 255, 255),
		Hover = Color3.fromRGB(22, 29, 31)
	}
}

Lib._hubName = nil
Lib._actualName = nil
Lib._screenGui = nil
Lib._mainFrame = nil
Lib._tabs = nil
Lib._visible = true

dragToggle = nil
dragSpeed = 0.25
dragStart = nil
startPos = nil
sliderDragging = false

function updateDragInput(input,frame)
	local delta = input.Position - dragStart
	local position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X,
		startPos.Y.Scale, startPos.Y.Offset + delta.Y)
	game:GetService('TweenService'):Create(frame, TweenInfo.new(dragSpeed), {Position = position}):Play()
end

function makelibname()
	math.randomseed(os.time())

	local numbers = "0123456789"
	local letters_lower = "abcdefghijklmnopqrstuvwxyz"
	local letters_upper = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
	local symbols = "!@#$%^&*()_-"

	local all_chars = numbers .. letters_lower .. letters_upper .. symbols
	local char_count = #all_chars

	local name_length = math.random(8, 16)

	local generated_name = ""
	for i = 1, name_length do
		local random_index = math.random(1, char_count)
		generated_name = generated_name .. string.sub(all_chars, random_index, random_index)
	end

	return generated_name
end

function Lib:CreateWindow(themeName, hubName)
	local colors = Themes[themeName:lower()] or Themes.impulse
	self._actualName = makelibname()
	self._hubName = hubName
	
	if self._screenGui then
		self._screenGui:Destroy()
	end

	local screenGui = Instance.new("ScreenGui")
	screenGui.Name = self._actualName
	screenGui.ResetOnSpawn = false
	screenGui.Parent = StarterGui

	local mainFrame = Instance.new("Frame", screenGui)
	mainFrame.Name = "MainFrame"
	mainFrame.Size = UDim2.new(0, 500, 0, 350)
	mainFrame.Position = UDim2.new(0.5, -250, 0.5, -175)
	mainFrame.BackgroundColor3 = colors.Background
	mainFrame.BorderSizePixel = 0
	mainFrame.ClipsDescendants = true
	self._mainFrame = mainFrame
	
	mainFrame.InputBegan:Connect(function(input)
		if sliderDragging then return end -- 🔒 Prevent dragging while slider is active
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragToggle = true
			dragStart = input.Position
			startPos = mainFrame.Position

			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then
					dragToggle = false
				end
			end)
		end
	end)

	UIS.InputChanged:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
			if dragToggle then
				updateDragInput(input,mainFrame)
			end
		end
	end)

	local titleBar = Instance.new("Frame", mainFrame)
	titleBar.Name = "TitleBar"
	titleBar.Size = UDim2.new(1, 0, 0, 36)
	titleBar.BackgroundColor3 = colors.Foreground

	local titleLabel = Instance.new("TextLabel", titleBar)
	titleLabel.Name = "TitleLabel"
	titleLabel.Size = UDim2.new(1, -40, 1, 0)
	titleLabel.Position = UDim2.new(0, 12, 0, 0)
	titleLabel.BackgroundTransparency = 1
	titleLabel.Font = Enum.Font.GothamBold
	titleLabel.TextSize = 18
	titleLabel.TextColor3 = colors.Text
	titleLabel.TextXAlignment = Enum.TextXAlignment.Left
	titleLabel.Text = self._hubName

	local closeButton = Instance.new("TextButton", titleBar)
	closeButton.Name = "CloseButton"
	closeButton.Size = UDim2.new(0, 36, 1, 0)
	closeButton.Position = UDim2.new(1, -36, 0, 0)
	closeButton.BackgroundColor3 = colors.Accent
	closeButton.Font = Enum.Font.GothamBold
	closeButton.TextSize = 18
	closeButton.TextColor3 = colors.Text
	closeButton.Text = "X"
	closeButton.AutoButtonColor = false

	closeButton.MouseEnter:Connect(function()
		closeButton.BackgroundColor3 = Color3.fromRGB(255, 85, 85)
	end)
	closeButton.MouseLeave:Connect(function()
		closeButton.BackgroundColor3 = colors.Accent
	end)
	closeButton.MouseButton1Click:Connect(function()
		self:ToggleUI()
	end)

	local tabsFrame = Instance.new("Frame", mainFrame)
	tabsFrame.Name = "TabsFrame"
	tabsFrame.Size = UDim2.new(0, 110, 1, -36)
	tabsFrame.Position = UDim2.new(0, 0, 0, 36)
	tabsFrame.BackgroundColor3 = colors.Foreground
	tabsFrame.BorderSizePixel = 0
	tabsFrame.ClipsDescendants = true

	local tabsList = Instance.new("UIListLayout", tabsFrame)
	tabsList.SortOrder = Enum.SortOrder.LayoutOrder
	tabsList.Padding = UDim.new(0, 4)

	local pagesFrame = Instance.new("Frame", mainFrame)
	pagesFrame.Name = "PagesFrame"
	pagesFrame.Size = UDim2.new(1, -110, 1, -36)
	pagesFrame.Position = UDim2.new(0, 110, 0, 36)
	pagesFrame.BackgroundColor3 = colors.Background
	pagesFrame.BorderSizePixel = 0
	pagesFrame.ClipsDescendants = true

	self._screenGui = screenGui
	self._tabs = {}
	self._pagesFrame = pagesFrame
	self._tabsFrame = tabsFrame
	self._colors = colors

	local window = {}

	function Lib:ToggleUI()
		self._visible = not self._visible
		if self._screenGui then
			self._screenGui.Enabled = self._visible
		end
	end

	function Lib:DestroyUI()
		if self._screenGui then
			self._screenGui:Destroy()
			self._screenGui = nil
			self._mainFrame = nil
			self._tabs = nil
			self._pagesFrame = nil
			self._tabsFrame = nil
			self._visible = false
			self._uiName = nil
		end
	end

	function Lib:GetUIName()
		return self._actualName
	end

	function window:NewTab(name)
		local colors = Lib._colors

		local tabButton = Instance.new("TextButton", Lib._tabsFrame)
		tabButton.Name = name .. "Tab"
		tabButton.Size = UDim2.new(1, -8, 0, 28)
		tabButton.BackgroundColor3 = colors.Foreground
		tabButton.TextColor3 = colors.Text
		tabButton.Font = Enum.Font.Gotham
		tabButton.TextSize = 14
		tabButton.Text = name
		tabButton.BorderSizePixel = 0
		tabButton.AutoButtonColor = false

		tabButton.MouseEnter:Connect(function()
			tabButton.BackgroundColor3 = colors.Hover
		end)
		tabButton.MouseLeave:Connect(function()
			if not tabButton:GetAttribute("Selected") then
				tabButton.BackgroundColor3 = colors.Foreground
			end
		end)

		local page = Instance.new("ScrollingFrame", Lib._pagesFrame)
		page.Name = name .. "Page"
		page.Size = UDim2.new(1, 0, 1, 0)
		page.BackgroundColor3 = colors.Background
		page.BorderSizePixel = 0
		page.Visible = false
		page.CanvasSize = UDim2.new(0, 0, 1, 0)
		page.ScrollBarThickness = 6
		page.AutomaticCanvasSize = Enum.AutomaticSize.Y

		local layout = Instance.new("UIListLayout", page)
		layout.Padding = UDim.new(0, 6)
		layout.SortOrder = Enum.SortOrder.LayoutOrder

		local function selectTab()
			for _, t in pairs(Lib._tabsFrame:GetChildren()) do
				if t:IsA("TextButton") then
					t:SetAttribute("Selected", false)
					t.BackgroundColor3 = colors.Foreground
				end
			end
			for _, p in pairs(Lib._pagesFrame:GetChildren()) do
				if p:IsA("ScrollingFrame") then
					p.Visible = false
				end
			end
			tabButton:SetAttribute("Selected", true)
			tabButton.BackgroundColor3 = colors.Accent
			page.Visible = true
		end

		if #Lib._tabs == 0 then
			selectTab()
		end

		tabButton.MouseButton1Click:Connect(selectTab)

		local tab = {}

		function tab:NewButton(text, callback)
			local button = Instance.new("TextButton", page)
			button.Size = UDim2.new(1, -10, 0, 30)
			button.BackgroundColor3 = colors.Foreground
			button.BorderSizePixel = 0
			button.Font = Enum.Font.Gotham
			button.TextSize = 14
			button.TextColor3 = colors.Text
			button.Text = text
			button.AutoButtonColor = false

			button.MouseEnter:Connect(function()
				button.BackgroundColor3 = colors.Hover
			end)
			button.MouseLeave:Connect(function()
				button.BackgroundColor3 = colors.Foreground
			end)

			button.MouseButton1Click:Connect(function()
				pcall(callback)
			end)

			return button
		end

		function tab:NewToggle(text, default, callback)
			local toggle = Instance.new("TextButton", page)
			toggle.Size = UDim2.new(1, -10, 0, 30)
			toggle.BackgroundColor3 = colors.Foreground
			toggle.BorderSizePixel = 0
			toggle.Font = Enum.Font.Gotham
			toggle.TextSize = 14
			toggle.TextColor3 = colors.Text
			toggle.AutoButtonColor = false

			local toggled = default or false
			toggle.Text = text .. (toggled and ": ON" or ": OFF")

			toggle.MouseEnter:Connect(function()
				toggle.BackgroundColor3 = colors.Hover
			end)
			toggle.MouseLeave:Connect(function()
				toggle.BackgroundColor3 = colors.Foreground
			end)

			toggle.MouseButton1Click:Connect(function()
				toggled = not toggled
				toggle.Text = text .. (toggled and ": ON" or ": OFF")
				pcall(callback, toggled)
			end)

			return toggle
		end

		function tab:NewSlider(text, min, max, default, callback)
			min = tonumber(min) or 0
			max = tonumber(max) or 100
			default = tonumber(default) or min

			if type(min) ~= "number" or type(max) ~= "number" then
				warn("[Slider] min/max must be numbers.")
				return nil
			end

			local frame = Instance.new("Frame")
			frame.Size = UDim2.new(1, -10, 0, 50)
			frame.BackgroundColor3 = colors.Foreground
			frame.BorderSizePixel = 0
			frame.Parent = page

			local label = Instance.new("TextLabel")
			label.Size = UDim2.new(1, 0, 0, 20)
			label.BackgroundTransparency = 1
			label.Font = Enum.Font.Gotham
			label.TextSize = 14
			label.TextColor3 = colors.Text
			label.Text = text .. ": " .. default
			label.TextXAlignment = Enum.TextXAlignment.Left
			label.Parent = frame

			local sliderBar = Instance.new("Frame")
			sliderBar.Size = UDim2.new(1, -20, 0, 10)
			sliderBar.Position = UDim2.new(0, 10, 0, 30)
			sliderBar.BackgroundColor3 = colors.Background
			sliderBar.BorderSizePixel = 0
			sliderBar.Parent = frame

			local fill = Instance.new("Frame")
			fill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
			fill.BackgroundColor3 = colors.Accent
			fill.BorderSizePixel = 0
			fill.Parent = sliderBar

			local dragging = false

			local function update(input)
				if dragToggle then return end -- ✅ live check
				local pos = input.Position.X - sliderBar.AbsolutePosition.X
				local ratio = math.clamp(pos / sliderBar.AbsoluteSize.X, 0, 1)
				fill.Size = UDim2.new(ratio, 0, 1, 0)
				local value = math.floor(min + (max - min) * ratio)
				label.Text = text .. ": " .. value
				pcall(callback, value)
			end

			sliderBar.InputBegan:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 then
					sliderDragging = true
					dragging = true -- ✅ Needed to allow update() to work
					dragToggle = false
				end
			end)

			UIS.InputEnded:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 then
					sliderDragging = false
					dragging = false -- ✅ Stop updating
				end
			end)

			UIS.InputChanged:Connect(function(input)
				if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
					update(input)
				end
			end)

			return frame
		end

		function tab:NewKeybind(text, defaultKey, callback)
			local keybindBtn = Instance.new("TextButton", page)
			keybindBtn.Size = UDim2.new(1, -10, 0, 30)
			keybindBtn.BackgroundColor3 = colors.Foreground
			keybindBtn.BorderSizePixel = 0
			keybindBtn.Font = Enum.Font.Gotham
			keybindBtn.TextSize = 14
			keybindBtn.TextColor3 = colors.Text
			keybindBtn.Text = text .. ": " .. tostring(defaultKey or "None")
			keybindBtn.AutoButtonColor = false

			local listening = false
			local key = defaultKey

			local function updateText()
				keybindBtn.Text = text .. ": " .. tostring(key or "None")
			end

			keybindBtn.MouseEnter:Connect(function()
				keybindBtn.BackgroundColor3 = colors.Hover
			end)
			keybindBtn.MouseLeave:Connect(function()
				keybindBtn.BackgroundColor3 = colors.Foreground
			end)

			keybindBtn.MouseButton1Click:Connect(function()
				if not listening then
					listening = true
					keybindBtn.Text = text .. ": ..."
				end
			end)

			local connection
			connection = UIS.InputBegan:Connect(function(input, gameProcessed)
				if listening and not gameProcessed and input.UserInputType == Enum.UserInputType.Keyboard then
					key = input.KeyCode.Name
					updateText()
					listening = false
					pcall(callback, Enum.KeyCode[key])
				end
			end)

			return keybindBtn
		end

		function tab:NewLabel(text)
			local label = Instance.new("TextLabel", page)
			label.Size = UDim2.new(1, -10, 0, 20)
			label.BackgroundTransparency = 1
			label.Font = Enum.Font.Gotham
			label.TextSize = 14
			label.TextColor3 = colors.Text
			label.Text = text
			label.TextXAlignment = Enum.TextXAlignment.Left
			return label
		end

		table.insert(Lib._tabs, tabButton)

		return tab
	end

	function Lib:Notify(title, text, duration)
		StarterGui:SetCore("SendNotification", {
			Title = title or "Notification",
			Text = text or "",
			Duration = duration or 5,
			Button1 = "Alright",
			Callback = function() end,
		})
	end
	
	function Lib:KeybindToggleUI(keybind, enabled)
		if self._bindconnection then
			self._bindconnection:Disconnect()
			self._bindconnection = nil
		end

		if enabled then
			local targetKeyCode = Enum.KeyCode[keybind] 

			if not targetKeyCode then
				warn("Invalid keybind string provided:", keybind)
				return
			end

			self._bindconnection = UIS.InputBegan:Connect(function(input, gp)
				if not gp and input.UserInputType == Enum.UserInputType.Keyboard then
					if input.KeyCode == targetKeyCode then
						self:ToggleUI()
					end
				end
			end)
		end
	end
	
	function Lib:InviteDisCord(invitelink)
		StarterGui:SetCore("SendNotification", {
			Title = "Join our discord server!",
			Text = "Invite link copied!",
			Duration = 15,
		})
		StarterGui:SetCore("SendNotification", {
			Title = "Discord server:",
			Text = invitelink,
			Duration = 15,
		})
		if setclipboard then
			setclipboard(invitelink)
		else
			warn("tbh how shitty can your executor get when it doesnt support setclipboard :sob: :pray:")
		end
	end

	return window
end

return Lib
