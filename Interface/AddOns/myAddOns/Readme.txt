myAddOns v1.2


Description
===========

myAddOns is a World of Warcraft AddOn. It adds an AddOns button and menu 
to the Main Menu. This menu lists per category all supporting AddOns loaded
or not. You can check which AddOns you are using and their versions. If the
AddOns have options windows, you can open them from this menu.


Install
=======

Extract the files into your World of Warcraft Directory.


Features
========

* Supporting AddOns list (name, version and category)
* Link to the AddOns' options windows
* Localization (english, french, german)

* Compatibility with World of Warcraft Client v1.3.0 (Interface 1300)
* Very low memory usage (~0.07MB)


Usage
=====

- Players -

To access the AddOns menu, click on the AddOns button in the Main Menu. Any
supporting AddOn that you loaded along with myAddOns is listed.

"Remove" button: Remove an AddOn from the list but this will not uninstall it.
If you load it again, it will comme back in the list.

"Options" button: Open an AddOn's options window if the selected AddOn has one.

- Developpers -

Here is a small tutorial to add myAddOns support to your AddOns. I'll take
the HelloWorld AddOn as example.

Steps 1 to 2 are required to list your AddOn in the menu.
Steps 3 to 5 are optional, they add a link to your options window.

Step 1 - Required
First you have to add an optional dependency to myAddOns. To do so, add the
following line to your .toc file:

	## OptionalDeps: myAddOns

Step 2 - Required
Then catch the "VARIABLES_LOADED" event and register your AddOn in the
global variable myAddOnsList. To do so, add the following lines to your
OnEvent event function, for the "VARIABLES_LOADED" event:

	-- Add HelloWorld to myAddOns addons list
	if(myAddOnsFrame) then
		myAddOnsList.HelloWorld = {name = "HelloWorld", description = "The almighty Hello World example", version = "1.0", category = MYADDONS_CATEGORY_OTHERS, frame = "HelloWorldFrame"};
	end

myAddOnsList is the AddOns list in myAddOns. The following fields are used:

	- name is the name of your AddOns in the menu (Free text - Required)
	- description is the description of your AddOn in the menu (Free text - Optional)
	- version is the version of your AddOn in the menu (Free text - Optional)
	- category is the category of your AddOn in the menu (Text - Optional)
	- frame is the frame of your AddOn (Frame - Required)
	- optionsframe is the options frame of your AddOn (Frame - Optional)

You should use one of these global variables to populate the category field.
They are localized:

	- MYADDONS_CATEGORY_BARS
	- MYADDONS_CATEGORY_CHAT
	- MYADDONS_CATEGORY_CLASS
	- MYADDONS_CATEGORY_COMBAT
	- MYADDONS_CATEGORY_COMPILATIONS
	- MYADDONS_CATEGORY_GUILD
	- MYADDONS_CATEGORY_INVENTORY
	- MYADDONS_CATEGORY_MAP
	- MYADDONS_CATEGORY_OTHERS
	- MYADDONS_CATEGORY_PROFESSIONS
	- MYADDONS_CATEGORY_QUESTS
	- MYADDONS_CATEGORY_RAID

If you don't use one of these, your AddOn will be listed in the "Others" category.

The frame field is used to detect if your AddOn is loaded. The optionsframe field
is used to detect if your AddOn has an options frame and make a link to it (see
step 3 to 5).

This is it. Now your AddOn will be listed.

Step 3 - Optional
To add a link to your options frame, populate the optionsframe field:

	myAddOnsList.HelloWorld = {name = "HelloWorld", description = "The almighty Hello World example", version = "1.0", category = MYADDONS_CATEGORY_OTHERS, frame = "HelloWorldFrame", optionsframe = "HelloWorldOptionsFrame"};

Step 4 - Optional
To display correctly your options frame, you should add a line in the UIPanelWindows.
To do so, add the following line to your OnLoad function:

	-- Add HelloWorldOptionsFrame to the UIPanelWindows list
	UIPanelWindows["HelloWorldOptionsFrame"] = {area = "center", pushable = 0};

Step 5 - Optional
Use ShowUIPanel and HideUIPanel to show or hide your options frame. When hiding your
options frame, check the MYADDONS_ACTIVE_OPTIONSFRAME global variable. If
MYADDONS_ACTIVE_OPTIONSFRAME is your options frame, you know that your options frame
was opened via myAddOns menu. To return to myAddOns menu, add these lines to your
OnHide event function:

	-- Check if the options frame was opened by myAddOns
	if (MYADDONS_ACTIVE_OPTIONSFRAME == this) then
		ShowUIPanel(myAddOnsFrame);
	end


Now you are all set! You can download my HelloWorld example to test all this. Have a
look at myClock or myReloadUI too, they both support myAddOns.


FAQ
===

Q: My AddOns are not listed at all! Why??

A: The AddOns list is not automatically created. Each AddOn has to register itself in
the list. So the AddOns' authors have to add some lines to their code (see Usage for
Developpers). Check if your AddOns support myAddOns.

Q: Why isn't the list automatically created?

A: This is because the needed functions are not available ingame. They are avaiable
during Login/Character Select but not while playing. These functions are: AddOns folder
scan, .toc file reader, AddOn enable/disable, etc... Blizzard doesn't allow this
functions ingame for security reasons (no dynamic input/output).

Q: If I remove an AddOn from the list, is it disabled? Can I enable/disable AddOns
ingame?

A: If you remove an AddOn, it's not listed but it's still active until you logout and
disable it. It will come back in the list if you don't disable it next time you login.
You can't enable/disable AddOns ingame (see previous answer).


Known Issues
============

* None


Versions
========

1.2 - March 25, 2005

* Fixed highlight display
* Added "Guild" category

1.1 - March 8, 2005

* Fixed Main Menu width
* Fixed display of options windows in area other than "center"
* Added categories
* Removed slash commands

1.0 - February 4, 2005

* First version released


Contact
=======

Author : Scheid (scheid@free.fr)
Website : http://scheid.free.fr

