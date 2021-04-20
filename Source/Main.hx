package;

import com.chaos.ui.theming.Theme;
import com.chaos.utils.Utils;
import com.chaos.ui.layout.BaseContainer;
import com.chaos.ui.BaseUI;
import com.chaos.ui.Label;
import com.chaos.ui.Accordion;
import com.chaos.ui.Accordion;
import com.chaos.data.DataProvider;
import com.chaos.ui.ScrollTextContent;
import com.chaos.drawing.icon.ArrowRightIcon;
import com.chaos.drawing.icon.StopIcon;
import com.chaos.form.ui.InputField;
import com.chaos.form.ui.RadioButtonList;
import com.chaos.ui.Alert;
import com.chaos.ui.Button;
import com.chaos.ui.CheckBoxGroup;
import com.chaos.ui.ComboBox;
import com.chaos.ui.TextInput;
import com.chaos.utils.CompositeManager;
import com.chaos.ui.data.ComboBoxObjectData;
import com.chaos.ui.data.ItemPaneObjectData;
import com.chaos.ui.data.ListObjectData;
import com.chaos.ui.data.MenuItemObjectData;
import com.chaos.ui.event.WindowEvent;
import com.chaos.ui.ItemPane;
import com.chaos.ui.Label;
import com.chaos.ui.ListBox;
import com.chaos.ui.Menu;
import com.chaos.ui.ProgressBar;
import com.chaos.ui.ProgressSlider;
import com.chaos.ui.RadioButtonGroup;
import com.chaos.ui.ScrollBar;
import com.chaos.ui.ScrollContentBase;
import com.chaos.ui.ScrollPane;
import com.chaos.ui.Slider;
import com.chaos.ui.TabPane;
import com.chaos.ui.ToggleButton;
import com.chaos.ui.ToolTip;
import com.chaos.ui.UIStyleManager;
import com.chaos.ui.Window;
import com.chaos.mobile.ui.Card;
import com.chaos.utils.ThreadManager;
import com.chaos.ui.ScrollPolicy;

import openfl.display.DisplayObject;
import openfl.display.MovieClip;
import openfl.display.Shape;
import openfl.display.Sprite;
import openfl.events.Event;
import openfl.events.MouseEvent;
import openfl.geom.Rectangle;
import openfl.text.TextField;

class Main extends Sprite
{
	private var accordion:Accordion;
	private var _uiDemoSection:BaseContainer;

	private var _lastSection:BaseContainer;

	private var _themeDefault:Theme;
	private var _redTheme:Theme;
	private var _greenTheme:Theme;
	private var _blueTheme:Theme;
	

	public function new()
	{
		super();

		var uiComponentButton:Button = new Button({"name":"ui","text":"UI Components","width":300,"height":20});
		var accordionLabel2:Label = new Label({"text":"Section 2","width":100,"height":20});
		var accordionLabel3:Label = new Label({"text":"Section 3","width":100,"height":20});

        var sectionArray:Array<Dynamic> = [{"name":"Section1","text":"UI","content":uiComponentButton},{"name":"Section2","text":"Section 2","content":accordionLabel2},{"name":"Section3","text":"Section 3","content":accordionLabel3}];
        
        accordion  = new Accordion({"width":300,"height":stage.stageHeight,"data":sectionArray,"x":0, "y":0});

		uiComponentButton.addEventListener(MouseEvent.CLICK, onUIComponentClick, false, 0, true);
		_uiDemoSection = creeateUIDemo();
		
		addChild(accordion);
		addChild(_uiDemoSection);

		// Theme system
		_themeDefault = new Theme();
		_redTheme = new Theme({"primaryColor":0xFF0000,"secondaryColor":0xAA0202});
		_greenTheme = new Theme({"primaryColor":0x18af03,"secondaryColor":0x66ff00});
		_blueTheme = new Theme({"primaryColor":0x19a4de,"secondaryColor":0x0066ff});
	}

	private function onUIComponentClick(event:MouseEvent):Void {

		var button:Button = cast(event.currentTarget,Button);

		if(_lastSection != null)
			_lastSection.visible = false;

		switch(button.name) {

			case "ui":
				_uiDemoSection.visible = true;
				_lastSection = _uiDemoSection;
		}
		
	}

	private function creeateUIDemo():BaseContainer {

		var OFFSET : Int = 20;
    
		var GANGSTA_TEXT : String = "Lorem fizzle dolizzle own yo' amizzle, consectetuer adipiscing gangster. Nullizzle sapizzle fo shizzle, uhuh ... yih! shut the shizzle up, suscipizzle quis, you son of a bizzle vel, arcu. Pellentesque for sure its fo rizzle. Sizzle erizzle. Dang izzle dolizzle dapibus the bizzle tempus shizznit. Maurizzle pellentesque nibh et turpis. Pimpin' in i saw beyonces tizzles and my pizzle went crizzle. Pellentesque eleifend rhoncizzle nisi. In yippiyo break yo neck, yall platea dictumst. The bizzle dapibizzle. Curabitur daahng dawg shut the shizzle up, pretizzle own yo', mattizzle ac, eleifend check it out, nunc. Rizzle suscipizzle. Integer gangsta black purus.\n\nCurabitizzle doggy i'm in the shizzle for sure nisi that's the shizzle mollizzle. Suspendisse potenti. Morbi da bomb. Vivamizzle neque. Crizzle orci. Cras pimpin' brizzle, interdizzle uhuh ... yih!, phat sit amet, stuff izzle, shizzlin dizzle. Pellentesque things. That's the shizzle daahng dawg mi, volutpizzle in, sagittis sizzle, funky fresh semper, i saw beyonces tizzles and my pizzle went crizzle. Bizzle its fo rizzle ipsum. Break it down volutpizzle felis vel uhuh ... yih!. Crizzle ma nizzle justo hizzle purus sodales ornare. Shiz venenatizzle check it out et funky fresh. Nunc sizzle. Suspendisse dizzle placerizzle mah nizzle. Curabitur yippiyo dang. Nunc shizzlin dizzle, leo eu dapibus hendrerizzle, ipsum get down get down fo shizzle sem, in aliquet magna pimpin' luctizzle pede. Fo shizzle a nisl. Class aptent cool dizzle pot ass boom shackalack conubia nostra, pizzle inceptos hymenaeos. Aliquam interdizzle, neque nizzle break yo neck, yall fo, phat orci its fo rizzle leo, shit semper things i saw beyonces tizzles and my pizzle went crizzle dizzle sizzle.";
		
		var button : Button;
		var iconButton : Button;
		var iconTextButton : Button;
		
		var list : ListBox;
		
		var combo : ComboBox;
		var progressBar : ProgressBar;
		var progressSlider : ProgressSlider;
		var toggleButton : ToggleButton;
		var checkBoxGroup : CheckBoxGroup;
		var radioButtonGroup : RadioButtonGroup;
		var label : Label;
		var inputBox : TextInput;
		var alertButton : Button;
		var showWindowButton : Button;
		var window : Window;
		var tabPane : TabPane;
		var scrollBar : ScrollBar;
		var scrollPane :ScrollPane;
		var itemPane : ItemPane;
		var accordion:Accordion;

		var themeList : ComboBox;

		var content:BaseContainer = new BaseContainer({"width": stage.stageWidth - 300, "height":stage.stageHeight,"x":300,"y":0,"background":false});
		content.visible = false;

        // Standard Button
        button = new Button({"text":"Button", "width":100, "height":20, "x":20, "y":20});
        
        // Button with Right Arrow(Play Icon) and no text
		iconButton = new Button({"text":"Icon", "width":100, "height":20, "showLabel":false, "x":button.x, "y": (button.y + button.height + 20)});
        iconButton.setIcon(CompositeManager.displayObjectToBitmap(new ArrowRightIcon({"width":10, "height":10, "baseColor":0xFFFFFF})));
        iconButton.draw();
		
        iconTextButton = new Button({"text":"Text", "width":100, "height":20, "x":iconButton.x, "y":(iconButton.y + iconButton.height + OFFSET), "imageOffSetX":10, "imageOffSetY":5});
        iconTextButton.setIcon(CompositeManager.displayObjectToBitmap(new StopIcon({"width":10, "height":10})));
        iconTextButton.draw();
		
        alertButton = new Button({"text":"Alert Box", "width": 100, "height":20,"x":iconTextButton.x,"y":(iconTextButton.y + iconTextButton.height + OFFSET)});
        alertButton.addEventListener(MouseEvent.CLICK, onAlertButton, false, 0, true);
		
        // List
		var listData:Array<Dynamic> = new Array<Dynamic>();
		listData.push({"text":"Erick", "value":"1"});
		listData.push({"text":"Nick", "value":"2"});
		listData.push({"text":"Bobby", "value":"3"});
		listData.push({"text":"Tim", "value":"4"});
		listData.push({"text":"Danny", "value":"5"});
		listData.push({"text":"Andy", "value":"6"});
		listData.push({"text":"Zack", "value":"7"});
		
        list = new ListBox({"width":100, "height":100, "x":(button.x + button.width + OFFSET), "y":button.y, "data":listData});
        
        // ComboBox
		var comboData:Array<Dynamic> = new Array<Dynamic>();
		comboData.push({"text":"Windows 10", "value":"1"});
		comboData.push({"text":"MacOS X", "value":"2"});
		comboData.push({"text":"iOS", "value":"3"});
		comboData.push({"text":"Ubuntu Linux", "value":"4"});
		comboData.push({"text":"Android", "value":"5"});
		comboData.push({"text":"Haiku OS", "value":"6"});
		
        combo = new ComboBox({"width":100, "height":20, "x":(list.x + list.width + OFFSET), "y":list.y, "data":comboData});
        
        // ProgressBar
        progressBar = new ProgressBar({"width":100,"height":20,"percent":50,"x":combo.x,"y":(combo.y + combo.height + OFFSET)});
        
        // ProgressSlider
        progressSlider = new ProgressSlider({"width":100,"height":20,"x":progressBar.x,"y":(progressBar.y + progressBar.height + OFFSET)});
        
        // Toggle Button
        toggleButton = new ToggleButton({"width":100, "height":30,"x":progressSlider.x,"y":(progressSlider.y + progressSlider.height + OFFSET)});
        
        // Check Box Group
		var checkBoxData:Array<Dynamic> = new Array<Dynamic>();
		checkBoxData.push({"name":"Check1", "text":"CheckBox 1"});
		checkBoxData.push({"name":"Check2", "text":"CheckBox 2"});
		checkBoxData.push({"name":"Check3", "text":"CheckBox 3"});
		
        checkBoxGroup = new CheckBoxGroup({"name":"checkGroup", "width":300, "height":30,"background":false, "x":(toggleButton.x + toggleButton.width + 20), "y":combo.y, "data":checkBoxData});
        
        // Radio Buttion Group
		var radioButtonData:Array<Dynamic> = new Array<Dynamic>();
		radioButtonData.push({"name":"Radio1", "text":"Radio 1"});
		radioButtonData.push({"name":"Radio2", "text":"Radio 2"});
		radioButtonData.push({"name":"Radio3", "text":"Radio 3"});
		
		
        // Use the UIStyleManager class to adjust the radio buton label and dot if need bet
        radioButtonGroup = new RadioButtonGroup({"name":"radioButtonGroup", "width":300, "height":30, "background":false, "data":radioButtonData, "x":checkBoxGroup.x, "y":(checkBoxGroup.y + checkBoxGroup.height + 20)});
        
        // Label and Tool-Tip
        label = new Label({"text":"Label", "width":50, "height":20,"x":radioButtonGroup.x,"y":radioButtonGroup.y + radioButtonGroup.height + OFFSET });
        
        
        // Input Box
        inputBox = new TextInput({"defaultString":"Type Here", "width":100, "height":20, "x":(label.x + label.width + OFFSET),"y":label.y});
		
		// Show button for Windows
        showWindowButton = new Button({"text":"Show Window", "width":100, "height":20, "x":(inputBox.x + inputBox.width + OFFSET), "y":inputBox.y});
        showWindowButton.addEventListener(MouseEvent.CLICK, onShowWindowClick, false, 0, true);
        
        window = new Window({"name":"window","width":200, "height":200,  "Label":{"text":"Window"}});
		window.x = ((stage.stageWidth / 2) - (window.width / 2));
		window.y = ((stage.stageHeight / 2) - (window.height / 2));
		
		
        // Attach events
        window.closeButton.addEventListener(MouseEvent.CLICK, onHideWindow, false, 0, true);
        window.minButton.addEventListener(MouseEvent.CLICK, onHideWindow, false, 0, true);
        
        // Hide Window for button press
        window.visible = false;
        
        // Tab Pane
        tabPane = new TabPane({"width":300, "height":200,"x":alertButton.x,"y":(alertButton.y + alertButton.height + OFFSET)});
        tabPane.addItem("One", new Label({"text":"One", "width":100, "height":20}));
        tabPane.addItem("Two", new Label({"text":"Two", "width":100, "height":20}));
        tabPane.addItem("Three", new Label({"text":"Three", "width":100, "height":20}));
		
        
        // Box for Tool-tip
		
        // Setting the stage because isn't on stage already
        ToolTip.displayArea = this;
		UIStyleManager.setStyle(UIStyleManager.TOOLTIP_BUBBLE_LOC_Y, -10);
		
        var toolTipBox : MovieClip = new MovieClip();
        var toolBox : Shape = new Shape();
		
		toolBox.graphics.beginFill(0x666666);
		toolBox.graphics.drawRect(0, 0, 100, 20 );
		toolBox.graphics.endFill();
        
        ToolTip.followMouse = true;
        ToolTip.attach(toolTipBox, "Look a Tool-tip", 100, 100);
		
        toolTipBox.x = showWindowButton.x + showWindowButton.width + OFFSET;
        toolTipBox.y = showWindowButton.y;
        toolTipBox.addChild(toolBox);
        
        scrollBar = new ScrollBar();
        
        var dummyText : TextField = new TextField();
        dummyText.width = 200;
        dummyText.height = 75;
        dummyText.x = checkBoxGroup.x + checkBoxGroup.width + OFFSET;
        dummyText.y = checkBoxGroup.y;
        dummyText.multiline = true;
        dummyText.wordWrap = true;
        dummyText.text = GANGSTA_TEXT;
        
        var scrollContent : ScrollTextContent = new ScrollTextContent(dummyText, scrollBar);
        
        scrollPane = new ScrollPane({"width":300, "height":200, "x":(tabPane.x + tabPane.width + OFFSET), "y":tabPane.y});
        
        // This time creating bitmap shapes
        var shape1 : Shape = new Shape();
        var shape2 : Shape = new Shape();
		
		shape1.graphics.beginFill(0xFF0000);
		shape2.graphics.beginFill(0x00FF00);
		
		shape1.graphics.drawRect(0, 0, 600, 300);
		shape2.graphics.drawRect(0, 0, 600, 300);
		
		shape1.graphics.endFill();
		shape2.graphics.endFill();
		
        var shapeHolder : MovieClip = new MovieClip();
        
        // Add them to a bitmap holder and moving the second bitmap down
        shapeHolder.addChild(shape1);
        shapeHolder.addChild(shape2);
        shape1.y = shape2.y + shape1.height;
        
		
        // This is how you add an item to the scrollPane
        scrollPane.source = shapeHolder;
        
		
		var itemData:Array<Dynamic> = new Array<Dynamic>();
		itemData.push({"text":"Item 1", "value":"1"});
		itemData.push({"text":"Item 2", "value":"2"});
		itemData.push({"text":"Item 3", "value":"3"});
		itemData.push({"text":"Item 4", "value":"4"});
		itemData.push({"text":"Item 5", "value":"5"});
        
		
		
        itemPane = new ItemPane({"width":300, "height":200, "itemWidth":150, "mode":ScrollPolicy.ONLY_VERTICAL, "itemHeight":100 , "x": (scrollPane.x + scrollPane.width + OFFSET), "y":scrollPane.y, "data":itemData});
		
        // Menu System
		var subMenuData:Array<Dynamic> = new Array<Dynamic>();
		
		subMenuData.push({"text":"Sub Item 1", "value":"1-1"});
		subMenuData.push({"text":"Sub Item 2", "value":"1-2"});
		subMenuData.push({"text":"Sub Item 3", "value":"1-3"});
		
		
		var menuData:Array<Dynamic> = new Array<Dynamic>();
		menuData.push({"text":"Top Level", "value":"0", "data":subMenuData});
		
        var menu:Menu = new Menu({"name":"PeopleMenu", "width":100, "height":40, "border":true, "subBorder":true, "x":tabPane.x, "y":(tabPane.y + tabPane.height + OFFSET), "direction":"horizontal", "data":menuData});
        

		var accordionLabel1:Label = new Label({"text":"Section 1","width":100,"height":20});
		var accordionLabel2:Label = new Label({"text":"Section 2","width":100,"height":20});
		var accordionLabel3:Label = new Label({"text":"Section 3","width":100,"height":20});

        var sectionArray:Array<Dynamic> = [{"name":"Section1","text":"Section 1","content":accordionLabel1},{"name":"Section2","text":"Section 2","content":accordionLabel2},{"name":"Section3","text":"Section 3","content":accordionLabel3}];
        
        accordion  = new Accordion({"width":300,"height":160,"data":sectionArray,"x":menu.x + menu.width + OFFSET, "y":(menu.y )});

        // List
		var themeData:Array<Dynamic> = new Array<Dynamic>();
		themeData.push({"text":"Default", "value":"default"});
		themeData.push({"text":"Red", "value":"red"});
		themeData.push({"text":"Green", "value":"green"});
		themeData.push({"text":"Blue", "value":"blue"});
		
		var themeObj:Dynamic = {"name":"themeList","width":100,"height":20,"rowCount":4,"data":themeData,"x":(accordion.x + accordion.width + OFFSET),"y":accordion.y  };
        themeList = new ComboBox(themeObj);

		var themeButton:Button = new Button({"text":"Apply","width":100,"height":20,"x":themeList.x + themeList.width + OFFSET, "y":themeList.y});
		themeButton.addEventListener(MouseEvent.CLICK,onThemeBtnClick,false,0,true);

        ThreadManager.stage = stage;
        Slider.sliderEventMode = Slider.TIMER_MODE;
        
        content.addElement(button);
        content.addElement(iconButton);
        content.addElement(iconTextButton);
        content.addElement(list);
        
        content.addElement(progressBar);
        content.addElement(progressSlider);
        content.addElement(toggleButton);
        content.addElement(combo);
        content.addElement(checkBoxGroup);
        content.addElement(radioButtonGroup);
        content.addElement(label);
        content.addChild(toolTipBox);
        content.addElement(inputBox);
        content.addElement(alertButton);
        content.addElement(showWindowButton);
        content.addElement(tabPane);
        content.addElement(scrollBar);
        content.addChild(dummyText);
        content.addElement(scrollPane);
        
        content.addElement(itemPane);
        content.addElement(menu);
        content.addElement(accordion);
        content.addElement(window);		
		content.addElement(themeList);
		content.addElement(themeButton);

		return content;
	}

	private function onThemeBtnClick(event : Event ) : Void {
		var combo:ComboBox = cast(Utils.getNestedChild(_lastSection,"themeList"),ComboBox);
		
		switch(combo.getSelected().value) {

			case "default":
				_themeDefault.apply();
			case "red":
				_redTheme.apply();
			case "green":
				_greenTheme.apply();				
			case "blue":
				_blueTheme.apply();							
		}
	}

	private function onHideWindow(event : WindowEvent) : Void
    {
        Utils.getNestedChild(_lastSection,"window").visible = false;
    }
    
    private function onShowWindowClick(event : MouseEvent) : Void
    {
		Utils.getNestedChild(_lastSection,"window").visible = true;
    }
    
    private function onAlertButton(event : MouseEvent) : Void
    {
        var alertBox:Sprite = Alert.create("This is a Message Box", "Alert Box", [AlertButtonType.OK], null, null, onAlertButtonClick);
        addChild(alertBox);
    }
	
	private function onAlertButtonClick(event:Event) 
	{
		trace(cast(event.currentTarget, Button).name);
	}
}
