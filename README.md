# BeastCraft Component FrameWork

BeastCraft is a framework inspired by Reactjs and the HTML DOM. With it you can create stateful applications
with elements that you are familiar with. Buttons,Divs,Inputs and more. 
If you are familiar with Reactjs then BeastCraft should come naturally. 


# Installation

Beastcraft is flexible. You can put it on a computer or on a disk it doesn't care. just make sure it stays caged up in the beastcraft folder and put it in your execution directory. (so that means in the same directory that your startup.lua is or the lua script you run to start your project.
Simply download and extract the zip or clone it into your computer/disk directory

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
local App = require "src.App"
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
local Button = require "src.components.Button"
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

![My Button Clicking!!](![2022-01-21-00-48-32](https://i.ibb.co/phHkvqy/2022-01-21-00-48-32.gif))

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
local div = require "beastcraft".ui.div
local state = require "beastcraft".state
local monitor = require "beastcraft".utils.monitor
local Button = require "src.components.Button"
local MenuContext = require "src.context.MenuContext"

local App = function()
	local WIDTH,HEIGHT = monitor.getSize()
	local showMenu,setShowMenu = state.setState(false)
	
	local toggleMenu = function()
		setShowMenu(function(currentState)
			return not currentState
		end)
	end

	return div({
		style = {
			top=1,
			left=1,
			width = WIDTH,
			height = HEIGHT,
			backgroundColor = colors.blue
		},
		children = {
			MenuContext.Provider({
				value = {showMenu,toggleMenu},
				children = {Button()}
			})
		}
	})
end

return App
```
### Breakin it down

A Context returns a provider. The Provider must wrap any children that will consume context. So that;s exactly what we are doing. The Provider must also have a value passed, in this case we are passing a table that contains both the current showMenu state and the toggleMenu function. This is what we will expose in our button and menu components. Lets first use it in the Button component to change the text. That will be a quick way to see some results

```lua
	
```