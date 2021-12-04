------------------------------------------------------------------------------------------------------
-- Local variables
------------------------------------------------------------------------------------------------------
local Cryolysis3 = Cryolysis3;
local L = LibStub("AceLocale-3.0"):GetLocale("Cryolysis3");


------------------------------------------------------------------------------------------------------
-- Slash Options
------------------------------------------------------------------------------------------------------
Cryolysis3.slashopts = {
	type = "group",
	args = {
		menu = {
			type = "execute",
			name = L["Show Menu"],
			desc = L["Open the configuration menu."],
			func = function() 
				Cryolysis3:OpenMenu();
			end
		}
	}
};


------------------------------------------------------------------------------------------------------
-- Menu options
------------------------------------------------------------------------------------------------------
Cryolysis3.options = {
	name = "Cryolysis 3",
	type = 'group',
	args = {
		gen = {
			type = "group",
			name = L["General Settings"],
			desc = L["Adjust various settings for Cryolysis 3."],
			order = 10,
			args = {
				lock = {
					type = "toggle",
					name = L["Lock Sphere and Buttons"],
					desc = L["Lock the main sphere and buttons so they can't be moved."],
					width = "full",
					get = function(info) return Cryolysis3.db.char.lockSphere; end,
					set = function(info, v) Cryolysis3.db.char.lockSphere = v; end,
					order = 10
				},
				constrict = {
					type = "toggle",
					name = L["Constrict Buttons to Sphere"],
					desc = L["Lock the buttons in place around the main sphere."],
					width = "full",
					get = function(info) return Cryolysis3.db.char.lockButtons end,
					set = function(info, v) 
						Cryolysis3.db.char.lockButtons = v;
						Cryolysis3:UpdateAllButtonPositions();
					end,
					order = 20
				},
				tooltips = {
					type = "toggle",
					name = L["Hide Tooltips"],
					desc = L["Hide the main sphere and button tooltips."],
					get = function(info) return Cryolysis3.db.char.HideTooltips; end,
					set = function(info, v) Cryolysis3.db.char.HideTooltips = v; end,
					order = 30
				},
				quiet = {
					type = "toggle",
					name = L["Silent Mode"],
					desc = L["Hide the information messages on AddOn/module load/disable."],
					get = function(info) return Cryolysis3.db.char.silentMode; end,
					set = function(info, v) Cryolysis3.db.char.silentMode = v; end,
					order = 35
				},
				skinSelect = {
					type = "select",
					name = L["Sphere Skin"],
					desc = L["Choose the skin displayed by the Cryolysis sphere."],
					width = "full",
					get = function(info) return Cryolysis3.db.char.skin; end,
					set = function(info, v) 
						Cryolysis3.db.char.skin = v;
						Cryolysis3:UpdateSphere("outerSphere");
					end,
					values = {
						["666"]		= "666",
						["Blue"]	= "Blue",
						["Orange"]	= "Orange",
						["Rose"]	= "Rose",
						["Turquoise"]	= "Turquoise",
						["Violet"]	= "Violet",
						["X"]		= "X"
					},
					order = 40
				},
				outsphere = {
					type = "select",
					name = L["Outer Sphere Skin Behavior"],
					desc = L["Choose how fast you want the outer sphere skin to deplete/replenish."],
					width = "full",
					get = function(info) return Cryolysis3.db.char.outerSphereSkin end,
					set = function(info, v) 
						Cryolysis3.db.char.outerSphereSkin = v;
						Cryolysis3:UpdateSphere("outerSphere");
					end,
					values = {
						L["Slow"],
						L["Fast"]
					},
					order = 50
				},
			}
		},
		graphicalsettings = {
			type = "group",
			name = L["Button Settings"],
			desc = L["Adjust various settings for each button."],
			order = 20,
			args = {
				middlekey = {
					type = "select",
					name = L["Middle-Click Key"],
					desc = L["Adjusts the key used as an alternative to a middle click."],
					width = "full",
					get = function(info) return Cryolysis3.db.char.middleKey end,
					set = function(info, v)
						Cryolysis3.db.char.middleKey = v;
						Cryolysis3:ChangeMiddleKey();
					end,
					order = 10,
					values = {
						["alt"]		= L["Alt"],
						["shift"]	= L["Shift"],
						["ctrl"]	= L["Ctrl"]
					}
				},
				msbutton = {
					type = "group",
					name = L["Main Sphere"],
					desc = L["Adjust various settings for the main sphere."],
					order = 20,
					args = {
						mshide = {
							type = "toggle",
							name = L["Hide"],
							desc = L["Show or hide the main sphere."],
							width = "full",
							get = function(info) return Cryolysis3.db.char.hidden["Sphere"] end,
							set = function(info, v)
								Cryolysis3.db.char.hidden["Sphere"] = v;
								Cryolysis3:UpdateVisibility();
							end,
							order = 10
						},
						insphere = {
							type = "select",
							name = L["Sphere Text"],
							desc = L["Adjust what information is displayed on the sphere."],
							width = "full",
							get = function(info) return Cryolysis3.db.char.sphereText end,
							set = function(info, v)
								Cryolysis3.db.char.sphereText = v;
								Cryolysis3:UpdateSphere("sphereText");
							end,
							values = {
								L["Nothing"],
								L["Current Health"],
								L["Health %"],
								L["Current Mana/Energy/Rage"],
								L["Mana/Energy/Rage %"]
							},
							order = 20
						},
						outsphere = {
							type = "select",
							name = L["Outer Sphere"],
							desc = L["Adjust what information is displayed using the outer sphere."],
							width = "full",
							get = function(info) return Cryolysis3.db.char.outerSphere end,
							set = function(info, v) 
								Cryolysis3.db.char.outerSphere = v;
								Cryolysis3:UpdateSphere("outerSphere");
							end,
							values = {
								L["Nothing"],
								L["Health"],
								L["Mana"],
							},
							order = 25
						},
						--[[
						spheremb = {
							type = "select",
							name = L["Inner Sphere"],
							desc = L["Adjust what clicking the inner sphere does."],
							width = "full",
							get = function(info) return Cryolysis3.db.char.sphereAttribute end,
							set = function(info, v) 
								Cryolysis3.db.char.sphereAttribute = v;
								Cryolysis3:UpdateSphereAttributes();
							end,
							values = {
								L["Nothing"],
								L["Eat and drink"]
							},
							order = 40
						},

						angleadj = {
							type = "range",
							name = L["Angle"],
							desc = L["Adjust the position of the buttons around the sphere."],
							width = "full",
							get = function(info) return Cryolysis3.db.char.angle end,
							set = function(info, v) 
								Cryolysis3.db.char.angle = v;
								Cryolysis3:UpdateAllButtonPositions();
							end,
							min = 0,
							max = 360,
							step = 18,
							order = 50
						},						]]
						scalems = {
							type = "range",
							name = L["Scale"],
							desc = L["Scale the size of the main sphere."],
							width = "full",
							get = function(info) return Cryolysis3.db.char.scale.frame["Sphere"] end,
							set = function(info, v) 
								Cryolysis3.db.char.scale.frame["Sphere"] = v;
								Cryolysis3:UpdateScale("frame", "Sphere", v)
								--Cryolysis3:UpdateAllButtonPositions();
								--Cryolysis3:UpdateAllButtonSizes();
							end,
							min = .5,
							max = 2,
							step = .1,
							isPercent = true,
							order = 90
						},
						buttontype = {
							type = "select",
							name = L["Button Type"],
							desc = L["Choose whether this button casts a spell, uses a macro, or uses an item."],
							width = "full",
							get = function(info) return Cryolysis3.db.char.buttonTypes["Sphere"] end,
							set = function(info, v) 
								Cryolysis3.db.char.buttonTypes["Sphere"] = v;
							end,
							values = {
								["spell"] = L["Spell"], 
								["macro"] = L["Macro"], 
								["item"] = L["Item"]
							},
							order = 30
						},
						leftclick = {
							type = "input",
							name = L["Left Click Action"],
							desc = L["Type in the name of the action that will be cast when left clicking this button."],
							usage = L["Enter a spell, macro, or item name and PRESS ENTER. Capitalization matters."],
							get = function(info) return Cryolysis3.db.char.buttonFunctions["Sphere"].left; end,
							set = function(info, v) 
								Cryolysis3.db.char.buttonFunctions["Sphere"].left = v;
								Cryolysis3:UpdateButton("Sphere", "left");
							end,
							order = 40
						},
--~ 						rightclick = {
--~ 							type = "input",
--~ 							name = L["Right Click Action"],
--~ 							desc = L["Type in the name of the action that will be cast when right clicking this button."],
--~ 							usage = L["Enter a spell, macro, or item name and PRESS ENTER. Capitalization matters."],
--~ 							get = function(info) return Cryolysis3.db.char.buttonFunctions["Sphere"].right; end,
--~ 							set = function(info, v) 
--~ 								Cryolysis3.db.char.buttonFunctions["Sphere"].right = v;
--~ 								Cryolysis3:UpdateButton("Sphere", "right");
--~ 							end,
--~ 							order = 50
--~ 						},
						middleclick = {
							type = "input",
							name = L["Middle Click Action"],
							desc = L["Type in the name of the action that will be cast when middle clicking this button."],
							usage = L["Enter a spell, macro, or item name and PRESS ENTER. Capitalization matters."],
							get = function(info) return Cryolysis3.db.char.buttonFunctions["Sphere"].middle; end,
							set = function(info, v) 
								Cryolysis3.db.char.buttonFunctions["Sphere"].middle = v;
								Cryolysis3:UpdateButton("Sphere", "middle");
							end,
							order = 60
						},
--~ 						scalebuttons = {
--~ 							type = "range",
--~ 							name = L["Scale All Buttons"],
--~ 							desc = L["Scale the size of all of the buttons at once."],
--~ 							width = "full",
--~ 							get = function(info) return Cryolysis3.db.char.buttonScale end,
--~ 							set = function(info, v) 
--~ 								Cryolysis3.db.char.buttonScale = v;
--~ 								Cryolysis3:UpdateAllButtonPositions();
--~ 								Cryolysis3:UpdateAllButtonSizes();
--~ 							end,
--~ 							min = .5,
--~ 							max = 2,
--~ 							step = .1,
--~ 							isPercent = true,
--~ 							order = 70
--~ 						}
					}
				},
				custom1 = {
					type = "group",
					name = L["First Custom Button"],
					desc = L["Adjust various settings for this button."],
					order = 30,
					args = {
						hidecustom1 = {
							type = "toggle",
							name = L["Hide"],
							desc = L["Show or hide this button."],
							width = "full",
							get = function(info) return Cryolysis3.db.char.hidden["CustomButton1"] end,
							set = function(info, v)
								Cryolysis3.db.char.hidden["CustomButton1"] = v;
								Cryolysis3:UpdateVisibility();
							end,
							order = 10
						},
						movecustom1 = {
							type = "execute",
							name = L["Move Clockwise"],
							desc = L["Move this button one position clockwise."],
							func = function() Cryolysis3:IncrementButton("CustomButton1"); end,
							order = 20
						},
						buttontypecustom1 = {
							type = "select",
							name = L["Button Type"],
							desc = L["Choose whether this button casts a spell, uses a macro, or uses an item."],
							width = "full",
							get = function(info) return Cryolysis3.db.char.buttonTypes["CustomButton1"] end,
							set = function(info, v) 
								Cryolysis3.db.char.buttonTypes["CustomButton1"] = v;
							end,
							values = {
								["spell"] = L["Spell"], 
								["macro"] = L["Macro"], 
								["item"] = L["Item"]
							},
							order = 30
						},
						leftclickcustom1 = {
							type = "input",
							name = L["Left Click Action"],
							desc = L["Type in the name of the action that will be cast when left clicking this button."],
							usage = L["Enter a spell, macro, or item name and PRESS ENTER. Capitalization matters."],
							get = function(info) return Cryolysis3.db.char.buttonFunctions["CustomButton1"].left; end,
							set = function(info, v) 
								Cryolysis3.db.char.buttonFunctions["CustomButton1"].left = v;
								Cryolysis3:UpdateButton("CustomButton1", "left");
							end,
							order = 40
						},
						rightclickcustom1 = {
							type = "input",
							name = L["Right Click Action"],
							desc = L["Type in the name of the action that will be cast when right clicking this button."],
							usage = L["Enter a spell, macro, or item name and PRESS ENTER. Capitalization matters."],
							get = function(info) return Cryolysis3.db.char.buttonFunctions["CustomButton1"].right; end,
							set = function(info, v) 
								Cryolysis3.db.char.buttonFunctions["CustomButton1"].right = v;
								Cryolysis3:UpdateButton("CustomButton1", "right");
							end,
							order = 50
						},
						middleclickcustom1 = {
							type = "input",
							name = L["Middle Click Action"],
							desc = L["Type in the name of the action that will be cast when middle clicking this button."],
							usage = L["Enter a spell, macro, or item name and PRESS ENTER. Capitalization matters."],
							get = function(info) return Cryolysis3.db.char.buttonFunctions["CustomButton1"].middle; end,
							set = function(info, v) 
								Cryolysis3.db.char.buttonFunctions["CustomButton1"].middle = v;
								Cryolysis3:UpdateButton("CustomButton1", "middle");
							end,
							order = 60
						},
						scalecustom1 = {
							type = "range",
							name = L["Scale"],
							desc = L["Scale the size of this button."],
							width = "full",
							get = function(info) return Cryolysis3.db.char.scale.button["CustomButton1"]; end,
							set = function(info, v) 
								Cryolysis3.db.char.scale.button["CustomButton1"] = v;
								Cryolysis3:UpdateScale("button", "CustomButton1", v)
								--Cryolysis3:UpdateAllButtonPositions()
								--Cryolysis3:UpdateAllButtonSizes()
							end,
							min = .5,
							max = 2,
							step = .1,
							isPercent = true,
							order = 70
						}
					}
				},
				custom2 = {
					type = "group",
					name = L["Second Custom Button"],
					desc = L["Adjust various settings for this button."],
					order = 30,
					args = {
						hidecustom2 = {
							type = "toggle",
							name = L["Hide"],
							desc = L["Show or hide this button."],
							width = "full",
							get = function(info) return Cryolysis3.db.char.hidden["CustomButton2"] end,
							set = function(info, v)
								Cryolysis3.db.char.hidden["CustomButton2"] = v;
								Cryolysis3:UpdateVisibility();
							end,
							order = 10
						},
						movecustom2 = {
							type = "execute",
							name = L["Move Clockwise"],
							desc = L["Move this button one position clockwise."],
							func = function() Cryolysis3:IncrementButton("CustomButton2"); end,
							order = 20
						},
						buttontypecustom2 = {
							type = "select",
							name = L["Button Type"],
							desc = L["Choose whether this button casts a spell, uses a macro, or uses an item."],
							width = "full",
							get = function(info) return Cryolysis3.db.char.buttonTypes["CustomButton2"] end,
							set = function(info, v) 
								Cryolysis3.db.char.buttonTypes["CustomButton2"] = v;
							end,
							values = {
								["spell"] = L["Spell"], 
								["macro"] = L["Macro"], 
								["item"] = L["Item"]
							},
							order = 30
						},
						leftclickcustom2 = {
							type = "input",
							name = L["Left Click Action"],
							desc = L["Type in the name of the action that will be cast when left clicking this button."],
							usage = L["Enter a spell, macro, or item name and PRESS ENTER. Capitalization matters."],
							get = function(info) return Cryolysis3.db.char.buttonFunctions["CustomButton2"].left; end,
							set = function(info, v) 
								Cryolysis3.db.char.buttonFunctions["CustomButton2"].left = v;
								Cryolysis3:UpdateButton("CustomButton2", "left");
							end,
							order = 40
						},
						rightclickcustom2 = {
							type = "input",
							name = L["Right Click Action"],
							desc = L["Type in the name of the action that will be cast when right clicking this button."],
							usage = L["Enter a spell, macro, or item name and PRESS ENTER. Capitalization matters."],
							get = function(info) return Cryolysis3.db.char.buttonFunctions["CustomButton2"].right; end,
							set = function(info, v) 
								Cryolysis3.db.char.buttonFunctions["CustomButton2"].right = v;
								Cryolysis3:UpdateButton("CustomButton2", "right");
							end,
							order = 50
						},
						middleclickcustom2 = {
							type = "input",
							name = L["Middle Click Action"],
							desc = L["Type in the name of the action that will be cast when middle clicking this button."],
							usage = L["Enter a spell, macro, or item name and PRESS ENTER. Capitalization matters."],
							get = function(info) return Cryolysis3.db.char.buttonFunctions["CustomButton2"].middle; end,
							set = function(info, v) 
								Cryolysis3.db.char.buttonFunctions["CustomButton2"].middle = v;
								Cryolysis3:UpdateButton("CustomButton2", "middle");
							end,
							order = 60
						},
						scalecustom2 = {
							type = "range",
							name = L["Scale"],
							desc = L["Scale the size of this button."],
							width = "full",
							get = function(info) return Cryolysis3.db.char.scale.button["CustomButton2"]; end,
							set = function(info, v) 
								Cryolysis3.db.char.scale.button["CustomButton2"] = v;
								Cryolysis3:UpdateScale("button", "CustomButton2", v)
								--Cryolysis3:UpdateAllButtonPositions()
								--Cryolysis3:UpdateAllButtonSizes()
							end,
							min = .5,
							max = 2,
							step = .1,
							isPercent = true,
							order = 70
						}
					}
				},
				custom3 = {
					type = "group",
					name = L["Third Custom Button"],
					desc = L["Adjust various settings for this button."],
					order = 30,
					args = {
						hidecustom3 = {
							type = "toggle",
							name = L["Hide"],
							desc = L["Show or hide this button."],
							width = "full",
							get = function(info) return Cryolysis3.db.char.hidden["CustomButton3"] end,
							set = function(info, v)
								Cryolysis3.db.char.hidden["CustomButton3"] = v;
								Cryolysis3:UpdateVisibility();
							end,
							order = 10
						},
						movecustom3 = {
							type = "execute",
							name = L["Move Clockwise"],
							desc = L["Move this button one position clockwise."],
							func = function() Cryolysis3:IncrementButton("CustomButton3"); end,
							order = 20
						},
						buttontypecustom3 = {
							type = "select",
							name = L["Button Type"],
							desc = L["Choose whether this button casts a spell, uses a macro, or uses an item."],
							width = "full",
							get = function(info) return Cryolysis3.db.char.buttonTypes["CustomButton3"] end,
							set = function(info, v) 
								Cryolysis3.db.char.buttonTypes["CustomButton3"] = v;
							end,
							values = {
								["spell"] = L["Spell"], 
								["macro"] = L["Macro"], 
								["item"] = L["Item"]
							},
							order = 30
						},
						leftclickcustom3 = {
							type = "input",
							name = L["Left Click Action"],
							desc = L["Type in the name of the action that will be cast when left clicking this button."],
							usage = L["Enter a spell, macro, or item name and PRESS ENTER. Capitalization matters."],
							get = function(info) return Cryolysis3.db.char.buttonFunctions["CustomButton3"].left; end,
							set = function(info, v) 
								Cryolysis3.db.char.buttonFunctions["CustomButton3"].left = v;
								Cryolysis3:UpdateButton("CustomButton3", "left");
							end,
							order = 40
						},
						rightclickcustom3 = {
							type = "input",
							name = L["Right Click Action"],
							desc = L["Type in the name of the action that will be cast when right clicking this button."],
							usage = L["Enter a spell, macro, or item name and PRESS ENTER. Capitalization matters."],
							get = function(info) return Cryolysis3.db.char.buttonFunctions["CustomButton3"].right; end,
							set = function(info, v) 
								Cryolysis3.db.char.buttonFunctions["CustomButton3"].right = v;
								Cryolysis3:UpdateButton("CustomButton3", "right");
							end,
							order = 50
						},
						middleclickcustom3 = {
							type = "input",
							name = L["Middle Click Action"],
							desc = L["Type in the name of the action that will be cast when middle clicking this button."],
							usage = L["Enter a spell, macro, or item name and PRESS ENTER. Capitalization matters."],
							get = function(info) return Cryolysis3.db.char.buttonFunctions["CustomButton3"].middle; end,
							set = function(info, v) 
								Cryolysis3.db.char.buttonFunctions["CustomButton3"].middle = v;
								Cryolysis3:UpdateButton("CustomButton3", "middle");
							end,
							order = 60
						},
						scalecustom3 = {
							type = "range",
							name = L["Scale"],
							desc = L["Scale the size of this button."],
							width = "full",
							get = function(info) return Cryolysis3.db.char.scale.button["CustomButton3"]; end,
							set = function(info, v) 
								Cryolysis3.db.char.scale.button["CustomButton3"] = v;
								Cryolysis3:UpdateScale("button", "CustomButton3", v)
								--Cryolysis3:UpdateAllButtonPositions()
								--Cryolysis3:UpdateAllButtonSizes()
							end,
							min = .5,
							max = 2,
							step = .1,
							isPercent = true,
							order = 70
						}
					}
				},
				mount = {
					type = "group",
					name = L["Mount Button"],
					desc = L["Adjust various settings for this button."],
					order = 40,
					args = {
						hidemount = {
							type = "toggle",
							name = L["Hide"],
							desc = L["Show or hide this button."],
							width = "full",
							get = function(info) return Cryolysis3.db.char.hidden["MountButton"] end,
							set = function(info, v)
								Cryolysis3.db.char.hidden["MountButton"] = v;
								Cryolysis3:UpdateVisibility();
							end,
							order = 5
						},
						mode = {
							type = "select",
							name = L["Button Behavior"],
							width = "full",
							get = function(info) return Cryolysis3.db.char.mountBehavior; end,
							set = function(info, v)
								Cryolysis3.db.char.mountBehavior = v;
								if v == 1 then
									Cryolysis3.options.args.graphicalsettings.args.mount.args.left.name = L["Left Click Mount"];
									Cryolysis3.db.char.leftMountText = L["Left Click Mount"];
									Cryolysis3.options.args.graphicalsettings.args.mount.args.right.name = L["Right Click Mount"];
									Cryolysis3.db.char.rightMountText = L["Right Click Mount"];
								else
									Cryolysis3.options.args.graphicalsettings.args.mount.args.left.name = L["Ground Mount"];
									Cryolysis3.db.char.leftMountText = L["Ground Mount"];
									Cryolysis3.options.args.graphicalsettings.args.mount.args.right.name = L["Flying Mount"];
									Cryolysis3.db.char.rightMountText = L["Flying Mount"];
								end
								Cryolysis3:UpdateMountButtonMacro();
							end,
							values = {L["Manual"], L["Automatic"]},
							order = 7
						},
						left = {
							type = "select",
							name = function() return Cryolysis3.db.char.leftMountText end,
							width = "full",							
							get = function(info) return Cryolysis3.db.char.chosenMount.normal; end,
							set = function(info, v)
								Cryolysis3.db.char.chosenMount.normal = v;
								Cryolysis3:UpdateMountButtonMacro();
							end,
							values = function() return Cryolysis3.Private.mounts; end,
							order = 10
						},
						right = {
							type = "select",
							name = function() return Cryolysis3.db.char.rightMountText end,
							width = "full",
							get = function(info) return Cryolysis3.db.char.chosenMount.flying; end,
							set = function(info, v)
								Cryolysis3.db.char.chosenMount.flying = v;
								Cryolysis3:UpdateMountButtonMacro();
							end,
							values = function() return Cryolysis3.Private.mounts; end,
							order = 15
						},
						movemountbutton = {
							type = "execute",
							name = L["Move Clockwise"],
							desc = L["Move this button one position clockwise."],
							func = function() Cryolysis3:IncrementButton("MountButton"); end,
							order = 20
						},
						rescanmount = {
							type = "execute",
							name = L["Re-scan Mounts"],
							desc = L["Click this when you've added new mounts to your bags."],
							func = function() Cryolysis3:FindMounts(true); end,
							order = 25
						},
						scalebuffbutton = {
							type = "range",
							name = L["Scale"],
							desc = L["Scale the size of this button."],
							width = "full",
							get = function(info) return Cryolysis3.db.char.scale.button["MountButton"]; end,
							set = function(info, v) 
								Cryolysis3.db.char.scale.button["MountButton"] = v;
								Cryolysis3:UpdateScale("button", "MountButton", v)
								--Cryolysis3:UpdateAllButtonPositions()
								--Cryolysis3:UpdateAllButtonSizes()
							end,
							min = .5,
							max = 2,
							step = .1,
							isPercent = true,
							order = 70
						}
					}
				},
			},
		},
		modules = {
			type = "group",
			name = L["Modules Options"],
			desc = L["Cryolysis allows you to enable and disable parts of it.  This section gives you the ability to do so."],
			order = 20,
			args = {
			
			}
		},
		profile = {
			type = "group",
			order = 25,
			name = L["Profile Options"],
			args = {
				desc = {
					order = 1,
					type = "description",
					name = L["Cryolysis' saved variables are organized so you can have shared options across all your characters, while having different sets of custom buttons for each.  These options sections allow you to change the saved variable configurations so you can set up per-character options, or even share custom button setups between characters"],
				}
			}
		}
	}
}
