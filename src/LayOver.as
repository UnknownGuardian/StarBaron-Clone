package  
{
	import com.bit101.components.FPSMeter;
	import com.bit101.components.Label;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	/**
	 * ...
	 * @author UnknownGuardian
	 */
	public class LayOver extends Sprite
	{
		//starting coords of click
		public var startX:Number = 0;
		public var startY:Number = 0;
		
		public var fps:FPSMeter;
		public var numShips:Label;
		
		public function LayOver() 
		{
			addEventListener(Event.ADDED_TO_STAGE, init, false, 0, true);
		}
		public function init(e:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			fps = new FPSMeter(this);
			numShips = new Label(this, fps.width);
			stage.addEventListener(MouseEvent.MOUSE_DOWN, mDown, false, 0, true);
			stage.addEventListener(MouseEvent.MOUSE_UP, mUp, false, 0, true);
		}

		
		public function mDown(e:MouseEvent):void
		{
			stage.addEventListener(MouseEvent.MOUSE_MOVE, mMove, false, 0, true);
			startX = e.stageX;
			startY = e.stageY;
		}
		public function mUp(e:MouseEvent):void
		{
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, mMove);
			graphics.clear();
			//prevent double capture, if only a click not a selection
			if (Math.abs(startX - e.stageX) > 3 && Math.abs(startY - e.stageY) > 3)
			{
				getSelected(e.stageX, e.stageY);
			}
			trace("[LayOver] These ports: " + GameManager.selectedPorts + " are in GameManager.selectedPorts");
		}
		public function mMove(e:MouseEvent):void
		{
			graphics.clear();
			graphics.lineStyle(1, 0x067EE3, 0.8);
			graphics.beginFill(0x067EE3, 0.3);
			graphics.drawRect(startX, startY, e.stageX - startX, e.stageY - startY);
			graphics.endFill();
		}
		public function getSelected(endX:Number, endY:Number):void
		{
			trace("[LayOver] Num Ships before departure" + GameManager.allShips.length);
			//clear previous slected
			trace(startX, startY, endX, endY);
			
			
			GameManager.selectedPorts = new Vector.<Port>();
			
			//get bounding area rectangle
			var _width:Number = endX - startX;
			var _height:Number = endY - startY;
			if (_width < 0)
			{
				startX = endX;
				_width = Math.abs(_width);
			}
			if (_height < 0)
			{
				startY = endY;
				_height = Math.abs(_height);
			}
			var selectedRect:Rectangle = new Rectangle(startX, startY, _width, _height);
			
			//loop through lookcing for ports that are in rectangle
			for (var i:int = 0; i < GameManager.allPorts.length; i++)
			{
				var p:Port = GameManager.allPorts[i];
				//if ally, because you can only select allies
				if (p.isAlly)
				{
					//if selected rectangle has the point
					if (selectedRect.contains(p.x, p.y))
					{
						GameManager.selectedPorts.push(p);
					}
				}
			}
		}
	}

}












//old code
/*
package  
{
	import com.bit101.components.FPSMeter;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	/**
	 * ...
	 * @author UnknownGuardian
	 * /
	public class LayOver extends Sprite
	{
		//starting coords of click
		public var startX:Number = 0;
		public var startY:Number = 0;
		
		public function LayOver() 
		{
			addEventListener(Event.ADDED_TO_STAGE, init, false, 0, true);
		}
		public function init(e:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			var a:FPSMeter = new FPSMeter(this);
			stage.addEventListener(MouseEvent.MOUSE_DOWN, mDown, false, 0, true);
			stage.addEventListener(MouseEvent.MOUSE_UP, mUp, false, 0, true);
		}

		
		public function mDown(e:MouseEvent):void
		{
			stage.addEventListener(MouseEvent.MOUSE_MOVE, mMove, false, 0, true);
			startX = e.stageX;
			startY = e.stageY;
		}
		public function mUp(e:MouseEvent):void
		{
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, mMove);
			graphics.clear();
			getSelected(e.stageX, e.stageY);
			//trace("[LayOver] These ports: " + GameManager.selectedPorts + " are in GameManager.selectedPorts");
		}
		public function mMove(e:MouseEvent):void
		{
			graphics.clear();
			graphics.lineStyle(1, 0x067EE3, 0.8);
			graphics.beginFill(0x067EE3, 0.3);
			graphics.drawRect(startX, startY, e.stageX - startX, e.stageY - startY);
			graphics.endFill();
		}
		public function getSelected(endX:Number, endY:Number):void
		{
			//trace("[LayOver] Num Ships before departure" + GameManager.allShips.length);
			//clear previous slected
			trace(startX, startY, endX, endY);
			
			
			GameManager.selectedPorts = new Vector.<Port>();
			
			//get bounding area rectangle
			var _width:Number = endX - startX;
			var _height:Number = endY - startY;
			if (_width < 0)
			{
				startX = endX;
				_width = Math.abs(_width);
			}
			if (_height < 0)
			{
				startY = endY;
				_height = Math.abs(_height);
			}
			var selectedRect:Rectangle = new Rectangle(startX, startY, _width, _height);
			
			//loop through lookcing for ports that are in rectangle
			for (var i:int = 0; i < GameManager.allPorts.length; i++)
			{
				var p:Port = GameManager.allPorts[i];
				//if ally, because you can only select allies
				if (p.isAlly)
				{
					//if selected rectangle has the point
					if (selectedRect.contains(p.x, p.y))
					{
						GameManager.selectedPorts.push(p);
					}
				}
			}
		}
	}

}
*/