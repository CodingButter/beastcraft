# BeastCraft Stateful Component FrameWork

BeastCraft is a framework inspired by Reactjs and the HTML DOM. With it you can create stateful applications
with elements that you are familiar with. Buttons,Divs,Inputs and more. 
If you are familiar with Reactjs then BeastCraft should come naturally. 


# Installation

Beastcraft is flexible. You can put it on a computer or on a disk it doesn't care. just make sure it stays caged up in the beastcraft folder and put it in your execution directory. (so that means in the same directory that your startup.lua is or the lua script you run to start your project.
Simply download and extract the zip or clone it into your computer/disk directory

to install current version just run the pastebin run command. this will get all the core files and this example project

```cli
pastebin run kgTH67Ly
```
the dev version can be ran here (note this can explode your computer)
```lua
pastebin run y4ZWKKy1
```

## Now What

Well now that its there we need to require it. All the methods you'll need are exposed when you require "beastcraft" just like this
```lua
local beastcraft = require "beastcraft"
```

## Lets make a component

To get beastcraft to render you're component we need to create a DOM element to nest it in **Just like React** luckily the DOM package has you covered with a body element. This element resizes to match the monitor size. Lets see what our main lua file would look like
```lua
--[[startup.lua]]--
local document = require "beastcraft".document
local renderDom = require "beastcraft".ui.renderDom
local App = require "src.app"
renderDom(App,document.body)
```

## Whats the App look like.

Our App.lua lives in the src folder. this is similar to how create-react-app structures there applications.
lets take a look at what our **FIRST COMPONENT** looks like as well

```lua
--[[ src/App.lua ]]--
local div = require "beastcraft".ui.div
local monitor = require "beastcraft".utils.monitor

local App = function()
	local WIDTH,HEIGHT = monitor.getSize()
	return div({
		style = {
			top=1,
			left=1,
			width = WIDTH,
			height = HEIGHT,
			backgroundColor = colors.blue
		}
	})
end
return App
```

![Our first Component](https://i.ibb.co/RS092Jv/image-2022-01-20-231414.png)

## OOH a blue screen

Well we have our first component but that's not very special. What about making a button!! lets create a components folder and add our first reusable component lets even use the state manager to manage some state. we can use this state to **open and close** a menu!!
```lua
--[[ src/components/Button.lua ]]--
local  button = require"beastcraft".ui.button
local  state = require"beastcraft".state

local  Button = function(props) -- Yeah we got props boys

	local  pressed, setPressed = state.useState(false)

	return  button({
		style = {
			left = 5,
			top = 5,
			width = 15,
			height = 3,
			backgroundColor = pressed  and  colors.lightGray  or  colors.gray,
			color = colors.white,
			highlightColor = pressed  and  colors.gray  or  colors.lightGray,
			borderColor = colors.yellow
		},
		onClick = function(self, event)
			setPressed(true)
		end,
		onRelease = function(self, event)
			setPressed(false)
		end
	}, "Menu Closed")

end

return  Button
```
### What did we just do?
Let me break down what's going on. I haven't implemented a toggle or temporary button but that doesn't mean we cant.  so that's what I've done

### First
we create our state and update state variables. these will allow us to keep our variables and update them through renders (which happen inside Beastcraft)
```lua
--[[ state.useState returns the current state and a method to update it ]]
local pressed,setPressed = state.useState(false)
```
### Using State for Color!

we will use our state to decide which color the background and highlight will be using a turnery it basically just says if its state is pressed lets use a different highlight and background color
```lua
...				-- if pressed light gray if not pressed gray
backgroundColor = pressed and colors.lightGray or colors.gray,
highlightColor = pressed and colors.gray or colors.lightGray,
...				-- if pressed gray if not pressed light gray

```
### onClick
Beastcrafts DOM module will automatically figure out if the click happened within the bounds of our button or any element for that matter. All we need to do is tell it what to do when the element is clicked. Notice the reference to self. all Element methods must have this self argument since they are all ran passing a reference to the targeted instance Just like event.target in javascript
now its easy to harness the setPressed function to update pressed to true
```lua
...onClick = function(self,event)
	setPressed(true) -- Easy as Pie
	end,...
```
### onRelease
Well our button needs to not be pressed when we release the mouse so that's exactly what we do.
```lua
...onRelease = function(self, event)
	setPressed(false) -- lets update state once more
end
```
### Lets Add it to App.lua
```lua
--[[ src/App.lua ]]--
local div = require "beastcraft".ui.div
local monitor = require "beastcraft".utils.monitor
local Button = require "src.components.button"
local App = function()
	local WIDTH,HEIGHT = monitor.getSize()
	return div({
		style = {
			top=1,
			left=1,
			width = WIDTH,
			height = HEIGHT,
			backgroundColor = colors.blue
		},
		children = {Button()} -- Children exist within an table array
	})
end
return App
```
## Results so far.
well what do we have now?

![My Button Clicking!!](https://i.ibb.co/phHkvqy/2022-01-21-00-48-32.gif)

## Lets get Advanced!  

### LETS CREATE AND USE CONTEXT!!
Creating and using Context is pretty straight forward. It works the same as in react.

#### first we create our context. 
lets create context in a MenuContext file and import it into both the App.lua and Button.lua we can place this into a folder within src called context

```lua
--[[ src/context/MenuContext.lua ]]--
local createContext = require "beastcraft".state.createContext
return createContext(nil) -- create the context and set its default value to nil
```

```lua
--[[ src/App.lua ]]
local  div = require"beastcraft".ui.div
local  state = require"beastcraft".state
local  monitor = require"beastcraft".utils.monitor
local  Button = require  "src.components.button"
local  MenuContext = require  "src.context.menucontext"

local  App = function()
	local  WIDTH, HEIGHT = monitor.getSize()
	local  showMenu, setShowMenu = state.useState(false)

	local  toggleMenu = function()
		setShowMenu(showMenu == false)
	end
	  
	return  div({
		style = {
			top = 1,
			left = 1,
			width = WIDTH,
			height = HEIGHT,
			backgroundColor = colors.blue
		},
		children = MenuContext:Provider({
			value = {showMenu, toggleMenu},
			children = function()
				return {Button()}
			end
		})
	})
end
return  App
```
### Breakin it down

A Context returns a provider. The Provider must wrap any children that will consume context in order to get the updated contextValue they must be returned from a function that the provider calls after updateing its value (kinda quirky but necessary) . So that's exactly what we are doing. The Provider must also have a value passed, in this case we are passing a table that contains both the current showMenu state and the toggleMenu function. This is what we will expose in our button and menu components. Lets first use it in the Button component to change the text. That will be a quick way to see some results

```lua
local  button = require"beastcraft".ui.button
local  state = require"beastcraft".state
local  MenuContext = require  "src.context.menucontext"

local  Button = function(props) -- Yeah we got props boys
	local  pressed, setPressed = state.useState(false)
	local  menuState, toggleMenu = table.unpack(state.useContext(MenuContext))
	return  button({
		style = {
			left = 5,
			top = 5,
			width = 16,
			height = 3,
			backgroundColor = pressed  and  colors.lightGray  or  colors.gray,
			color = colors.white,
			highlightColor = pressed  and  colors.gray  or  colors.lightGray,
			borderColor = colors.yellow
		},
		onClick = function(self, event)
			setPressed(true)
			toggleMenu()
		end,
		onRelease = function(self, event)
			setPressed(false)
		end
		}, 
		"Menu " .. (menuState == true  and  "Opened" or  "Closed"))
end

return  Button
```
### Consuming Context
As you can see if we pass our context into the state.useContext method we can get those values we passed. And since we put them into an indexed array it is easy to just unpack them and assign them right away.
How easy is this. now we can just call toggleMenu and also use a turnery to append either Opened or Closed to our menu button text. 
![Open and Close Menu Button Check!!](https://i.ibb.co/jr37GjW/2022-01-21-01-38-11.gif)

## BUT WHAT ABOUT OUR TOGGLE MENU!!

OK OK. lets add this toggle menu. Your first thought may be to check if showMenu is true and then add the menu to the children of app. BUT that would cause problems down the road with our state manager. State relies heavily on the order that state is declared. If we sometimes include a component that has state and sometimes we do not then it will cause indexing problems. The solution is to just use our style.display property and set it to none or block depending on showMenu. Lets see that in work by creating a Menu component and adding it to App.lua as a child. How bout instead of using context since the menu is only going to consume showMenu and not hide itself we just pass showMenu down through props. Context is made to avoid "Prop Drilling" but in this case its only down one child level so no real harm.

```lua
--[[ src/components/Menu.lua ]]--
local div = require "beastcraft".ui.div

local Menu = function(props)
	return div({
		style = {
			width = 18,
			height = 10,
			left = 22,
			top = 2,
			display = props.showMenu and "block" or "none",
			backgroundColor = colors.gray,
			color = colors.white,
			highlightColor = colors.lightGray,
			borderColor = colors.yellow
		}
	},"Toggled Menu")
end
return Menu
```
```lua
	--[[ src/App.lua ]]--
local  div = require"beastcraft".ui.div
local  state = require"beastcraft".state
local  monitor = require"beastcraft".utils.monitor
local  Button = require  "src.components.button"
local  Menu = require  "src.components.menu"
local  MenuContext = require  "src.context.menucontext"

local  App = function()
	local  WIDTH, HEIGHT = monitor.getSize()
	local  showMenu, setShowMenu = state.useState(false)

	local  toggleMenu = function()
		setShowMenu(showMenu == false)
	end
	  
	return  div({
		style = {
			top = 1,
			left = 1,
			width = WIDTH,
			height = HEIGHT,
			backgroundColor = colors.blue
		},
		children = MenuContext:Provider({
			value = {showMenu, toggleMenu},
			children = function()
				return {
					Button(),
					Menu({showMenu=showMenu})
				}
			end
		})
	})
end
return  App
```

### Passing Variables Through Props
That is pretty simple. Notice how we can just pass a table of properties and the component will be able to consume them. Straight forward 

## Lets See It in Action
![Toggling a menu like a pro!](https://i.ibb.co/NVkSmgC/2022-01-21-04-34-20.gif)

# Tip of the Iceburg 
With this we can create Elements to display peripheral data live as well as build our own UI's I'll admit that there are limitations to the current version like only creating divs and buttons. but I'll be adding features. I'll post some todos at the bottom.

## Other State Functions

 - useRef 
	 - Use reference allows us to use and update and update it live this works like useRef in react
- useReducer
	- This one is great this allows you to create a reducer function that can give you more control to how state is updated.  

### Useful Utility Functions
```lua
local debugger = require "beastcraft".utils.debugger -- works if debugger is attached
local switch = require "beastcraft".utils.switch -- switch statement(good for use in reducers)
local map = require "beastcraft".utils.table.map -- does what the name suggests
local filter = require "beastcraft".utils.table.filter -- again straight forward

```
### TODO

 - [ ] Input Elements
 - [ ] Unordered List Element
 - [ ] Border Radius
 - [ ] zIndex based render order
 - [ ] Ignore click events for elements under other elements
