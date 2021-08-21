package;
import com.chaos.form.FormBuilder;
import com.chaos.media.DisplayVideo;
import openfl.utils.Assets;
import com.chaos.media.DisplayImage;
import com.chaos.drawing.Canvas;
import openfl.events.KeyboardEvent;
import com.chaos.drawing.TileLayer;
import com.chaos.form.ui.InputField;
import com.chaos.media.event.SoundStatusEvent;
import motion.Actuate;
#if !html5
import sys.FileSystem;
#end
import com.chaos.media.SoundManager;
import com.chaos.mobile.ui.ToggleSwitch;

import com.chaos.mobile.ui.NavigationMenu;
import com.chaos.mobile.ui.MobileDropDown;
import com.chaos.mobile.ui.MobileButtonList;
import com.chaos.mobile.ui.MobileButton;
import com.chaos.mobile.ui.event.BreadcrumbEvent;
import com.chaos.mobile.ui.Carousel;
import com.chaos.mobile.ui.Breadcrumb;
import com.chaos.ui.theming.Theme;
import com.chaos.utils.Utils;
import com.chaos.ui.layout.BaseContainer;
import com.chaos.ui.Accordion;
import com.chaos.ui.ScrollTextContent;
import com.chaos.drawing.icon.ArrowRightIcon;
import com.chaos.drawing.icon.StopIcon;
import com.chaos.ui.Alert;
import com.chaos.ui.Button;
import com.chaos.ui.CheckBoxGroup;
import com.chaos.ui.ComboBox;
import com.chaos.ui.TextInput;
import com.chaos.utils.CompositeManager;
import com.chaos.ui.event.WindowEvent;
import com.chaos.ui.ItemPane;
import com.chaos.ui.Label;
import com.chaos.ui.ListBox;
import com.chaos.ui.Menu;
import com.chaos.ui.ProgressBar;
import com.chaos.ui.ProgressSlider;
import com.chaos.ui.RadioButtonGroup;
import com.chaos.ui.ScrollBar;
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

import openfl.display.MovieClip;
import openfl.display.Shape;
import openfl.display.Sprite;
import openfl.events.Event;
import openfl.events.MouseEvent;
import openfl.text.TextField;
import openfl.ui.Keyboard;

class Main extends Sprite
{
	public var OFFSET : Int = 20;

	private var accordion:Accordion;

	private var _uiDemoSection:Sprite;
	private var _mobileUIDemo:Sprite;
	private var _formUIDemo:Sprite;
	private var _soundDemo:Sprite;
	private var _drawingDemo:Sprite;
	private var _canvasDemo:Sprite;
	private var _imageDemo:Sprite;
	private var _videoDemo:Sprite;

	private var _lastSection:Sprite;

	private var _themeDefault:Theme;
	private var _redTheme:Theme;
	private var _greenTheme:Theme;
	private var _blueTheme:Theme;

	private var _levelNum:Int = 0;

	private var _soundManager:SoundManager;
	private var _soundEffectName:String = "Switch";

	private var _soundType:String = ".ogg";

	private var _firstSong:String = "";
	private var _secondSong:String = "";

	private var _currentPlayingFirstSong:String = "";
	private var _currentPlayingSecondSong:String = "";

	private var _secondsBeforeFade:Int = 4;

	private var _loadMusic:Bool = false;
	private var _musicLoadCount:Int = 0;

	public function new()
	{
		super();

		// Sound Manager
		_soundManager = new SoundManager();
		_soundManager.addEventListener(SoundStatusEvent.SOUND_LOADED ,onSoundLoaded, false, 0, true);

		#if !html5

		// Sound Effects
		_soundManager.load("Switch", Std.string(FileSystem.absolutePath("") + "/Assets/SwitchSoundEffect" + _soundType));
		_soundManager.load("Xbox", Std.string(FileSystem.absolutePath("") + "/Assets/Xbox Achievement" + _soundType));
		_soundManager.load("Rewind", Std.string(FileSystem.absolutePath("") + "/Assets/Rewind" + _soundType));
		_soundManager.load("Denied", Std.string(FileSystem.absolutePath("") + "/Assets/Denied" + _soundType));
		_soundManager.load("Ba Dum Tss", Std.string(FileSystem.absolutePath("") + "/Assets/Ba Dum Tss" + _soundType));

		#end

		// Theme system
		_themeDefault = new Theme();
		_redTheme = new Theme({"primaryColor":0xFF0000,"secondaryColor":0xfdccd4,"selectedColor":0xFF3656,"primaryTextColor":0x000000,"secondaryTextColor":0xFFFFFF,"highlightColor":0xa40621,"shadowColor":0xf6143a});
		_greenTheme = new Theme({"primaryColor":0x00FF00,"secondaryColor":0x65aa1b,"selectedColor":0x4d8014,"primaryTextColor":0x000000,"secondaryTextColor":0xFFFFFF,"highlightColor":0xade86c,"shadowColor":0x4d8014});
		_blueTheme = new Theme({"primaryColor":0x0000FF,"secondaryColor":0x0c91f0,"selectedColor":0x4d8014,"primaryTextColor":0x000000,"secondaryTextColor":0xFFFFFF,"highlightColor":0x0c91f0,"shadowColor":0x064471});

		// Set default theme
		_themeDefault.apply();

		// Setup Sections 1
		var secton1:BaseContainer = new BaseContainer({"width":300,"height":stage.stageHeight});
		var uiComponentButton:Button = new Button({"name":"ui","text":"UI Components","width":300,"height":20});
		var mobileComponentButton:Button = new Button({"name":"mobile","text":"Mobile Components","width":300,"height":20,"y":uiComponentButton.y + uiComponentButton.height});
		var formComponentButton:Button = new Button({"name":"form","text":"Form Components","width":300,"height":20,"y":mobileComponentButton.y + mobileComponentButton.height});

		secton1.addElement(uiComponentButton);
		secton1.addElement(mobileComponentButton);
		secton1.addElement(formComponentButton);

		// Setup Section 2
		var secton2:BaseContainer = new BaseContainer({"width":300,"height":stage.stageHeight});
		var soundComponentButton:Button = new Button({"name":"sound","text":"Sound Test","width":300,"height":20});
		
		secton2.addChild(soundComponentButton);

		var secton3:BaseContainer = new BaseContainer({"width":300,"height":stage.stageHeight});
		var tileComponentButton:Button = new Button({"name":"tile","text":"Tile Demo","width":300,"height":20});
		var canvasComponentButton:Button = new Button({"name":"canvus","text":"Canvas Demo","width":300,"height":20,"y":tileComponentButton.y + tileComponentButton.height});
		var imageComponentButton:Button = new Button({"name":"image","text":"Display Image Demo","width":300,"height":20,"y":canvasComponentButton.y + canvasComponentButton.height});
		var videoComponentButton:Button = new Button({"name":"video","text":"Display Video Demo","width":300,"height":20,"y":imageComponentButton.y + imageComponentButton.height});

		secton3.addElement(tileComponentButton);
		secton3.addElement(canvasComponentButton);
		secton3.addElement(imageComponentButton);
		//secton3.addElement(videoComponentButton);
		

        var sectionArray:Array<Dynamic> = [{"name":"Section1","text":"UI","content":secton1},{"name":"Section2","text":"Sound Manager","content":secton2},{"name":"Section3","text":"Drawing and Animation","content":secton3}];
        
        accordion = new Accordion({"width":300,"height":stage.stageHeight,"data":sectionArray,"x":0, "y":0});

		uiComponentButton.addEventListener(MouseEvent.CLICK, onUIComponentClick, false, 0, true);
		mobileComponentButton.addEventListener(MouseEvent.CLICK, onUIComponentClick, false, 0, true);
		soundComponentButton.addEventListener(MouseEvent.CLICK, onUIComponentClick, false, 0, true);
		tileComponentButton.addEventListener(MouseEvent.CLICK, onUIComponentClick, false, 0, true);
		canvasComponentButton.addEventListener(MouseEvent.CLICK, onUIComponentClick, false, 0, true);
		imageComponentButton.addEventListener(MouseEvent.CLICK, onUIComponentClick, false, 0, true);
		formComponentButton.addEventListener(MouseEvent.CLICK, onUIComponentClick, false, 0, true);
		//videoComponentButton.addEventListener(MouseEvent.CLICK, onUIComponentClick, false, 0, true);

		_uiDemoSection = createUIDemo();
		_mobileUIDemo = createMoblieDemo();
		_soundDemo = createSoundDemo();
		_drawingDemo = createSpriteSheetDemo();
		_canvasDemo = createCanvasDemo();
		_imageDemo = createImageDemo();
		//_videoDemo = createVideoDemo();
		_formUIDemo = createFormDemo();


		addChild(accordion);
		addChild(_uiDemoSection);
		addChild(_mobileUIDemo);
		addChild(_soundDemo);
		addChild(_drawingDemo);
		addChild(_canvasDemo);
		addChild(_imageDemo);
		addChild(_formUIDemo);
		//addChild(_videoDemo);

	}

	private function onUIComponentClick(event:MouseEvent):Void {

		var button:Button = cast(event.currentTarget,Button);

		if(_lastSection != null)
			_lastSection.visible = false;

		switch(button.name) {

			case "ui":
				_uiDemoSection.visible = true;
				_lastSection = _uiDemoSection;
			case "mobile":
				_mobileUIDemo.visible = true;
				_lastSection = _mobileUIDemo;
			case "sound":
				_soundDemo.visible = true;
				_lastSection = _soundDemo;		
			case "tile":
				_drawingDemo.visible = true;
				_lastSection = _drawingDemo;
			case "canvus":
				_canvasDemo.visible = true;
				_lastSection = _canvasDemo;
			case "image":
				_imageDemo.visible = true;
				_lastSection = _imageDemo;
			case "video":
				_videoDemo.visible = true;
				_lastSection = _videoDemo;
			case "form":
				_formUIDemo.visible = true;
				_lastSection = _formUIDemo;
	
		}
		
	}

	//////////////////
	// Desktop UI  //
	////////////////

	private function createUIDemo():Sprite {

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

		var content:Sprite = new Sprite();
		content.x = 300;
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
        
        content.addChild(button);
        content.addChild(iconButton);
        content.addChild(iconTextButton);
        content.addChild(list);
        
        content.addChild(progressBar);
        content.addChild(progressSlider);
        content.addChild(toggleButton);
        content.addChild(combo);
        content.addChild(checkBoxGroup);
        content.addChild(radioButtonGroup);
        content.addChild(label);
        content.addChild(toolTipBox);
        content.addChild(inputBox);
        content.addChild(alertButton);
        content.addChild(showWindowButton);
        content.addChild(tabPane);
        content.addChild(scrollBar);
        content.addChild(dummyText);
        content.addChild(scrollPane);
        
        content.addChild(itemPane);
        content.addChild(menu);
        content.addChild(accordion);
		content.addChild(themeList);
		content.addChild(themeButton);
		content.addChild(window);		

		return content;
	}

	private function onThemeBtnClick(event : Event ) : Void {
		var combo:ComboBox = cast(Utils.getNestedChild(_lastSection,"themeList"),ComboBox);
		
		if(combo.getSelected() == null)
			return;

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


	//////////////////
	// Moblie UI   //
	////////////////	

	private function createMoblieDemo() : Sprite {

		var content:Sprite = new Sprite();
		content.x = 300;
		content.visible = false;

				
		var breadcrumb:Breadcrumb = new Breadcrumb({"name":"breadcrumb", "width":400,"height":20});
		breadcrumb.addEventListener(BreadcrumbEvent.SELECTED, onLevelSelected,false,0,true);

		var addButton:MobileButton = new MobileButton({"name":"addCrumbBtn","text":"Add Level","width":100,"height":20,"x":breadcrumb.x + breadcrumb.width + OFFSET, "y":breadcrumb.y});
		addButton.addEventListener(MouseEvent.CLICK, addBreadcrumb , false, 0, true);


		var cardLabel:Label = new Label({"name":"cardlabel","text":"Card","width":100,"height":20,"y": 30});
		var card:Card = new Card({"name":"card","roundEdge":4,"width":100,"height":100,"x": breadcrumb.x + OFFSET, "y": breadcrumb.y + breadcrumb.height + OFFSET,"content":cardLabel});

		var carouselData:Array<Dynamic> = new Array<Dynamic>();
		var button1:MobileButton = new MobileButton({"name":"mobileBtn1","width":400,"height":200,"defaultColor":0xFF0000});
		var button2:MobileButton = new MobileButton({"name":"mobileBtn1","width":400,"height":200,"defaultColor":0x00FF00});
		var button3:MobileButton = new MobileButton({"name":"mobileBtn1","width":400,"height":200,"defaultColor":0x0000FF});

		carouselData.push({"name":"1","content":button1});
		carouselData.push({"name":"2","content":button2});
		carouselData.push({"name":"3","content":button3});

		var carousel:Carousel = new Carousel({"name":"carousel","width":400,"height":200,"x":card.x + card.width + OFFSET,"y":card.y,"data":carouselData});

		var buttonListData:Array<Dynamic> = new Array<Dynamic>();
		buttonListData.push({"text":"Button 1"});
		buttonListData.push({"text":"Button 2"});
		buttonListData.push({"text":"Button 3"});
		buttonListData.push({"text":"Button 4"});

		var buttonList:MobileButtonList = new MobileButtonList({"name":"buttonList","width":100,"height":160,"x":card.x,"y":card.y + card.height + OFFSET,"data":buttonListData});

		// Level One Menus
		var navMenuLevel1_3Data:Array<Dynamic> = new Array<Dynamic>();
		navMenuLevel1_3Data.push({"text":"Level 1-3-1"});
		navMenuLevel1_3Data.push({"text":"Level 1-3-2"});
		navMenuLevel1_3Data.push({"text":"Level 1-3-3"});
		navMenuLevel1_3Data.push({"text":"Level 1-3-4"});

		var navMenuLevel1Data:Array<Dynamic> = new Array<Dynamic>();
		navMenuLevel1Data.push({"text":"Level 1-1"});
		navMenuLevel1Data.push({"text":"Level 1-2"});
		navMenuLevel1Data.push({"text":"Level 1-3","children":navMenuLevel1_3Data});
		navMenuLevel1Data.push({"text":"Level 1-4"});

		// Level Two Menus
		var navMenuLevel4Data:Array<Dynamic> = new Array<Dynamic>();
		navMenuLevel4Data.push({"text":"Level 4-1"});
		navMenuLevel4Data.push({"text":"Level 4-2"});

		var navMenuData:Array<Dynamic> = new Array<Dynamic>();
		navMenuData.push({"text":"Main 1","children":navMenuLevel1Data});
		navMenuData.push({"text":"Main 2"});
		navMenuData.push({"text":"Main 3"});
		navMenuData.push({"text":"Main 4","children":navMenuLevel4Data});
		navMenuData.push({"text":"Main 5"});

		var navigationMenu:NavigationMenu = new NavigationMenu({"name":"navMenu","width":400,"height":200,"x":carousel.x,"y":carousel.y + carousel.height + OFFSET,"data":navMenuData});
		var backButton:MobileButton = new MobileButton({"name":"backBtn","text":"Navigation Back","width":100,"height":20,"x":navigationMenu.x + navigationMenu.width + OFFSET, "y":navigationMenu.y});
		backButton.addEventListener(MouseEvent.CLICK, onNavMenuBack, false, 0, true);

		var toggleSwitch:ToggleSwitch = new ToggleSwitch({"name":"toggleSwitch","width":40,"height":20,"x":carousel.x + carousel.width + OFFSET, "y":carousel.y});
		
		var buttonDropDownData:Array<Dynamic> = new Array<Dynamic>();
		buttonDropDownData.push({"text":"Button 1"});
		buttonDropDownData.push({"text":"Button 2"});
		buttonDropDownData.push({"text":"Button 3"});
		buttonDropDownData.push({"text":"Button 4"});

		var mobileDropDown:MobileDropDown = new MobileDropDown({"name":"mobileDropDown","width":200,"height":20,"x": toggleSwitch.x,"y": toggleSwitch.y + toggleSwitch.height + OFFSET, "data":buttonDropDownData});


		content.addChild(breadcrumb);
		content.addChild(addButton);
		content.addChild(card);
		content.addChild(carousel);
		content.addChild(buttonList);
		content.addChild(navigationMenu);
		content.addChild(mobileDropDown);
		content.addChild(backButton);
		content.addChild(toggleSwitch);

		return content;
	}

	private function addBreadcrumb( event:Event ):Void {

		if(cast(Utils.getNestedChild(_lastSection,"addCrumbBtn"), MobileButton).enabled) {
			var breadcrumb:Breadcrumb = cast(Utils.getNestedChild(_lastSection,"breadcrumb"), Breadcrumb);
			breadcrumb.addLevel("Level" + (_levelNum + 1));
			
			_levelNum++;
	
			var button:MobileButton = cast(Utils.getNestedChild(_lastSection,"addCrumbBtn"), MobileButton);
			button.enabled = (_levelNum <= 5);
			button.draw();
	
		}
	}

	private function onNavMenuBack( event:MouseEvent ): Void {

		var navigation:NavigationMenu = cast(Utils.getNestedChild(_lastSection,"navMenu"), NavigationMenu);
		navigation.goToPrevious();

	}

	private function onLevelSelected( event:BreadcrumbEvent ): Void {
		var breadcrumb:Breadcrumb = cast(Utils.getNestedChild(_lastSection,"breadcrumb"), Breadcrumb);
		breadcrumb.jumpToLevel(event.level + 1);

		_levelNum = event.level + 1;

		var button:MobileButton = cast(Utils.getNestedChild(_lastSection,"addCrumbBtn"), MobileButton);
		button.enabled = (_levelNum <= 5);
		button.draw();

	}

	//////////////////
	// Form UI     //
	////////////////	

	private function createFormDemo() : Sprite {
		var content:Sprite = new Sprite();
		content.x = 300;
		content.visible = false;

		var form:FormBuilder = new FormBuilder({"width":400,"height":400,"x":100,"y":100});

		form.addFormElement("FirstName","firstName",new InputField());
		form.draw();
		
		content.addChild(form);

		return content;
	}

	//////////////////
	// Sound Demo  //
	////////////////	

	private function createSoundDemo() : Sprite {

		var content:Sprite = new Sprite();
		content.x = 300;
		content.visible = false;

		var leftSoundButton:Button = new Button({"name":"leftSoundBtn","text":"Left","width":100,"height":20,"x":OFFSET,"y":OFFSET});
		var centerSoundButton:Button = new Button({"name":"centerSoundBtn","text":"Center","width":100,"height":20,"x":leftSoundButton.x + leftSoundButton.width + OFFSET,"y":leftSoundButton.y});
		var rightSoundButton:Button = new Button({"name":"rightSoundBtn","text":"Right","width":100,"height":20,"x":centerSoundButton.x + centerSoundButton.width + OFFSET,"y":centerSoundButton.y});

		leftSoundButton.addEventListener(MouseEvent.CLICK, onSoundPanBtnClick, false, 0, true);
		centerSoundButton.addEventListener(MouseEvent.CLICK, onSoundPanBtnClick, false, 0, true);
		rightSoundButton.addEventListener(MouseEvent.CLICK, onSoundPanBtnClick, false, 0, true);
		

        // Sound Effect List
		var soundDataArray:Array<Dynamic> = new Array<Dynamic>();
		soundDataArray.push({"text":"Switch", "value":"Switch"});
		soundDataArray.push({"text":"Xbox", "value":"Xbox"});
		soundDataArray.push({"text":"Rewind", "value":"Rewind"});
		soundDataArray.push({"text":"Denied", "value":"Denied"});
		soundDataArray.push({"text":"Ba Dum Tss", "value":"Ba Dum Tss"});
		
        var soundEffectList:ListBox = new ListBox({"width":100, "height":100, "x":(rightSoundButton.x + rightSoundButton.width + OFFSET), "y":rightSoundButton.y, "data":soundDataArray});		
		soundEffectList.addEventListener(Event.CHANGE, onSoundListChange, false, 0, true);

		var musicDataArray:Array<Dynamic> = new Array<Dynamic>();
		musicDataArray.push({"text":"All that", "value":"All that"});
		musicDataArray.push({"text":"Funky Element", "value":"Funky Element"});
		musicDataArray.push({"text":"Groovy Hip-Hop", "value":"Groovy Hip-Hop"});
		musicDataArray.push({"text":"Inspire", "value":"Inspire"});
		musicDataArray.push({"text":"Straight", "value":"Straight"});

		var multiplier:Int = 8;

		var music1:ListBox = new ListBox({"name":"music1","width":leftSoundButton.width, "height":100, "x":leftSoundButton.x, "y":leftSoundButton.y + leftSoundButton.height + (OFFSET * multiplier), "data":musicDataArray});		
		var music2:ListBox = new ListBox({"name":"music2","width":rightSoundButton.width, "height":100, "x":rightSoundButton.x, "y":rightSoundButton.y + rightSoundButton.height + (OFFSET * multiplier), "data":musicDataArray});

		music1.addEventListener(Event.CHANGE, onMusicListChange, false, 0, true);
		music2.addEventListener(Event.CHANGE, onMusicListChange, false, 0, true);
		
		var delayInputBox:TextInput = new TextInput({"name":"delayInput","defaultString":"Delay","border":true,"width":centerSoundButton.width, "height":20, "x":centerSoundButton.x,"y":music1.y});
		delayInputBox.textField.restrict = "0-9";
		delayInputBox.textField.maxChars = 1;

		var startButton:Button = new Button({"name":"startSoundBtn","text":"Start","width":100,"height":20,"x":delayInputBox.x,"y":delayInputBox.y + delayInputBox.height + OFFSET});
		var stopButton:Button = new Button({"name":"stopSoundBtn","text":"Stop","width":100,"height":20,"x":startButton.x,"y":startButton.y + startButton.height + OFFSET});

		startButton.addEventListener(MouseEvent.CLICK, onFadeOverClick, false, 0, true);
		stopButton.addEventListener(MouseEvent.CLICK, onStopSoundButtonClick, false, 0, true);

		var label:Label = new Label({"name":"fadeMusicLabel","x":music1.x,"y":music1.y - OFFSET,"width": music1.width + music2.width + startButton.width,"height":stopButton.height,
		"textColor":0,"text":"Select Music and delay amount for fade effect."});

		content.addChild(leftSoundButton);
		content.addChild(centerSoundButton);
		content.addChild(rightSoundButton);
		content.addChild(soundEffectList);
		content.addChild(label);

		content.addChild(music1);
		content.addChild(music2);
		content.addChild(delayInputBox);
		content.addChild(startButton);
		content.addChild(stopButton);
		
		return content;
	}

	private function onMusicListChange(event : Event) : Void {

		var label:Label = cast(Utils.getNestedChild(_lastSection,"fadeMusicLabel"), Label);
		var music1:ListBox = cast(Utils.getNestedChild(_lastSection,"music1"), ListBox);
		var music2:ListBox = cast(Utils.getNestedChild(_lastSection,"music2"), ListBox);

		var delayInputBox:TextInput = cast(Utils.getNestedChild(_lastSection,"delayInput"), TextInput);

		if(music1.selectIndex() != -1 && music2.selectIndex() != -1 && !delayInputBox.isEmpty()) {
			label.text = "Select the Start button to play music";
			label.draw();
		}

	}

	private function onSoundListChange( event : Event ) : Void {

		var list:ListBox = cast(event.currentTarget, ListBox);
		_soundEffectName = list.getSelected().value;
	}

	private function onFadeOverClick( event : Event ) : Void {

		var label:Label = cast(Utils.getNestedChild(_lastSection,"fadeMusicLabel"), Label);
		var music1:ListBox = cast(Utils.getNestedChild(_lastSection,"music1"), ListBox);
		var music2:ListBox = cast(Utils.getNestedChild(_lastSection,"music2"), ListBox);

		var delayInputBox:TextInput = cast(Utils.getNestedChild(_lastSection,"delayInput"), TextInput);

		if( music1.selectIndex() > -1 && !delayInputBox.isEmpty() && music2.selectIndex() > -1) {

			_loadMusic = true;
			_musicLoadCount = 0;

			label.text = "Playing first track";
			label.draw();

			// Check to see if sound has been loaded and unload if it is there
			if(_firstSong != "")
				_soundManager.removeSound(_firstSong);

			if(_secondSong != "")
				_soundManager.removeSound(_secondSong);


			_firstSong = music1.getSelected().value;
			_secondSong = music2.getSelected().value;

			// Load in new sound effect
			loadMusic(music1.getSelected().value);
			loadMusic(music2.getSelected().value);
		}


	}

	private function loadMusic( song:String ) : Void {

		switch(song) {

			case "All that":
				_soundManager.load("All that", Std.string(FileSystem.absolutePath("") + "/Assets/bensound-allthat" + _soundType));

			case "Funky Element":
				_soundManager.load("Funky Element", Std.string(FileSystem.absolutePath("") + "/Assets/bensound-funkyelement" + _soundType));

			case "Groovy Hip-Hop":
				_soundManager.load("Groovy Hip-Hop", Std.string(FileSystem.absolutePath("") + "/Assets/bensound-groovyhiphop" + _soundType));

			case "Inspire":
				_soundManager.load("Inspire", Std.string(FileSystem.absolutePath("") + "/Assets/bensound-inspire" + _soundType));

			case "Straight":
				_soundManager.load("Straight", Std.string(FileSystem.absolutePath("") + "/Assets/bensound-straight" + _soundType));


		}

	}

	private function onSoundLoaded( event:SoundStatusEvent ) : Void {

		if(_loadMusic) {
			
			_musicLoadCount++;

			if(_musicLoadCount == 2) {

				var delayInputBox:TextInput =  cast(Utils.getNestedChild(_lastSection,"delayInput"), TextInput);
				_soundManager.playSound(_firstSong);

				Actuate.timer(Std.parseInt(delayInputBox.text)).onComplete(startFadeEffect);
			}
		}
			
	}

	private function onStopSoundButtonClick( event:MouseEvent ) : Void {

		var label:Label = cast(Utils.getNestedChild(_lastSection,"fadeMusicLabel"), Label);
		label.text = "Select Music and delay amount for fade effect.";
		label.draw();

		_soundManager.stopSound(_firstSong);
		_soundManager.stopSound(_secondSong);
	}

	private function startFadeEffect() : Void {

		var label:Label = cast(Utils.getNestedChild(_lastSection,"fadeMusicLabel"), Label);
		label.text = "Started Cross Fade";
		label.draw();

		_soundManager.crossFade(_firstSong, _secondSong, 100, onFadeComplete);
	}

	private function onFadeComplete(value : Dynamic) : Void {

		var label:Label = cast(Utils.getNestedChild(_lastSection,"fadeMusicLabel"), Label);
		label.text = "Cross Fade done, you can press the stop button.";
		label.draw();

	}

	private function onSoundPanBtnClick( event : MouseEvent ) : Void {

		var button:Button = cast(event.currentTarget, Button);

		// In order for panning to work the sound must be mono
		if(button.name == "centerSoundBtn") {
			_soundManager.playSound(_soundEffectName);
			_soundManager.setPan(_soundEffectName,0);
		}
		else {
			_soundManager.playSound(_soundEffectName);
			_soundManager.setPan(_soundEffectName,button.name == "leftSoundBtn" ? -100 : 100);
		} 

	}

	//////////////////
	//  Tile Demo  //
	////////////////	
	
	
	private function createSpriteSheetDemo():Sprite {

		var content:Sprite = new Sprite();
		content.x = 300;
		content.visible = false;

		var leftButton:Button = new Button({"name":"left","text":"Left","width":100,"height":20});
		var rightButton:Button = new Button({"name":"right","text":"Right","width":100,"height":20});
		var topButton:Button = new Button({"name":"top","text":"Top","width":100,"height":20});
		var bottomButton:Button = new Button({"name":"bottom","text":"Bottom","width":100,"height":20});

		var tileLayer:TileLayer = new TileLayer({"name":"tileLayer","useMask":true,"cacheTiles":true,"assetPrefix":"assets/","tileFile":"assets/Dungeon Top Down.json","tileMap":"assets/TileMap.json","x":leftButton.width + (OFFSET * 2),"y":topButton.height + OFFSET ,"width":400,"height":400});
		content.addChild(tileLayer);

		leftButton.x = OFFSET;
		leftButton.y = (tileLayer.height / 2) + (leftButton.height / 2);

		rightButton.x = tileLayer.x + tileLayer.width + OFFSET;
		rightButton.y = leftButton.y;

		topButton.x = tileLayer.x + (tileLayer.width / 2) - (topButton.width / 2);

		bottomButton.x = topButton.x;
		bottomButton.y = tileLayer.y + tileLayer.height + OFFSET;

		leftButton.addEventListener(MouseEvent.CLICK,onTileButtonClick,false,0,true);
		rightButton.addEventListener(MouseEvent.CLICK,onTileButtonClick,false,0,true);
		topButton.addEventListener(MouseEvent.CLICK,onTileButtonClick,false,0,true);
		bottomButton.addEventListener(MouseEvent.CLICK,onTileButtonClick,false,0,true);

		content.addChild(leftButton);
		content.addChild(rightButton);
		content.addChild(topButton);
		content.addChild(bottomButton);

		return content;

	}

	private function onTileButtonClick(event:MouseEvent) { 

		var tileLayer:TileLayer = cast(Utils.getNestedChild(_lastSection,"tileLayer"), TileLayer);
		var button:Button = cast(event.currentTarget, Button);

		switch(button.name)
		{
			case "right": 
				tileLayer.right();
			case "left":
				tileLayer.left();
			case "bottom":
				tileLayer.down();
			case "top":
				tileLayer.up();
		}
	}

	//////////////////
	// Canvas Demo //
	////////////////	

	private function createCanvasDemo():Sprite {
		
		var content:Sprite = new Sprite();
		content.x = 300;
		content.visible = false;	

		var canvasShapeData:Array<Dynamic> = new Array<Dynamic>();

		canvasShapeData.push({"Layer":{"name":"base"}});
		canvasShapeData.push({"Square":{"name":"square1","layerName":"base","width":100,"height":100,"x":100,"y":100,"color":0xFF0000}});
		canvasShapeData.push({"Line":{"name":"line1","layerName":"base","startX":0,"startY":0,"endX":400,"endY":400,"thinkness":1,"color":0xFF0000}});
		canvasShapeData.push({"Circle":{"name":"circle","layerName":"base","radius":10,"x":200,"y":300,"thinkness":1,"color":0x000000}});
		canvasShapeData.push({"HelixOutline":{"name":"helix","layerName":"base","styleMarker":0,"radius":50,"x":200,"y":300,"objectX":0,"objectY":2,"thinkness":1,"color":0x0000FF}});
		canvasShapeData.push({"Hexagon":{"name":"hexagon1","layerName":"base","radius":100,"x":400,"y":200,"objectX":0,"objectY":0,"thinkness":1,"color":0xFFFF00}});
		canvasShapeData.push({"RoundSquare":{"name":"square2","layerName":"base","roundEdge":20,"width":400,"height":100,"x":100,"y":500,"color":0xFF0000}});



		var canvas:Canvas = new Canvas({"data":canvasShapeData});

		content.addChild(canvas);

		return content;
	}

	//////////////////
	// Image Demo  //
	////////////////
	
	private function createImageDemo():Sprite {

		var content:Sprite = new Sprite();
		content.x = 300;
		content.visible = false;

		var gold:DisplayImage = new DisplayImage({"name":"gold","image":Assets.getBitmapData("assets/gold.jpg"),"width":400,"height":400});
		var black:DisplayImage = new DisplayImage({"name":"black","image":Assets.getBitmapData("assets/black.jpg"),"x":gold.width});
		var green:DisplayImage = new DisplayImage({"name":"green","image":Assets.getBitmapData("assets/green.jpg"),"y":gold.height});
		var purple:DisplayImage = new DisplayImage({"name":"purple","image":Assets.getBitmapData("assets/purple.jpg"),"x":black.x,"y":gold.height});

		content.addChild(gold);
		content.addChild(black);
		content.addChild(green);
		content.addChild(purple);

		return content;
	 }

	//////////////////
	// Video Demo  //
	////////////////	 
	
	private function createVideoDemo():Sprite {

		var content:Sprite = new Sprite();
		content.x = 300;
		content.visible = false;

		var video:DisplayVideo = new DisplayVideo({"name":"video","width":800,"height":600});
		
		#if !html5

		video.load(FileSystem.absolutePath("") + "/Assets/The Legend of Zelda Skyward Sword HD – Your Destiny Awaits – Nintendo Switch.mp4", false);

		#end

		var playButton:Button = new Button({"text":"Icon", "width":100, "height":20, "showLabel":false, "x":video.width, "y": (video.y + video.height + 20)});
        playButton.setIcon(CompositeManager.displayObjectToBitmap(new ArrowRightIcon({"width":10, "height":10, "baseColor":0xFFFFFF})));
        playButton.draw();

		playButton.addEventListener(MouseEvent.CLICK,onVideoPlayButtonClick,false,0,true);

		content.addChild(playButton);
		content.addChild(video);
		

		return content;
	}

	private function onVideoPlayButtonClick(event:MouseEvent) : Void {

		var video:DisplayVideo = cast(Utils.getNestedChild(_lastSection,"video"), DisplayVideo);
		video.play();

	}

}
