--[[
	Russian translation by StingerSoft!
]]

------------------------------------------------------------------------------------------------------
-- Setup the locale library
------------------------------------------------------------------------------------------------------
local L = LibStub("AceLocale-3.0"):NewLocale("Cryolysis3", "ruRU");
if not L then return end

------------------------------------------------------------------------------------------------------
-- LoD (Load on Demand) error strings
------------------------------------------------------------------------------------------------------
L["Cryolysis 3 cannot load the module:"] = "Cryolysis 3 не может загрузить модуль:";

L["The module is flagged as Disabled in the Blizzard AddOn interface."] = "Данный модуль отмечен как выключенный в меню модификаций.";
L["The module is missing. Please close the game and install it."] = "Данный модуль отсутствует. Пожалуйста закройте игру и установите его.";
L["The module is too old. Please close the game and update it."] = "Данный модуль устарел. Пожалуйста закройте игру и обновите его.";
L["Cryolysis 3 is currently adding items to your game's item cache.  The addon should finish loading and this dialog box should disappear once this is complete."] = "Cryolysis 3 в данный момент добавляет предметы в ваш игровой кеш предметов.  Аддон должен закончить загрузку и это диалоговое окно должно исчезнуть, как только всё будет загружено.";

L["Okay"] = "Ок";


------------------------------------------------------------------------------------------------------
-- Common messages
------------------------------------------------------------------------------------------------------
L["Found Mount: "] = "Найден транспорт: ";


------------------------------------------------------------------------------------------------------
-- Tooltips
------------------------------------------------------------------------------------------------------
L["Mount"] = "Ездовые животные";
	-- Mount button locales
	L["Left click to Hearthstone to "] = "[Левый клик] для возвращения в ";
	L["Left click to use "] = "[Левый клик] использовать ";
	L["Right click to use "] = "[Правый клик] использовать ";
	L["You are not in a flyable area and you have no selected ground mount."] = "Вы находитесь на територии где полёты запрещены, и у вас не выбрано наземное животное.";
	L["You have no usable mounts and no hearthstone."] = "У вас нет используемых ездовых животных и нет камня возвращения.";
	L["Right click to Hearthstone to "] = "[Правый клик] для возвращения в ";
	L["Middle click to Hearthstone to "] = "[Средний клик] для возвращения в ";

L["Custom Button"] = "Пользовательские кнопки";
	-- Custom button locales
	L["No actions assigned to this button."] = "Нет назначенных действий для данной кнопки ";
	L["You can assign an action to this button using the Cryolysis menu."] = "Вы можете назначить действие для данной кнопки в меню Cryolysisа";
	L["Left"] = "Левый";	-- For use in bottom most translation
	L["Right"] = "Правый";	-- For use in bottom most translation
	L["Middle"] = "Средний";	-- For use in bottom most translation
	L["cast"] = "применение";	-- Lower case intended (For use in bottom most translation)
	L["use"] = "использование";	-- Lower case intended (For use in bottom most translation)
	L["%s click to %s: %s"] = "%s клик %s: %s";

------------------------------------------------------------------------------------------------------
-- Slash command locales
------------------------------------------------------------------------------------------------------
L["Show Menu"] = "Показать меню";
L["Open the configuration menu."] = "Открыть меню настроек";


------------------------------------------------------------------------------------------------------
-- Options
------------------------------------------------------------------------------------------------------
L["Cryolysis"] = "Cryolysis";
L["Cryolysis 3 is an all-purpose sphere AddOn."] = "Cryolysis 3 is an all-purpose sphere AddOn.";

-- General Options
L["General Settings"] = "Основные настройки";
L["Adjust various settings for Cryolysis 3."] = "Различные настройки для Криолизиса 3.";
L["Lock Sphere and Buttons"] = "Закрепить сферу и кнопки";
L["Lock the main sphere and buttons so they can't be moved."] = "Закрепить на месте сферу и кнопки, чтобы нельзя было сдвинуть";
L["Constrict Buttons to Sphere"] = "Прижать кнопки к сфере";
L["Lock the buttons in place around the main sphere."] = "Закрепить кнопки на месте вокруг сферы";
L["Hide Tooltips"] = "Спрятать подсказки";
L["Hide the main sphere and button tooltips."] = "Спрятать подсказки основной сферы и кнопок.";
L["Silent Mode"] = "режим тишины";
L["Hide the information messages on AddOn/module load/disable."] = "Скрыть информационные сообщения аддона/модуле о загрузке/включении.";
L["Sphere Skin"] = "Шкурка сферы";
L["Choose the skin displayed by the Cryolysis sphere."] = "Выберите шкурку для сфры Cryolysisа.";
L["Outer Sphere Skin Behavior"] = "Поведение внешней сфера";
L["Choose how fast you want the outer sphere skin to deplete/replenish."] = "Выберите как быстро вы хотите чтобы внешняя сфера истощалась/наполнялась.";
L["Slow"] = "Медленно";
L["Fast"] = "Быстро";

-- Button Options
L["Button Settings"] = "Настройки кнопок";
L["Adjust various settings for each button."] = "Различные настройки для каждой кнопки.";
L["Up"] = "Вверх";
L["Right"] = "Вправо";
L["Down"] = "Вниз";
L["Left"] = "Влево";
L["Growth Direction"] = "Напровление меню";
L["Adjust which way this menu grows"] = "Настройка направления меню";
L["Show Item Count"] = "Показ число предметов";
L["Display the item count on this button"] = "Отображать число придметов на данной кнопке";

-- Middle Click functionality
L["Middle-Click Key"] = "Клик средней клавишей";
L["Adjusts the key used as an alternative to a middle click."] = "Выбор кнопки, заменяющей щелчок средний клавишей мыши.";
L["Alt"] = "Alt";
L["Shift"] = "Shift";
L["Ctrl"] = "Ctrl";

	-- Main Sphere sub-options
	L["Main Sphere"] = "Основная сфера";
	L["Adjust various settings for the main sphere."] = "Различные настройки для основной сферы.";
	L["Show or hide the main sphere."] = "Показывать\скрывать основную сферу.";
	L["Scale the size of the main sphere."] = "Устанавливает масштаб основной сферы.";
	
	-- Sphere Text
	L["Sphere Text"] = "Текст сферы";
	L["Adjust what information is displayed on the sphere."] = "Выбор информации, которую отображает сфера.";
	L["Nothing"] = "Ничего";
	L["Current Health"] = "Текущее здоровье";
	L["Health %"] = "Здоровье %";
	L["Current Mana/Energy/Rage"] = "Текущая мана/энергия/ярость";
	L["Mana/Energy/Rage %"] = "Мана/Энергия/Ярость %";
	
	-- Outer Sphere
	L["Outer Sphere"] = "Внешняя сфера";
	L["Adjust what information is displayed using the outer sphere."] = "Выбор информации, которую отображает внешняя сфера.";
	L["Health"] = "Здоровье";
	L["Mana"] = "Мана";

	-- Custom Button locales
	L["First Custom Button"] = "Первая польз. кнопка";
	L["Second Custom Button"] = "Вторая польз. кнопка";
	L["Third Custom Button"] = "Третья польз. кнопка";
	L["Hide"] = "Скрыть";
	L["Show or hide this button."] = "Отображать/скрывать данную кнопку";
	L["Adjust various settings for this button."] = "Настройка параметров данной кнопки кнопки.";
	L["Scale the size of this button."] = "Настройка размера данной кнопки.";
	L["Button Type"] = "Тип кнопки";
	L["Choose whether this button casts a spell, uses a macro, or uses an item."] = "Выберите что будет делать эта кнопка, применять заклинание, запускать макрос, или использовать предмет.";
	L["Spell"] = "Заклинание";
	L["Macro"] = "Макрос";
	L["Item"] = "Предмет";
	L["Left Click Action"] = "Действие по левому клику";
	L["Right Click Action"] = "Действие по правому клику";
	L["Middle Click Action"] = "Действие по среднему клику";
	L["Type in the name of the action that will be cast when left clicking this button."] = "Введите название действия, которые будут выполняться при левом клике по данной кнопке.";
	L["Type in the name of the action that will be cast when right clicking this button."] = "Введите название действия, которые будут выполняться при правом клике по данной кнопке.";
	L["Type in the name of the action that will be cast when middle clicking this button."] = "Введите название действия, которые будут выполняться при среднем клике по данной кнопке.";
	L["Enter a spell, macro, or item name and PRESS ENTER. Capitalization matters."] = "Введите название заклинания, макроса, или предмета и нажмите клавишу ВВОД.";
	L["Move Clockwise"] = "Движение по часовой";
	L["Move this button one position clockwise."] = "Движение кнопки по часовой.";
	L["Scale"] = "Масштаб";

	-- Mount Button locales
	L["Mount Button"] = "Кнопка ездовых животных";
	L["Button Behavior"] = "Поведение кнопки";
	L["Manual"] = "Вручную";
	L["Automatic"] = "Авто";
	L["Ground Mount"] = "Наземное ездовое животное";
	L["Flying Mount"] = "Летающее ездовое животное";
	L["Left Click Mount"] = "[Левый Клик] ездовое животное";
	L["Right Click Mount"] = "[Правый Клик] ездовое животное";
	L["Re-scan Mounts"] = "Пере-проверка ездовых животных";
	L["Click this when you've added new mounts to your bags."] = "Кликните тут если у вас в сумках есть новое ездовое животное.";

-- Module Options
L["Modules Options"] = "Опции модулей";
L["Cryolysis allows you to enable and disable parts of it.  This section gives you the ability to do so."] = "Cryolysis";
L["Module"] = "Модуль";
L["System"] = "Системный";
L["Loaded"] = "Загружен";
L["Unloaded"] = "Выгружен";
L["Turn this feature off if you don't use it in order to save memory and CPU power."] = "Отключите эту функцию, если вы не используете её, в целях экономии производительности.";
L["Adjust various options for this module."] = "Настройка данного модуля.";
L["Ready"] = "Готов";
L["minutes"] = "мин"; -- Mind the capitalisation!
L["seconds"] = "сек"; -- Mind the capitalisation!
L["Show Cooldown"] = "Показ перезарядки";
L["Display the cooldown timer on this button"] = "Отображать таймер перезарядки на данной кнопке";

	-- Mage Module Locales
	L["Buff Menu"] = "Меню эффектов";
	L["Teleport/Portal"] = "Телепорт/Портал";
	L["Click to open menu."] = "Кликните для открытия";
	L["Armor"] = "Броня";
	L["Intellect"] = "Интеллект";
	L["Magic"] = "Магия";
	L["Damage Shields"] = "Ранящие щиты";
	L["Magical Wards"] = "Магическая защита";
	L["Food Button"] = "Кнопка еды";
	L["Water Button"] = "Кнопка воды";
	L["Gem Button"] = "Кнопка камней";
	
	-- Priest Module Locales
	L["Fortitude"] = "Стойкость";
	L["Spirit"] = "Дух";
	L["Protection"] = "Защита";
	
	-- Message Module Options
	L["Message"] = "Сообщение";
	L["Chat Channel"] = "Канал чата";
	L["Choose which chat channel messages are displayed in."] = "Выберите в каком канале отображать сообщения.";
	L["User"] = "Игрок";
	L["Say"] = "Сказать";
	L["Party"] = "Группа";
	L["Raid"] = "Рейд";
	L["Group"] = "Отряд";
	L["World"] = "Мир";

	-- Warning Module Options
	L["Warning"] = "Предупреждение";

	-- Reagent Restocking Module Options
	L["Reagent Restocking"] = "Запасы реагентов";
	L["Restock all reagents?"] = "Запасы всеми реагентами?";
	L["Yes"] = "Да";
	L["No"] = "Нет";
	L["Confirm Restocking"] = "Подтвердить закупку";
	L["Pop-up a confirmation box."] = "Выводит окно запроса о подтверждении.";
	L["Restocking Overflow"] = "Переполнение запасов";
	L["If enabled, one extra stack of reagents will be bought in order to bring you above the restock amount. Only works for reagents that are bought from vendor in stacks."] = true;
	L["Adjust the amount of "] = "Какое количаство ";
	L[" to restock to."] = " запастись.";

-- Profile Options
L["Profile Options"] = "Настройки профиля";
L["Cryolysis' saved variables are organized so you can have shared options across all your characters, while having different sets of custom buttons for each.  These options sections allow you to change the saved variable configurations so you can set up per-character options, or even share custom button setups between characters"] = "Сохраняемые переменные Криолизиса 3 организованы так, что вы можете разделять настройки между всеми вашими персонажами, имея различный набор собственных кнопок для каждого персонажа. Эти секции настроек позволяют вам изменять конфигурацию сохранённых переменных устанавливая настройки для каждого персонажа, или разделяя единую настройку кнопок между ними";
L["Options profile"] = "Профиль настроек";
L["Saved profile for Cryolysis 3 options"] = "Написанные профили настроек Криолизиса 3";


------------------------------------------------------------------------------------------------------
-- Error messages
------------------------------------------------------------------------------------------------------
L["Invalid name, please check your spelling and try again!"] = "Неверное название, пожалуйста проверьте заклинание и попробуйте сного!";
