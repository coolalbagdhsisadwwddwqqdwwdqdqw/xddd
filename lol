-- ✅ Roblox Translator Script with Searchable Dropdown & Autocorrect
local http_request = http_request or request or syn.request
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

-- 🌍 All 133 Google Translate-supported languages
local globalLangList = {
    {name="Afrikaans",code="af"},{name="Albanian",code="sq"},{name="Amharic",code="am"},
    {name="Arabic",code="ar"},{name="Armenian",code="hy"},{name="Assamese",code="as"},
    {name="Aymara",code="ay"},{name="Azerbaijani",code="az"},{name="Bambara",code="bm"},
    {name="Basque",code="eu"},{name="Belarusian",code="be"},{name="Bengali",code="bn"},
    {name="Bhojpuri",code="bho"},{name="Bosnian",code="bs"},{name="Bulgarian",code="bg"},
    {name="Catalan",code="ca"},{name="Cebuano",code="ceb"},{name="Chinese (Simplified)",code="zh-CN"},
    {name="Chinese (Traditional)",code="zh-TW"},{name="Corsican",code="co"},{name="Croatian",code="hr"},
    {name="Czech",code="cs"},{name="Danish",code="da"},{name="Dhivehi",code="dv"},
    {name="Dogri",code="doi"},{name="Dutch",code="nl"},{name="English",code="en"},
    {name="Esperanto",code="eo"},{name="Estonian",code="et"},{name="Ewe",code="ee"},
    {name="Filipino",code="tl"},{name="Finnish",code="fi"},{name="French",code="fr"},
    {name="Frisian",code="fy"},{name="Galician",code="gl"},{name="Georgian",code="ka"},
    {name="German",code="de"},{name="Greek",code="el"},{name="Guarani",code="gn"},
    {name="Gujarati",code="gu"},{name="Haitian Creole",code="ht"},{name="Hausa",code="ha"},
    {name="Hawaiian",code="haw"},{name="Hebrew",code="he"},{name="Hindi",code="hi"},
    {name="Hmong",code="hmn"},{name="Hungarian",code="hu"},{name="Icelandic",code="is"},
    {name="Igbo",code="ig"},{name="Ilocano",code="ilo"},{name="Indonesian",code="id"},
    {name="Irish",code="ga"},{name="Italian",code="it"},{name="Japanese",code="ja"},
    {name="Javanese",code="jv"},{name="Kannada",code="kn"},{name="Kazakh",code="kk"},
    {name="Khmer",code="km"},{name="Kinyarwanda",code="rw"},{name="Konkani",code="gom"},
    {name="Korean",code="ko"},{name="Krio",code="kri"},{name="Kurdish (Kurmanji)",code="ku"},
    {name="Kurdish (Sorani)",code="ckb"},{name="Kyrgyz",code="ky"},{name="Lao",code="lo"},
    {name="Latin",code="la"},{name="Latvian",code="lv"},{name="Lingala",code="ln"},
    {name="Lithuanian",code="lt"},{name="Luxembourgish",code="lb"},{name="Macedonian",code="mk"},
    {name="Maithili",code="mai"},{name="Malagasy",code="mg"},{name="Malay",code="ms"},
    {name="Malayalam",code="ml"},{name="Maltese",code="mt"},{name="Maori",code="mi"},
    {name="Marathi",code="mr"},{name="Meiteilon (Manipuri)",code="mni-Mtei"},{name="Mizo",code="lus"},
    {name="Mongolian",code="mn"},{name="Myanmar (Burmese)",code="my"},{name="Nepali",code="ne"},
    {name="Norwegian",code="no"},{name="Nyanja (Chichewa)",code="ny"},{name="Odia (Oriya)",code="or"},
    {name="Oromo",code="om"},{name="Pashto",code="ps"},{name="Persian",code="fa"},
    {name="Polish",code="pl"},{name="Portuguese",code="pt"},{name="Punjabi",code="pa"},
    {name="Quechua",code="qu"},{name="Romanian",code="ro"},{name="Russian",code="ru"},
    {name="Samoan",code="sm"},{name="Sanskrit",code="sa"},{name="Scots Gaelic",code="gd"},
    {name="Sepedi",code="nso"},{name="Serbian",code="sr"},{name="Sesotho",code="st"},
    {name="Shona",code="sn"},{name="Sindhi",code="sd"},{name="Sinhala",code="si"},
    {name="Slovak",code="sk"},{name="Slovenian",code="sl"},{name="Somali",code="so"},
    {name="Spanish",code="es"},{name="Sundanese",code="su"},{name="Swahili",code="sw"},
    {name="Swedish",code="sv"},{name="Tagalog",code="tl"},{name="Tajik",code="tg"},
    {name="Tamil",code="ta"},{name="Tatar",code="tt"},{name="Telugu",code="te"},
    {name="Thai",code="th"},{name="Tigrinya",code="ti"},{name="Tsonga",code="ts"},
    {name="Turkish",code="tr"},{name="Turkmen",code="tk"},{name="Twi",code="ak"},
    {name="Ukrainian",code="uk"},{name="Urdu",code="ur"},{name="Uyghur",code="ug"},
    {name="Uzbek",code="uz"},{name="Vietnamese",code="vi"},{name="Welsh",code="cy"},
    {name="Xhosa",code="xh"},{name="Yiddish",code="yi"},{name="Yoruba",code="yo"},
    {name="Zulu",code="zu"}
}

local currentLangIndex = 1
local targetLanguage = globalLangList[currentLangIndex].code

-- 🧾 Create GUI
local gui = Instance.new("ScreenGui", game:GetService("CoreGui"))
gui.Name = "TranslatorUI"

local textBox = Instance.new("TextBox", gui)
textBox.Size = UDim2.new(0, 400, 0, 40)
textBox.Position = UDim2.new(0.5, -200, 0.85, 0)
textBox.PlaceholderText = "Type in English..."
textBox.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
textBox.TextColor3 = Color3.new(1, 1, 1)
textBox.TextSize = 18
textBox.Font = Enum.Font.SourceSansBold
Instance.new("UICorner", textBox).CornerRadius = UDim.new(0, 6)

local langButton = Instance.new("TextButton", gui)
langButton.Size = UDim2.new(0, 250, 0, 30)
langButton.Position = UDim2.new(0.5, -125, 0.78, 0)
langButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
langButton.TextColor3 = Color3.new(1, 1, 1)
langButton.TextSize = 14
langButton.Text = "Language: " .. globalLangList[currentLangIndex].name
Instance.new("UICorner", langButton).CornerRadius = UDim.new(0, 6)
-- 🧾 Create a Label to Display Translated Text
local resultLabel = Instance.new("TextLabel", gui)
resultLabel.Size = UDim2.new(0, 400, 0, 40)
resultLabel.Position = UDim2.new(0.5, -200, 0.75, 0)
resultLabel.Text = "Translation: "
resultLabel.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
resultLabel.TextColor3 = Color3.new(1, 1, 1)
resultLabel.TextSize = 18
resultLabel.Font = Enum.Font.SourceSansBold
Instance.new("UICorner", resultLabel).CornerRadius = UDim.new(0, 6)

-- 🧾 Create Language Dropdown (Searchable)
local dropdownFrame = Instance.new("Frame", gui)
dropdownFrame.Size = UDim2.new(0, 250, 0, 200)
dropdownFrame.Position = UDim2.new(0.5, -125, 0.7, 0)
dropdownFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
dropdownFrame.Visible = false

local dropdownList = Instance.new("UIListLayout", dropdownFrame)
dropdownList.SortOrder = Enum.SortOrder.LayoutOrder
dropdownList.Padding = UDim.new(0, 5)

local function createDropdownButton(lang)
    local button = Instance.new("TextButton", dropdownFrame)
    button.Size = UDim2.new(1, 0, 0, 30)
    button.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    button.TextColor3 = Color3.new(1, 1, 1)
    button.TextSize = 14
    button.Text = lang.name
    button.TextWrapped = true
    button.MouseButton1Click:Connect(function()
        targetLanguage = lang.code
        langButton.Text = "Language: " .. lang.name
        dropdownFrame.Visible = false
    end)
    return button
end

-- Function to filter languages based on user input
local function filterLanguages(inputText)
    local lowerInput = inputText:lower()
    for _, button in pairs(dropdownFrame:GetChildren()) do
        if button:IsA("TextButton") then
            button.Visible = button.Text:lower():find(lowerInput, 1, true)
        end
    end
end

-- 🧾 Toggle Dropdown Visibility
langButton.MouseButton1Click:Connect(function()
    dropdownFrame.Visible = not dropdownFrame.Visible
    -- Clear existing dropdown list
    for _, child in pairs(dropdownFrame:GetChildren()) do
        if child:IsA("TextButton") then
            child:Destroy()
        end
    end
    -- Add languages to the dropdown
    for _, lang in ipairs(globalLangList) do
        createDropdownButton(lang)
    end
end)

-- 🧾 Add Search Functionality for the Dropdown
textBox:GetPropertyChangedSignal("Text"):Connect(function()
    local inputText = textBox.Text
    filterLanguages(inputText)
end)

-- 🧾 Translate Function (API Integration)
local function translateText(inputText)
    local url = "https://translation.googleapis.com/language/translate/v2"
    local apiKey = "YOUR_GOOGLE_API_KEY_HERE"  -- Replace with your API key
    local body = {
        q = inputText,
        target = targetLanguage,
        format = "text",
        key = apiKey
    }
    
    local response = http_request({
        Url = url,
        Method = "POST",
        Body = game:GetService("HttpService"):JSONEncode(body),
        Headers = {["Content-Type"] = "application/json"}
    })
    
    local result = game:GetService("HttpService"):JSONDecode(response.Body)
    return result.data.translations[1].translatedText
end

-- 🧾 Translate Text on Input
textBox.FocusLost:Connect(function()
    local inputText = textBox.Text
    if inputText ~= "" then
        -- Show the translation result
        local translatedText = translateText(inputText)
        resultLabel.Text = "Translation: " .. translatedText
    end
end)
