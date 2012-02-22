package {

	// --------------------- IMPORTS ---------------------------------
	
	// Import the flashtalking FTEvents class so we can listen for these events
	import com.flashtalking.events.FTEvent;
	// Import all the flashtalking buttons classes.
	import com.flashtalking.buttons.*;
	// Import the flashtalking component classes.
	import com.flashtalking.FT;
	import com.flashtalking.Expand;
	
	//Import Flash classes
	import flash.display.MovieClip;
	import fl.transitions.Tween;
	import fl.transitions.easing.*;
	import fl.transitions.TweenEvent;
	import flash.events.*;
	
	// ---------------------BEGIN MAIN CLASS --------------------------------

	public class Code_Expand_Click extends MovieClip {

		// Component Variables
		// Create instances of the ad setup component & also the expand component.
		public var myFT:FT = new FT();
		private var myExpand:Expand = new Expand();

		// Graphics Variables
		private var background_mc:MovieClip = new MovieClip();
		private var logo_mc:McLogo = new McLogo();
		private var graphics_mc:McGraphics = new McGraphics();
		private var graphicsOnStage:Boolean = false;

		// Expand Variables
		private var close_btn:FTCloseButton = new FTCloseButton();
		private var myContractTween:Tween;
		private var myExpandTween:Tween;
		private var closeButtonOnStage:Boolean=false;

		// Button Variables
		private var expand_btn:McExpand = new McExpand();
		private var contract_btn:McContract = new McContract();

		public function Code_Expand_Click():void {
			init();
		}

		private function init():void {
			
			myFT.soundOnAtStart = true;
			addChild(myFT);
			
			// Set the properties of the expand setup.
			// We set both the expand triggers to manual as we will be using custom buttons to expand
			// and contract the ad.
			myExpand.expandTrigger=Expand.MANUAL;
			myExpand.contractTrigger=Expand.MANUAL;
			myExpand.unexpandedWidth=728;
			myExpand.unexpandedHeight=90;
			myExpand.expandedWidth=728;
			myExpand.expandedHeight=270;
			addChild(myExpand);		
			
			addGraphics();
		}

		private function addGraphics():void {
			// Create the background box which animates open and close.
			background_mc.graphics.beginFill(0x993366);
			background_mc.graphics.drawRect(0,0,728, 90);
			background_mc.addEventListener(MouseEvent.CLICK, clickThrough);
			background_mc.buttonMode = true;
			addChild(background_mc);

			// Add the logo and text.
			logo_mc.x=24;
			logo_mc.y=15;
			logo_mc.mouseEnabled = false;
			addChild(logo_mc);
			
			expand_btn.buttonMode = true;
			expand_btn.x = 436;
			expand_btn.y = 52;
			addChild(expand_btn);
			
			contract_btn.buttonMode = true;
			contract_btn.x = 576;
			contract_btn.y = 52;
			contract_btn.alpha = 0.5;
			addChild(contract_btn);
			
			// Add event listeners for when the mouse rolls over / out of the ad.
			expand_btn.addEventListener(MouseEvent.CLICK, expandAd);
			contract_btn.removeEventListener(MouseEvent.CLICK, contractAd);			
		}
		
		private function clickThrough(evt:MouseEvent):void{
			myFT.clickTag(1);
		}

		private function expandAd(e:MouseEvent):void {
			expand_btn.alpha = 0.5;
			expand_btn.removeEventListener(MouseEvent.CLICK, expandAd);	
		
			//This call expands the div in which the ad is displayed to it's expanded size.
			myFT.expand();
			
			// Tween the pink background box to it's expanded size.
			myExpandTween=new Tween(background_mc,"height",Strong.easeOut,background_mc.height,myExpand.expandedHeight,1,true);
			myExpandTween.addEventListener(TweenEvent.MOTION_FINISH, addContent);
		}

		private function addContent(evt:TweenEvent):void {			
			
			contract_btn.alpha = 1;
			contract_btn.addEventListener(MouseEvent.CLICK, contractAd);	
			
			if (graphicsOnStage == false) {
				graphics_mc.x = 26;
				graphics_mc.y = 102;
				graphics_mc.mouseEnabled = false;
				addChild(graphics_mc);
				graphicsOnStage = true;
			}
			
			
			if (closeButtonOnStage == false) {
				// Add in the close button
				closeButtonOnStage=true;
				close_btn.x=658;
				close_btn.y=247;
				close_btn.addEventListener(MouseEvent.CLICK, closeButtonClicked);
				close_btn.buttonMode=true;
				addChild(close_btn);
			}
		}

		private function closeButtonClicked(evt:MouseEvent):void {
			background_mc.height=myExpand.unexpandedHeight;
			
			expand_btn.alpha = 1;
			expand_btn.addEventListener(MouseEvent.CLICK, expandAd);	
			
			//Remove all the graphics from the expanded area of the ad.
			removeGraphics();
		}

		private function contractAd(evt:MouseEvent):void {
			//Stop the expand tween to prevent multiple expand tweens.
			myExpandTween.stop();
			
			// Tween the pink background box to it's unexpanded size.
			myContractTween=new Tween(background_mc,"height",Strong.easeOut,background_mc.height,myExpand.unexpandedHeight,1,true);
			myContractTween.addEventListener(TweenEvent.MOTION_FINISH, closeAd);
			
			contract_btn.alpha = 0.5;
			contract_btn.removeEventListener(MouseEvent.CLICK, contractAd);	
			
			//Remove all the grpahics from the expanded area of the ad.
			removeGraphics();
		}

		private function closeAd(evt:TweenEvent):void {

			expand_btn.alpha = 1;
			expand_btn.addEventListener(MouseEvent.CLICK, expandAd);	

			//Stop the expand tween to prevent multiple expand tweens.
			myExpandTween.stop();
			
			//This call contracts the div to it's unexpanded size.
			myFT.contract();
		}
		
		private function removeGraphics():void{
			
			contract_btn.alpha = 0.5;
			contract_btn.removeEventListener(MouseEvent.CLICK, contractAd);	

			
			if (closeButtonOnStage) {
				// Remove the close button.
				removeChild(close_btn);
				closeButtonOnStage=false;
			}
			
			if (graphicsOnStage) {
				// Remove the close button.
				removeChild(graphics_mc);
				graphicsOnStage=false;
			}
		}
		
	}//Class
	
}//Package