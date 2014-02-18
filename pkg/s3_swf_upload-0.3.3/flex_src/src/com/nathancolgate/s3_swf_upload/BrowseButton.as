package com.nathancolgate.s3_swf_upload {
	
	import flash.display.*;
	import flash.events.MouseEvent;
	import flash.events.Event;
	import flash.net.*;

	public dynamic class BrowseButton extends Sprite {

		private var _playButton:flash.display.SimpleButton;
		
		public function BrowseButton(width:Number,
																	height:Number,
																	buttonUpUrl:String,
																	buttonDownUrl:String,
																	buttonOverUrl:String)
		{
			super();
			
			_playButton = new flash.display.SimpleButton();
			_playButton.useHandCursor = true;
			addChild(_playButton);
			
			// Hit Test
      var hit_test:Shape = new flash.display.Shape();            
			hit_test.graphics.beginFill(0xFFCC00);
      hit_test.graphics.drawRect(0, 0, width, height);            
			hit_test.graphics.endFill();
			_playButton.hitTestState = hit_test;
			
			// Up
			var upLoader:Loader = new Loader();
			upLoader.contentLoaderInfo.addEventListener(Event.COMPLETE,function(e:Event):void{ 
				_playButton.upState = new Bitmap(e.target.content.bitmapData);
			});
			upLoader.load(new URLRequest(buttonUpUrl));

			// Down
			var downLoader:Loader = new Loader();
			downLoader.contentLoaderInfo.addEventListener(Event.COMPLETE,function(e:Event):void{ 
				_playButton.downState = new Bitmap(e.target.content.bitmapData);
			});
			downLoader.load(new URLRequest(buttonDownUrl));
			
			// Over
			var overLoader:Loader = new Loader();
			overLoader.contentLoaderInfo.addEventListener(Event.COMPLETE,function(e:Event):void{ 
				_playButton.overState = new Bitmap(e.target.content.bitmapData);
			});
			overLoader.load(new URLRequest(buttonOverUrl));
		}


	}
}
