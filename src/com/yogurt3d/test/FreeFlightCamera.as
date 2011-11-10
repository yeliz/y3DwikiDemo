package com.yogurt3d.test
{
	import com.yogurt3d.core.cameras.Camera;
	import com.yogurt3d.core.managers.tickmanager.TickManager;
	import com.yogurt3d.core.managers.tickmanager.TimeInfo;
	import com.yogurt3d.core.objects.interfaces.ITickedObject;
	
	public class FreeFlightCamera extends Camera implements ITickedObject
	{
		
		public function FreeFlightCamera(_initInternals:Boolean=true)
		{
			super(_initInternals);
			TickManager.registerObject( this );
		}
		
		
		public function moveLocalX( _value:Number ):void{
			transformation.moveAlongLocal( _value,0,0 );
		}
		public function moveLocalZ( _value:Number ):void{
			transformation.moveAlongLocal( 0,0,_value );
		}
		
		public function updateWithTimeInfo(_timeInfo:TimeInfo):void
		{
		}
	}
}