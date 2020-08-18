local color = {}
color.__index = color

function color.DegToRad(n)
    return n * math.pi / 180
end

function color.RadToDeg(n)
    return (n + math.pi) / (2 * math.pi) * 360
end

function color.ToPolar(n)
    return math.atan2(n.Y, n.X), n.Magnitude
end

function color.ToCartesian(distance, theta)
    return math.sin(theta) * distance, math.cos(theta) * distance
end

function color:UpdateSlide(mousePos)
    local slider = self.Frame.Wheel.Slider
    local rY, dist = mousePos.Y - slider.AbsolutePosition.Y, slider.AbsoluteSize.Y - slider.Slide.AbsoluteSize.Y
    local cY = math.clamp(rY, 0, dist)
    slider.Slide.Position = UDim2.new(0, 0, 0, cY)

    self.Value = 1 - (cY / dist)
    slider.Slide.BackgroundColor3 = Color3.fromHSV(0, 0, 1 - self.Value)
    self:Update()
end

function color:UpdateRing(mousePos)
    local wheel = self.Frame.Wheel
    local radius = wheel.AbsoluteSize.X / 2
    local distance = mousePos - wheel.AbsolutePosition - wheel.AbsoluteSize / 2
    if distance:Dot(distance) > radius * radius then
        distance = distance.Unit * radius
    end
    wheel.Diamond.Position = UDim2.new(0.5, distance.X, 0.5, distance.Y)

    local phi, length = self.ToPolar(distance * Vector2.new(1, -1))
    self.Hue, self.Saturation = self.RadToDeg(phi) / 360, length / radius
    wheel.Slider.BackgroundColor3 = Color3.fromHSV(self.Hue, self.Saturation, 1)
    self:Update()
end

function color:UpdateRGB()
    local values, wheel = self.Frame.Colors.Values, self.Frame.Wheel
    local color3 = Color3.fromRGB(
        tonumber(string.match(values.RValue.Text, "%d+")),
        tonumber(string.match(values.GValue.Text, "%d+")),
        tonumber(string.match(values.BValue.Text, "%d+"))
    )
    self.Hue, self.Saturation, self.Value = Color3.toHSV(color3)
    workspace.Baseplate.Color = color3

    local radius = wheel.AbsoluteSize.X / 2
    local x, y = self.ToCartesian(self.Saturation, -math.rad(self.Hue * 360))
    wheel.Diamond.Position = UDim2.new(0.5, -x * radius, 0.5, -y * radius)
    wheel.Slider.BackgroundColor3 = Color3.fromHSV(self.Hue, self.Saturation, 1)
    wheel.Slider.Slide.BackgroundColor3 = Color3.fromHSV(0, 0, 1 - self.Value)

    values.RValue.Text = math.ceil(color3.R * 255)
    values.GValue.Text = math.ceil(color3.G * 255)
    values.BValue.Text = math.ceil(color3.B * 255)

    values.HValue.Text = math.floor(self.Hue * (180 / math.pi))
    values.SValue.Text = self.Saturation * 100 .. "%"
    values.VValue.Text = self.Value * 100 .. "%"
end

function color:Update()
    local hsv3, values = Color3.fromHSV(self.Hue, self.Saturation, self.Value), self.Frame.Colors.Values
    workspace.Baseplate.Color = hsv3

    values.RValue.Text = math.ceil(hsv3.R * 255)
    values.GValue.Text = math.ceil(hsv3.G * 255)
    values.BValue.Text = math.ceil(hsv3.B * 255)

    values.HValue.Text = math.floor(self.Hue * (180 / math.pi))
    values.SValue.Text = self.Saturation * 100 .. "%"
    values.VValue.Text = self.Value * 100 .. "%"
end

function color.new(plr, parent)
    local colorPicker = script.ColorBackground:Clone()
    colorPicker.Parent = parent

    local mouse = plr:GetMouse()
    local info = setmetatable({["Hue"] = 0, ["Saturation"] = 0, ["Value"] = 1, ["Frame"] = colorPicker, ["WheelDown"] = false, ["SliderDown"] = false, ["Connections"] = {}}, color)
    table.insert(info.Connections, info.Frame.Wheel.MouseButton1Down:Connect(function()
        info.WheelDown = true
        info:UpdateRing(Vector2.new(mouse.X, mouse.Y))           
    end))

    table.insert(info.Connections, info.Frame.Wheel.Slider.MouseButton1Down:Connect(function()
        info.SliderDown = true
        info:UpdateSlide(Vector2.new(mouse.X, mouse.Y))
    end))

    table.insert(info.Connections, mouse.Move:Connect(function()
        if info.WheelDown then
            info:UpdateRing(Vector2.new(mouse.X, mouse.Y))
        elseif info.SliderDown then
            info:UpdateSlide(Vector2.new(mouse.X, mouse.Y))
        end
    end))

    table.insert(info.Connections, game:GetService("UserInputService").InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            info.WheelDown = false
            info.SliderDown = false
        end
    end))

    for _, textBox in pairs(info.Frame.Colors.Values:GetChildren()) do
        table.insert(info.Connections, textBox.FocusLost:Connect(function()
            info:UpdateRGB()
        end))
    end
    return info
end

function color:Disconnect()
    for _, connection in pairs(self.Connections) do
        connection:Disconnect()
    end
    self.Connections = {}
end

function color:Destroy()
    self.Frame:Destroy()
    self = nil
end

return color